import json
import logging
from collections import defaultdict
from pathlib import Path
from typing import Any

from app.core.config import settings

from app.graph.models import (
    GraphColumn,
    GraphNeighbor,
    GraphRelationship,
    GraphTable,
    SchemaGraphSummary,
)

from app.schema.relationships.models import (
    RelationshipStatus,
)


logger = logging.getLogger(__name__)


# =========================================================
# EXCEPTIONS
# =========================================================


class SchemaGraphError(Exception):
    """
    Base exception for schema graph errors.
    """

    pass


class SchemaGraphLoadError(
    SchemaGraphError
):
    """
    Raised when graph source artifacts
    cannot be loaded.
    """

    pass


class SchemaGraphIntegrityError(
    SchemaGraphError
):
    """
    Raised when graph artifacts contain
    inconsistent schema information.
    """

    pass


# =========================================================
# SCHEMA GRAPH
# =========================================================


class SchemaGraph:
    """
    Enterprise in-memory schema graph.

    Sources:

    1. enriched_schema_catalog.json

    2. graph_ready_relationships.json


    Responsibilities:

    - Load business tables
    - Load columns
    - Load trusted relationships
    - Validate relationship integrity
    - Build bidirectional adjacency index
    - Provide deterministic graph access


    This class DOES NOT:

    - Perform semantic search
    - Generate embeddings
    - Generate SQL
    - Call an LLM
    - Find multi-hop paths

    Multi-hop path finding belongs in:

        join_path_finder.py
    """

    EXPECTED_RELATIONSHIP_SCHEMA_VERSION = (
        "2.0"
    )

    def __init__(
        self,
        schema_hash: str,
        tables: dict[
            str,
            GraphTable,
        ],
        relationships: dict[
            str,
            GraphRelationship,
        ],
    ) -> None:

        if not schema_hash:

            raise SchemaGraphIntegrityError(
                "SchemaGraph requires a "
                "non-empty schema_hash."
            )

        self._schema_hash = (
            schema_hash
        )

        # Copy dictionaries so outside code
        # cannot mutate our input references.

        self._tables = dict(
            tables
        )

        self._relationships = dict(
            relationships
        )

        # -------------------------------------------------
        # Relationship adjacency
        #
        # Example:
        #
        # trip -> [rel_trip_customer, rel_trip_vehicle]
        #
        # customer -> [rel_trip_customer]
        #
        # Important:
        # adjacency is bidirectional for traversal.
        # Canonical relationship direction is still
        # preserved inside GraphRelationship.
        # -------------------------------------------------

        adjacency: dict[
            str,
            list[str],
        ] = defaultdict(
            list
        )

        for (
            relationship_id,
            relationship,
        ) in self._relationships.items():

            adjacency[
                relationship.source_table
            ].append(
                relationship_id
            )

            adjacency[
                relationship.target_table
            ].append(
                relationship_id
            )

        # Deterministic ordering

        self._adjacency: dict[
            str,
            tuple[str, ...],
        ] = {

            table_name: tuple(
                sorted(
                    relationship_ids
                )
            )

            for (
                table_name,
                relationship_ids,
            ) in adjacency.items()
        }

        # Ensure isolated business tables also
        # exist in adjacency index.

        for table_name in self._tables:

            self._adjacency.setdefault(
                table_name,
                (),
            )

        logger.info(
            "SchemaGraph initialized. "
            "Tables=%d Relationships=%d",
            len(
                self._tables
            ),
            len(
                self._relationships
            ),
        )

    # =====================================================
    # FACTORY: SETTINGS
    # =====================================================

    @classmethod
    def from_settings(
        cls,
    ) -> "SchemaGraph":
        """
        Build graph using configured project paths.

        Expected config:

        ENRICHED_SCHEMA_CATALOG_PATH
        GRAPH_READY_RELATIONSHIPS_PATH
        """

        return cls.from_files(

            enriched_schema_path=Path(
                settings
                .ENRICHED_SCHEMA_CATALOG_PATH
            ),

            relationships_path=Path(
                settings
                .GRAPH_READY_RELATIONSHIPS_PATH
            ),
        )

    # =====================================================
    # FACTORY: FILES
    # =====================================================

    @classmethod
    def from_files(
        cls,
        enriched_schema_path: Path,
        relationships_path: Path,
    ) -> "SchemaGraph":
        """
        Load and validate graph artifacts.
        """

        logger.info(
            "Loading enriched schema graph source: %s",
            enriched_schema_path,
        )

        enriched_catalog = (
            cls._load_json(
                enriched_schema_path
            )
        )

        logger.info(
            "Loading graph-ready relationships: %s",
            relationships_path,
        )

        relationship_catalog = (
            cls._load_json(
                relationships_path
            )
        )

        # -------------------------------------------------
        # Validate source artifacts
        # -------------------------------------------------

        schema_hash = (
            cls._validate_artifacts(
                enriched_catalog=(
                    enriched_catalog
                ),
                relationship_catalog=(
                    relationship_catalog
                ),
            )
        )

        # -------------------------------------------------
        # Build table nodes
        # -------------------------------------------------

        tables = (
            cls._build_tables(
                enriched_catalog
            )
        )

        logger.info(
            "Graph tables loaded: %d",
            len(
                tables
            ),
        )

        # -------------------------------------------------
        # Build relationship edges
        # -------------------------------------------------

        relationships = (
            cls._build_relationships(
                relationship_catalog=(
                    relationship_catalog
                ),
                tables=(
                    tables
                ),
            )
        )

        logger.info(
            "Graph relationships loaded: %d",
            len(
                relationships
            ),
        )

        return cls(
            schema_hash=(
                schema_hash
            ),
            tables=(
                tables
            ),
            relationships=(
                relationships
            ),
        )

    # =====================================================
    # JSON LOADING
    # =====================================================

    @staticmethod
    def _load_json(
        path: Path,
    ) -> dict[str, Any]:

        if not path.exists():

            raise SchemaGraphLoadError(
                f"Graph source file not found: "
                f"{path}"
            )

        try:

            with path.open(
                "r",
                encoding="utf-8",
            ) as file:

                data = json.load(
                    file
                )

        except json.JSONDecodeError as exc:

            raise SchemaGraphLoadError(
                f"Invalid JSON file: {path}"
            ) from exc

        except OSError as exc:

            raise SchemaGraphLoadError(
                f"Unable to read graph source "
                f"file: {path}"
            ) from exc

        if not isinstance(
            data,
            dict,
        ):

            raise SchemaGraphLoadError(
                f"Graph source must contain "
                f"a JSON object: {path}"
            )

        return data

    # =====================================================
    # ARTIFACT VALIDATION
    # =====================================================

    @classmethod
    def _validate_artifacts(
        cls,
        enriched_catalog: dict[str, Any],
        relationship_catalog: dict[str, Any],
    ) -> str:

        enriched_hash = (
            enriched_catalog.get(
                "schema_hash"
            )
            or enriched_catalog.get(
                "source_schema_hash"
            )
        )

        relationship_hash = (
            relationship_catalog.get(
                "schema_hash"
            )
        )

        if not enriched_hash:

            raise SchemaGraphIntegrityError(
                "Enriched schema catalog does not "
                "contain schema_hash."
            )

        if not relationship_hash:

            raise SchemaGraphIntegrityError(
                "Graph-ready relationship catalog "
                "does not contain schema_hash."
            )

        if (
            enriched_hash
            != relationship_hash
        ):

            raise SchemaGraphIntegrityError(
                "Schema hash mismatch between "
                "enriched_schema_catalog.json and "
                "graph_ready_relationships.json. "
                "Re-run the relationship pipeline."
            )

        version = (
            relationship_catalog.get(
                "relationship_schema_version"
            )
        )

        if (
            version
            != cls
            .EXPECTED_RELATIONSHIP_SCHEMA_VERSION
        ):

            raise SchemaGraphIntegrityError(
                "Unsupported graph relationship "
                "schema version. "
                f"Expected "
                f"{cls.EXPECTED_RELATIONSHIP_SCHEMA_VERSION}, "
                f"received {version!r}."
            )

        return str(
            enriched_hash
        )

    # =====================================================
    # BUILD TABLES
    # =====================================================

    @classmethod
    def _build_tables(
        cls,
        enriched_catalog: dict[str, Any],
    ) -> dict[
        str,
        GraphTable,
    ]:

        tables: dict[
            str,
            GraphTable,
        ] = {}

        for raw_table in (
            enriched_catalog.get(
                "tables",
                [],
            )
        ):

            table_name = (
                raw_table.get(
                    "table_name"
                )
            )

            if not table_name:
                continue

            ai_metadata = (
                raw_table.get(
                    "ai_metadata",
                    {}
                )
                or {}
            )

            retrieval_enabled = (
                ai_metadata.get(
                    "retrieval_enabled",
                    True,
                )
            )

            # Technical / legacy tables should not
            # enter runtime GraphRAG.

            if not retrieval_enabled:
                continue

            if table_name in tables:

                raise SchemaGraphIntegrityError(
                    f"Duplicate table found in "
                    f"enriched schema: "
                    f"{table_name}"
                )

            primary_key_columns = set(
                (
                    raw_table.get(
                        "primary_key",
                        {}
                    )
                    or {}
                ).get(
                    "columns",
                    [],
                )
            )

            unique_columns = (
                cls._extract_unique_columns(
                    raw_table
                )
            )

            columns: list[
                GraphColumn
            ] = []

            seen_columns: set[
                str
            ] = set()

            for raw_column in (
                raw_table.get(
                    "columns",
                    [],
                )
            ):

                column_name = (
                    raw_column.get(
                        "name"
                    )
                )

                if not column_name:
                    continue

                if (
                    column_name
                    in seen_columns
                ):

                    raise SchemaGraphIntegrityError(
                        f"Duplicate column "
                        f"{table_name}."
                        f"{column_name}"
                    )

                seen_columns.add(
                    column_name
                )

                column_ai_metadata = (
                    raw_column.get(
                        "ai_metadata",
                        {}
                    )
                    or {}
                )

                synonyms = (
                    column_ai_metadata.get(
                        "synonyms",
                        [],
                    )
                    or []
                )

                column = GraphColumn(

                    name=(
                        column_name
                    ),

                    data_type=str(
                        raw_column.get(
                            "data_type",
                            "",
                        )
                    ),

                    nullable=(
                        raw_column.get(
                            "nullable"
                        )
                    ),

                    business_name=(
                        column_ai_metadata.get(
                            "business_name"
                        )
                    ),

                    semantic_type=(
                        column_ai_metadata.get(
                            "semantic_type"
                        )
                    ),

                    description=(
                        column_ai_metadata.get(
                            "description"
                        )
                    ),

                    synonyms=tuple(
                        str(
                            synonym
                        )
                        for synonym
                        in synonyms
                    ),

                    is_primary_key=(
                        column_name
                        in primary_key_columns
                    ),

                    is_unique=(
                        column_name
                        in unique_columns
                    ),

                    requires_conversion=bool(
                        column_ai_metadata.get(
                            "requires_conversion",
                            False,
                        )
                    ),

                    stored_format=(
                        column_ai_metadata.get(
                            "stored_format"
                        )
                    ),

                    mysql_format=(
                        column_ai_metadata.get(
                            "mysql_format"
                        )
                    ),

                    comment=(
                        raw_column.get(
                            "comment"
                        )
                    ),
                )

                columns.append(
                    column
                )

            table_synonyms = (
                ai_metadata.get(
                    "synonyms",
                    [],
                )
                or []
            )

            table = GraphTable(

                name=(
                    table_name
                ),

                business_name=(
                    ai_metadata.get(
                        "business_name"
                    )
                ),

                domain=(
                    ai_metadata.get(
                        "domain"
                    )
                ),

                description=(
                    ai_metadata.get(
                        "description"
                    )
                ),

                synonyms=tuple(
                    str(
                        synonym
                    )
                    for synonym
                    in table_synonyms
                ),

                retrieval_enabled=True,

                columns=tuple(
                    columns
                ),
            )

            tables[
                table_name
            ] = table

        return tables

    # =====================================================
    # UNIQUE COLUMN EXTRACTION
    # =====================================================

    @staticmethod
    def _extract_unique_columns(
        raw_table: dict[str, Any],
    ) -> set[str]:
        """
        Extract single-column unique indexes.

        Composite unique indexes are not marked
        as individual unique columns because:

            UNIQUE(orgid, branchcode)

        does NOT mean:

            orgid is individually unique
            branchcode is individually unique
        """

        unique_columns: set[
            str
        ] = set()

        for index in (
            raw_table.get(
                "indexes",
                [],
            )
        ):

            if not index.get(
                "unique",
                False,
            ):
                continue

            columns = [
                column
                for column
                in index.get(
                    "columns",
                    [],
                )
                if column
            ]

            if len(columns) == 1:

                unique_columns.add(
                    columns[0]
                )

        return unique_columns

    # =====================================================
    # BUILD RELATIONSHIPS
    # =====================================================

    @classmethod
    def _build_relationships(
        cls,
        relationship_catalog: dict[str, Any],
        tables: dict[str, GraphTable],
    ) -> dict[
        str,
        GraphRelationship,
    ]:

        relationships: dict[
            str,
            GraphRelationship,
        ] = {}

        seen_keys: set[
            tuple[
                str,
                tuple[str, ...],
                str,
                tuple[str, ...],
            ]
        ] = set()

        for raw_relationship in (
            relationship_catalog.get(
                "relationships",
                [],
            )
        ):

            relationship = (
                GraphRelationship
                .model_validate(
                    raw_relationship
                )
            )

            # -------------------------------------------------
            # Runtime graph accepts ONLY approved,
            # active relationships.
            # -------------------------------------------------

            if (
                relationship.status
                != RelationshipStatus.APPROVED
            ):

                raise SchemaGraphIntegrityError(
                    f"Non-approved relationship "
                    f"found in graph-ready artifact: "
                    f"{relationship.relationship_id}"
                )

            if not relationship.active:

                raise SchemaGraphIntegrityError(
                    f"Inactive relationship found "
                    f"in graph-ready artifact: "
                    f"{relationship.relationship_id}"
                )

            if (
                relationship.relationship_id
                in relationships
            ):

                raise SchemaGraphIntegrityError(
                    f"Duplicate relationship_id: "
                    f"{relationship.relationship_id}"
                )

            # -------------------------------------------------
            # Source / target tables
            # -------------------------------------------------

            source_table = (
                tables.get(
                    relationship.source_table
                )
            )

            target_table = (
                tables.get(
                    relationship.target_table
                )
            )

            if source_table is None:

                raise SchemaGraphIntegrityError(
                    f"Relationship "
                    f"{relationship.relationship_id} "
                    f"references unavailable source "
                    f"table "
                    f"{relationship.source_table!r}."
                )

            if target_table is None:

                raise SchemaGraphIntegrityError(
                    f"Relationship "
                    f"{relationship.relationship_id} "
                    f"references unavailable target "
                    f"table "
                    f"{relationship.target_table!r}."
                )

            # -------------------------------------------------
            # Column count
            # -------------------------------------------------

            if (
                len(
                    relationship.source_columns
                )
                != len(
                    relationship.target_columns
                )
            ):

                raise SchemaGraphIntegrityError(
                    f"Relationship "
                    f"{relationship.relationship_id} "
                    f"has mismatched source/target "
                    f"column counts."
                )

            # -------------------------------------------------
            # Main relationship columns
            # -------------------------------------------------

            for column_name in (
                relationship.source_columns
            ):

                if not source_table.has_column(
                    column_name
                ):

                    raise SchemaGraphIntegrityError(
                        f"Relationship "
                        f"{relationship.relationship_id} "
                        f"references unknown column "
                        f"{relationship.source_table}."
                        f"{column_name}."
                    )

            for column_name in (
                relationship.target_columns
            ):

                if not target_table.has_column(
                    column_name
                ):

                    raise SchemaGraphIntegrityError(
                        f"Relationship "
                        f"{relationship.relationship_id} "
                        f"references unknown column "
                        f"{relationship.target_table}."
                        f"{column_name}."
                    )

            # -------------------------------------------------
            # Tenant columns
            # -------------------------------------------------

            if (
                relationship
                .tenant_scope
                .enabled
            ):

                for column_name in (
                    relationship
                    .tenant_scope
                    .source_columns
                ):

                    if not source_table.has_column(
                        column_name
                    ):

                        raise SchemaGraphIntegrityError(
                            f"Relationship "
                            f"{relationship.relationship_id} "
                            f"contains unknown tenant "
                            f"source column "
                            f"{relationship.source_table}."
                            f"{column_name}."
                        )

                for column_name in (
                    relationship
                    .tenant_scope
                    .target_columns
                ):

                    if not target_table.has_column(
                        column_name
                    ):

                        raise SchemaGraphIntegrityError(
                            f"Relationship "
                            f"{relationship.relationship_id} "
                            f"contains unknown tenant "
                            f"target column "
                            f"{relationship.target_table}."
                            f"{column_name}."
                        )

            # -------------------------------------------------
            # Duplicate path protection
            # -------------------------------------------------

            relationship_key = (

                relationship.source_table,

                tuple(
                    relationship.source_columns
                ),

                relationship.target_table,

                tuple(
                    relationship.target_columns
                ),
            )

            if (
                relationship_key
                in seen_keys
            ):

                raise SchemaGraphIntegrityError(
                    f"Duplicate relationship path "
                    f"found: "
                    f"{relationship_key}"
                )

            seen_keys.add(
                relationship_key
            )

            relationships[
                relationship.relationship_id
            ] = relationship

        return relationships

    # =====================================================
    # BASIC PROPERTIES
    # =====================================================

    @property
    def schema_hash(
        self,
    ) -> str:

        return self._schema_hash

    @property
    def table_count(
        self,
    ) -> int:

        return len(
            self._tables
        )

    @property
    def relationship_count(
        self,
    ) -> int:

        return len(
            self._relationships
        )

    # =====================================================
    # TABLE ACCESS
    # =====================================================

    def has_table(
        self,
        table_name: str,
    ) -> bool:

        return (
            table_name
            in self._tables
        )

    def get_table(
        self,
        table_name: str,
    ) -> GraphTable:

        table = (
            self._tables.get(
                table_name
            )
        )

        if table is None:

            raise KeyError(
                f"Unknown graph table: "
                f"{table_name}"
            )

        return table

    def get_tables(
        self,
    ) -> tuple[
        GraphTable,
        ...
    ]:

        return tuple(
            self._tables[
                table_name
            ]

            for table_name
            in sorted(
                self._tables
            )
        )

    def table_names(
        self,
    ) -> tuple[
        str,
        ...
    ]:

        return tuple(
            sorted(
                self._tables
            )
        )

    # =====================================================
    # COLUMN ACCESS
    # =====================================================

    def get_column(
        self,
        table_name: str,
        column_name: str,
    ) -> GraphColumn:

        table = self.get_table(
            table_name
        )

        column = table.get_column(
            column_name
        )

        if column is None:

            raise KeyError(
                f"Unknown graph column: "
                f"{table_name}."
                f"{column_name}"
            )

        return column

    # =====================================================
    # RELATIONSHIP ACCESS
    # =====================================================

    def get_relationship(
        self,
        relationship_id: str,
    ) -> GraphRelationship:

        relationship = (
            self._relationships.get(
                relationship_id
            )
        )

        if relationship is None:

            raise KeyError(
                f"Unknown relationship_id: "
                f"{relationship_id}"
            )

        return relationship

    def get_relationships(
        self,
    ) -> tuple[
        GraphRelationship,
        ...
    ]:

        return tuple(
            self._relationships[
                relationship_id
            ]

            for relationship_id
            in sorted(
                self._relationships
            )
        )

    # =====================================================
    # DIRECT RELATIONSHIPS FOR TABLE
    # =====================================================

    def relationships_for_table(
        self,
        table_name: str,
    ) -> tuple[
        GraphRelationship,
        ...
    ]:

        self.get_table(
            table_name
        )

        relationship_ids = (
            self._adjacency.get(
                table_name,
                (),
            )
        )

        return tuple(
            self._relationships[
                relationship_id
            ]

            for relationship_id
            in relationship_ids
        )

    # =====================================================
    # NEIGHBORS
    # =====================================================

    def get_neighbors(
        self,
        table_name: str,
    ) -> tuple[
        GraphNeighbor,
        ...
    ]:

        self.get_table(
            table_name
        )

        neighbors: list[
            GraphNeighbor
        ] = []

        for relationship in (
            self.relationships_for_table(
                table_name
            )
        ):

            adjacent_table = (
                relationship.other_table(
                    table_name
                )
            )

            direction = (
                relationship
                .traversal_direction(
                    table_name
                )
            )

            neighbors.append(
                GraphNeighbor(

                    adjacent_table=(
                        adjacent_table
                    ),

                    relationship_id=(
                        relationship
                        .relationship_id
                    ),

                    direction=(
                        direction
                    ),
                )
            )

        neighbors.sort(
            key=lambda neighbor: (
                neighbor.adjacent_table,
                neighbor.relationship_id,
            )
        )

        return tuple(
            neighbors
        )

    # =====================================================
    # RELATIONSHIPS BETWEEN TWO TABLES
    # =====================================================

    def relationships_between(
        self,
        table_a: str,
        table_b: str,
    ) -> tuple[
        GraphRelationship,
        ...
    ]:

        self.get_table(
            table_a
        )

        self.get_table(
            table_b
        )

        matches: list[
            GraphRelationship
        ] = []

        for relationship in (
            self.relationships_for_table(
                table_a
            )
        ):

            if (
                relationship.other_table(
                    table_a
                )
                == table_b
            ):

                matches.append(
                    relationship
                )

        matches.sort(
            key=lambda relationship: (
                relationship.relationship_id
            )
        )

        return tuple(
            matches
        )

    # =====================================================
    # DIRECT CONNECTION CHECK
    # =====================================================

    def are_connected(
        self,
        table_a: str,
        table_b: str,
    ) -> bool:

        return bool(
            self.relationships_between(
                table_a,
                table_b,
            )
        )

    # =====================================================
    # ISOLATED TABLES
    # =====================================================

    def isolated_tables(
        self,
    ) -> tuple[
        str,
        ...
    ]:

        return tuple(
            sorted(
                table_name

                for table_name
                in self._tables

                if not self._adjacency.get(
                    table_name
                )
            )
        )

    # =====================================================
    # SUMMARY
    # =====================================================

    def summary(
        self,
    ) -> SchemaGraphSummary:

        column_count = sum(
            len(
                table.columns
            )
            for table
            in self._tables.values()
        )

        isolated_tables = (
            self.isolated_tables()
        )

        return SchemaGraphSummary(

            schema_hash=(
                self._schema_hash
            ),

            table_count=(
                len(
                    self._tables
                )
            ),

            column_count=(
                column_count
            ),

            relationship_count=(
                len(
                    self._relationships
                )
            ),

            isolated_table_count=(
                len(
                    isolated_tables
                )
            ),
        )