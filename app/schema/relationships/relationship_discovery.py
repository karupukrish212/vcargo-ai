import logging
import re
from typing import Any

from app.schema.relationships.models import (
    Relationship,
    RelationshipCatalog,
    RelationshipEvidence,
    RelationshipSource,
    RelationshipStatus,
    RelationshipType,
)


logger = logging.getLogger(__name__)


# ---------------------------------------------------------
# Columns that usually appear in many unrelated tables.
# We should NOT infer relationships using these columns.
# ---------------------------------------------------------

IGNORED_DISCOVERY_COLUMNS = {
    "active",
    "cancel",
    "createdon",
    "modifiedon",
    "createdby",
    "modifiedby",
    "status",
    "remarks",
    "description",
    "screenname",
}


class RelationshipDiscovery:
    """
    Discovers relationships between business tables.

    Sources:

    1. Real MySQL foreign keys
    2. Manual relationships from schema_metadata.json
    3. Conservative inferred relationships

    Important:
    Inferred relationships are only candidates.
    They are NOT automatically approved.
    """

    def __init__(
        self,
        enriched_catalog: dict[str, Any],
        metadata: dict[str, Any] | None = None,
    ) -> None:

        self.catalog = enriched_catalog
        self.metadata = metadata or {}

        self.business_tables = (
            self._get_business_tables()
        )

    # -----------------------------------------------------
    # MAIN METHOD
    # -----------------------------------------------------

    def discover(self) -> RelationshipCatalog:

        logger.info(
            "Starting relationship discovery"
        )

        logger.info(
            "Business tables available for discovery: %d",
            len(self.business_tables),
        )

        relationships: list[Relationship] = []

        # -------------------------------------------------
        # 1. Existing MySQL foreign keys
        # -------------------------------------------------

        declared_relationships = (
            self._extract_declared_foreign_keys()
        )

        relationships.extend(
            declared_relationships
        )

        logger.info(
            "Declared database relationships found: %d",
            len(declared_relationships),
        )

        # -------------------------------------------------
        # 2. Manual business relationships
        # -------------------------------------------------

        manual_relationships = (
            self._extract_manual_relationships()
        )

        relationships.extend(
            manual_relationships
        )

        logger.info(
            "Manual relationships found: %d",
            len(manual_relationships),
        )

        # -------------------------------------------------
        # 3. Automatically discovered candidates
        # -------------------------------------------------

        existing_keys = {
            self._relationship_key(relationship)
            for relationship in relationships
        }

        candidate_relationships = (
            self._discover_candidate_relationships(
                existing_keys=existing_keys
            )
        )

        relationships.extend(
            candidate_relationships
        )

        # -------------------------------------------------
        # Remove duplicate relationships
        # -------------------------------------------------

        relationships = self._deduplicate(
            relationships
        )

        declared_count = sum(
            1
            for relationship in relationships
            if relationship.relationship_source
            == RelationshipSource.DATABASE
        )

        candidate_count = sum(
            1
            for relationship in relationships
            if relationship.status
            == RelationshipStatus.CANDIDATE
        )

        logger.info(
            "Relationship discovery completed. "
            "Total=%d Declared=%d Candidates=%d",
            len(relationships),
            declared_count,
            candidate_count,
        )

        return RelationshipCatalog(
            schema_hash=self.catalog.get(
                "schema_hash",
                self.catalog.get(
                    "source_schema_hash",
                    "",
                ),
            ),

            business_table_count=len(
                self.business_tables
            ),

            declared_relationship_count=(
                declared_count
            ),

            candidate_relationship_count=(
                candidate_count
            ),

            relationships=relationships,
        )

    # -----------------------------------------------------
    # BUSINESS TABLE FILTER
    # -----------------------------------------------------

    def _get_business_tables(
        self,
    ) -> dict[str, dict[str, Any]]:
        """
        Keep only retrieval_enabled=true tables.

        Your 33 technical tables will automatically
        disappear from relationship discovery.
        """

        tables: dict[str, dict[str, Any]] = {}

        for table in self.catalog.get(
            "tables",
            [],
        ):

            ai_metadata = table.get(
                "ai_metadata",
                {},
            )

            retrieval_enabled = (
                ai_metadata.get(
                    "retrieval_enabled",
                    True,
                )
            )

            if not retrieval_enabled:
                continue

            tables[
                table["table_name"]
            ] = table

        return tables

    # -----------------------------------------------------
    # REAL MYSQL FOREIGN KEYS
    # -----------------------------------------------------

    def _extract_declared_foreign_keys(
        self,
    ) -> list[Relationship]:

        relationships: list[Relationship] = []

        for source_table_name, table in (
            self.business_tables.items()
        ):

            foreign_keys = table.get(
                "foreign_keys",
                [],
            )

            for fk in foreign_keys:

                target_table = fk.get(
                    "referenced_table"
                )

                # Do not create graph edges to
                # excluded technical tables.
                if (
                    not target_table
                    or target_table
                    not in self.business_tables
                ):
                    continue

                source_columns = fk.get(
                    "columns",
                    [],
                )

                target_columns = fk.get(
                    "referenced_columns",
                    [],
                )

                # Supports both single and
                # composite foreign keys.
                for (
                    source_column,
                    target_column,
                ) in zip(
                    source_columns,
                    target_columns,
                    strict=False,
                ):

                    relationship = Relationship(

                        source_table=(
                            source_table_name
                        ),

                        source_column=(
                            source_column
                        ),

                        target_table=(
                            target_table
                        ),

                        target_column=(
                            target_column
                        ),

                        relationship_type=(
                            RelationshipType.FOREIGN_KEY
                        ),

                        relationship_source=(
                            RelationshipSource.DATABASE
                        ),

                        join_operator="=",

                        confidence_score=1.0,

                        status=(
                            RelationshipStatus.APPROVED
                        ),

                        evidence=[
                            RelationshipEvidence(
                                rule=(
                                    "database_foreign_key"
                                ),
                                score=1.0,
                                description=(
                                    "Relationship is "
                                    "declared as a MySQL "
                                    "foreign key."
                                ),
                            )
                        ],

                        description=(
                            f"{source_table_name}."
                            f"{source_column} references "
                            f"{target_table}."
                            f"{target_column}"
                        ),
                    )

                    relationships.append(
                        relationship
                    )

        return relationships

    # -----------------------------------------------------
    # MANUAL RELATIONSHIPS
    # -----------------------------------------------------

    def _extract_manual_relationships(
        self,
    ) -> list[Relationship]:

        relationships: list[Relationship] = []

        manual_relationships = (
            self.metadata.get(
                "manual_relationships",
                [],
            )
        )

        for item in manual_relationships:

            source_table = item.get(
                "source_table"
            )

            target_table = item.get(
                "target_table"
            )

            source_column = item.get(
                "source_column"
            )

            target_column = item.get(
                "target_column"
            )

            if not all(
                [
                    source_table,
                    target_table,
                    source_column,
                    target_column,
                ]
            ):
                logger.warning(
                    "Skipping incomplete manual "
                    "relationship: %s",
                    item,
                )

                continue

            # Skip excluded/technical tables
            if (
                source_table
                not in self.business_tables
                or target_table
                not in self.business_tables
            ):
                continue

            if not self._column_exists(
                source_table,
                source_column,
            ):
                logger.warning(
                    "Manual relationship source "
                    "column not found: %s.%s",
                    source_table,
                    source_column,
                )

                continue

            if not self._column_exists(
                target_table,
                target_column,
            ):
                logger.warning(
                    "Manual relationship target "
                    "column not found: %s.%s",
                    target_table,
                    target_column,
                )

                continue

            relationship_type = (
                self._parse_relationship_type(
                    item.get(
                        "relationship_type"
                    )
                )
            )

            status = (
                self._parse_relationship_status(
                    item.get(
                        "status",
                        "candidate",
                    )
                )
            )

            confidence = (
                1.0
                if status
                == RelationshipStatus.APPROVED
                else 0.90
            )

            relationship = Relationship(

                source_table=source_table,

                source_column=source_column,

                target_table=target_table,

                target_column=target_column,

                relationship_type=(
                    relationship_type
                ),

                relationship_source=(
                    RelationshipSource.MANUAL
                ),

                join_operator=item.get(
                    "join_operator",
                    "=",
                ),

                confidence_score=confidence,

                status=status,

                evidence=[
                    RelationshipEvidence(
                        rule=(
                            "manual_business_mapping"
                        ),
                        score=confidence,
                        description=(
                            "Relationship was "
                            "manually defined in "
                            "schema metadata."
                        ),
                    )
                ],

                description=item.get(
                    "description"
                ),
            )

            relationships.append(
                relationship
            )

        return relationships

    # -----------------------------------------------------
    # AUTOMATIC CANDIDATE DISCOVERY
    # -----------------------------------------------------

    def _discover_candidate_relationships(
        self,
        existing_keys: set[tuple[str, str, str, str]],
    ) -> list[Relationship]:

        candidates: list[Relationship] = []

        table_names = list(
            self.business_tables.keys()
        )

        for source_table_name in table_names:

            source_table = (
                self.business_tables[
                    source_table_name
                ]
            )

            for source_column in source_table.get(
                "columns",
                [],
            ):

                source_column_name = (
                    source_column["name"]
                )

                normalized_source_column = (
                    self._normalize_name(
                        source_column_name
                    )
                )

                if (
                    normalized_source_column
                    in IGNORED_DISCOVERY_COLUMNS
                ):
                    continue

                for target_table_name in table_names:

                    if (
                        target_table_name
                        == source_table_name
                    ):
                        continue

                    target_table = (
                        self.business_tables[
                            target_table_name
                        ]
                    )

                    for target_column in (
                        target_table.get(
                            "columns",
                            [],
                        )
                    ):

                        target_column_name = (
                            target_column["name"]
                        )

                        key = (
                            source_table_name,
                            source_column_name,
                            target_table_name,
                            target_column_name,
                        )

                        if key in existing_keys:
                            continue

                        result = (
                            self._score_candidate(
                                source_table_name=(
                                    source_table_name
                                ),
                                source_column=(
                                    source_column
                                ),
                                target_table_name=(
                                    target_table_name
                                ),
                                target_table=(
                                    target_table
                                ),
                                target_column=(
                                    target_column
                                ),
                            )
                        )

                        if result is None:
                            continue

                        confidence, evidence = result

                        # Conservative threshold
                        if confidence < 0.70:
                            continue

                        relationship_type = (
                            self._infer_relationship_type(
                                source_column
                            )
                        )

                        candidate = Relationship(

                            source_table=(
                                source_table_name
                            ),

                            source_column=(
                                source_column_name
                            ),

                            target_table=(
                                target_table_name
                            ),

                            target_column=(
                                target_column_name
                            ),

                            relationship_type=(
                                relationship_type
                            ),

                            relationship_source=(
                                RelationshipSource.DISCOVERED
                            ),

                            join_operator="=",

                            confidence_score=(
                                round(
                                    confidence,
                                    4,
                                )
                            ),

                            status=(
                                RelationshipStatus.CANDIDATE
                            ),

                            evidence=evidence,

                            description=(
                                "Automatically discovered "
                                "candidate relationship."
                            ),
                        )

                        candidates.append(
                            candidate
                        )

        return candidates

    # -----------------------------------------------------
    # CANDIDATE SCORING
    # -----------------------------------------------------

    def _score_candidate(
        self,
        source_table_name: str,
        source_column: dict[str, Any],
        target_table_name: str,
        target_table: dict[str, Any],
        target_column: dict[str, Any],
    ) -> (
        tuple[
            float,
            list[RelationshipEvidence],
        ]
        | None
    ):

        source_name = self._normalize_name(
            source_column["name"]
        )

        target_name = self._normalize_name(
            target_column["name"]
        )

        evidence: list[
            RelationshipEvidence
        ] = []

        score = 0.0

        # -------------------------------------------------
        # Rule 1:
        # Exact column-name match
        # -------------------------------------------------

        if source_name == target_name:

            score += 0.35

            evidence.append(
                RelationshipEvidence(
                    rule="column_name_match",
                    score=1.0,
                    description=(
                        "Source and target column "
                        "names are identical."
                    ),
                )
            )

        # -------------------------------------------------
        # Rule 2:
        # Datatype compatibility
        # -------------------------------------------------

        if self._types_compatible(
            source_column.get(
                "data_type",
                "",
            ),
            target_column.get(
                "data_type",
                "",
            ),
        ):

            score += 0.25

            evidence.append(
                RelationshipEvidence(
                    rule="data_type_match",
                    score=1.0,
                    description=(
                        "Source and target data "
                        "types are compatible."
                    ),
                )
            )

        else:
            # Incompatible types are too risky.
            return None

        # -------------------------------------------------
        # Rule 3:
        # Target column is primary key
        # -------------------------------------------------

        target_pk_columns = set(
            target_table
            .get(
                "primary_key",
                {},
            )
            .get(
                "columns",
                [],
            )
        )

        if (
            target_column["name"]
            in target_pk_columns
        ):

            score += 0.25

            evidence.append(
                RelationshipEvidence(
                    rule="target_primary_key",
                    score=1.0,
                    description=(
                        "Target column is a "
                        "primary key."
                    ),
                )
            )

        # -------------------------------------------------
        # Rule 4:
        # Target column is unique
        # -------------------------------------------------

        if self._is_unique_column(
            target_table,
            target_column["name"],
        ):

            score += 0.20

            evidence.append(
                RelationshipEvidence(
                    rule="target_unique",
                    score=1.0,
                    description=(
                        "Target column has a "
                        "unique index."
                    ),
                )
            )

        # -------------------------------------------------
        # Rule 5:
        # Source column name contains target table meaning
        #
        # Example:
        # branchcode -> branch
        #
        # vehicleid -> vehicle
        # -------------------------------------------------

        if self._column_mentions_table(
            source_column["name"],
            target_table_name,
        ):

            score += 0.15

            evidence.append(
                RelationshipEvidence(
                    rule="table_name_hint",
                    score=1.0,
                    description=(
                        "Source column name "
                        "contains the target "
                        "table name or business "
                        "entity name."
                    ),
                )
            )

        # Maximum score should not exceed 1
        score = min(
            score,
            1.0,
        )

        return (
            score,
            evidence,
        )

    # -----------------------------------------------------
    # RELATIONSHIP TYPE
    # -----------------------------------------------------

    def _infer_relationship_type(
        self,
        column: dict[str, Any],
    ) -> RelationshipType:

        ai_metadata = column.get(
            "ai_metadata",
            {},
        )

        semantic_type = (
            ai_metadata.get(
                "semantic_type",
                "",
            )
            .lower()
        )

        if semantic_type == "business_key":

            return (
                RelationshipType.BUSINESS_KEY
            )

        if semantic_type in {
            "business_value",
            "category",
        }:

            return (
                RelationshipType.VALUE_MATCH
            )

        return RelationshipType.INFERRED

    # -----------------------------------------------------
    # UNIQUE COLUMN CHECK
    # -----------------------------------------------------

    def _is_unique_column(
        self,
        table: dict[str, Any],
        column_name: str,
    ) -> bool:

        indexes = table.get(
            "indexes",
            [],
        )

        for index in indexes:

            if not index.get(
                "unique",
                False,
            ):
                continue

            columns = index.get(
                "columns",
                [],
            )

            if (
                len(columns) == 1
                and columns[0]
                == column_name
            ):
                return True

        return False

    # -----------------------------------------------------
    # TYPE COMPATIBILITY
    # -----------------------------------------------------

    def _types_compatible(
        self,
        source_type: str,
        target_type: str,
    ) -> bool:

        source_family = (
            self._type_family(
                source_type
            )
        )

        target_family = (
            self._type_family(
                target_type
            )
        )

        return (
            source_family
            == target_family
        )

    @staticmethod
    def _type_family(
        data_type: str,
    ) -> str:

        value = data_type.upper()

        if any(
            item in value
            for item in (
                "CHAR",
                "TEXT",
                "ENUM",
            )
        ):
            return "string"

        if any(
            item in value
            for item in (
                "BIGINT",
                "INTEGER",
                "INT",
                "SMALLINT",
                "TINYINT",
            )
        ):
            return "integer"

        if any(
            item in value
            for item in (
                "DECIMAL",
                "NUMERIC",
                "DOUBLE",
                "FLOAT",
                "REAL",
            )
        ):
            return "numeric"

        if "DATE" in value:
            return "date"

        if "TIME" in value:
            return "time"

        if "BIT" in value:
            return "boolean"

        return value

    # -----------------------------------------------------
    # COLUMN -> TABLE NAME HINT
    # -----------------------------------------------------

    def _column_mentions_table(
        self,
        column_name: str,
        table_name: str,
    ) -> bool:

        column = self._normalize_name(
            column_name
        )

        table = self._normalize_name(
            table_name
        )

        # Some project tables use prefixes:
        # tvehicle -> vehicle
        # tdriver  -> driver

        table_without_prefix = table

        if (
            table.startswith("t")
            and len(table) > 2
        ):
            table_without_prefix = table[1:]

        return (
            table in column
            or table_without_prefix in column
        )

    # -----------------------------------------------------
    # COLUMN EXISTS
    # -----------------------------------------------------

    def _column_exists(
        self,
        table_name: str,
        column_name: str,
    ) -> bool:

        table = self.business_tables.get(
            table_name
        )

        if not table:
            return False

        return any(
            column.get("name")
            == column_name
            for column in table.get(
                "columns",
                [],
            )
        )

    # -----------------------------------------------------
    # ENUM PARSERS
    # -----------------------------------------------------

    @staticmethod
    def _parse_relationship_type(
        value: str | None,
    ) -> RelationshipType:

        if not value:
            return RelationshipType.VALUE_MATCH

        try:
            return RelationshipType(
                value
            )

        except ValueError:
            return RelationshipType.VALUE_MATCH

    @staticmethod
    def _parse_relationship_status(
        value: str,
    ) -> RelationshipStatus:

        try:
            return RelationshipStatus(
                value
            )

        except ValueError:
            return (
                RelationshipStatus.NEEDS_REVIEW
            )

    # -----------------------------------------------------
    # NAME NORMALIZATION
    # -----------------------------------------------------

    @staticmethod
    def _normalize_name(
        value: str,
    ) -> str:

        return re.sub(
            r"[^a-z0-9]",
            "",
            value.lower(),
        )

    # -----------------------------------------------------
    # DUPLICATE HANDLING
    # -----------------------------------------------------

    @staticmethod
    def _relationship_key(
        relationship: Relationship,
    ) -> tuple[str, str, str, str]:

        return (
            relationship.source_table,
            relationship.source_column,
            relationship.target_table,
            relationship.target_column,
        )

    def _deduplicate(
        self,
        relationships: list[Relationship],
    ) -> list[Relationship]:

        result: list[Relationship] = []

        seen: set[
            tuple[str, str, str, str]
        ] = set()

        for relationship in relationships:

            key = self._relationship_key(
                relationship
            )

            if key in seen:
                continue

            seen.add(key)

            result.append(
                relationship
            )

        return result