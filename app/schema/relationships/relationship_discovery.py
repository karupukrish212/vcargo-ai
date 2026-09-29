import logging
import re
from datetime import datetime, timezone
from typing import Any

from app.schema.relationships.models import (
    Relationship,
    RelationshipCardinality,
    RelationshipCatalog,
    RelationshipEvidence,
    RelationshipGovernance,
    RelationshipNormalization,
    RelationshipProvenance,
    RelationshipSource,
    RelationshipStatus,
    RelationshipTenantScope,
    RelationshipType,
)


logger = logging.getLogger(__name__)


# =========================================================
# COLUMNS THAT SHOULD NOT CREATE RELATIONSHIPS AUTOMATICALLY
# =========================================================

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


# =========================================================
# DISCOVERY ENGINE
# =========================================================


class RelationshipDiscovery:
    """
    Enterprise-grade relationship discovery engine.

    Relationship sources:

    1. Declared MySQL foreign keys
       -> automatically approved

    2. Manual business relationships
       -> taken from schema_metadata.json

    3. Schema-inferred relationships
       -> candidates only

    Important:
    Inferred relationships are NEVER automatically
    considered trusted relationships here.
    """

    CANDIDATE_THRESHOLD = 0.70

    def __init__(
        self,
        enriched_catalog: dict[str, Any],
        metadata: dict[str, Any] | None = None,
    ) -> None:

        self.catalog = enriched_catalog

        self.metadata = metadata or {}

        self.generated_at = datetime.now(
            timezone.utc
        )

        self.schema_hash = self._get_schema_hash()

        self.business_tables = (
            self._get_business_tables()
        )

    # =====================================================
    # MAIN
    # =====================================================

    def discover(
        self,
    ) -> RelationshipCatalog:

        logger.info(
            "Starting enterprise relationship discovery"
        )

        logger.info(
            "Business tables available for discovery: %d",
            len(self.business_tables),
        )

        relationships: list[
            Relationship
        ] = []

        # -------------------------------------------------
        # 1. DATABASE FOREIGN KEYS
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
        # 2. MANUAL RELATIONSHIPS
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
        # Existing trusted/manual relationship keys
        # -------------------------------------------------

        existing_keys = {
            self._relationship_key(
                relationship
            )
            for relationship in relationships
        }

        # -------------------------------------------------
        # 3. AUTOMATIC CANDIDATE DISCOVERY
        # -------------------------------------------------

        candidate_relationships = (
            self._discover_candidate_relationships(
                existing_keys=existing_keys
            )
        )

        relationships.extend(
            candidate_relationships
        )

        # -------------------------------------------------
        # Deduplicate
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
            schema_hash=self.schema_hash,

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

    # =====================================================
    # SCHEMA HASH
    # =====================================================

    def _get_schema_hash(
        self,
    ) -> str:

        return (
            self.catalog.get(
                "schema_hash"
            )
            or self.catalog.get(
                "source_schema_hash"
            )
            or ""
        )

    # =====================================================
    # BUSINESS TABLE FILTER
    # =====================================================

    def _get_business_tables(
        self,
    ) -> dict[str, dict[str, Any]]:

        """
        Only retrieval_enabled=true tables are eligible.

        Technical / legacy tables are automatically
        excluded from relationship discovery.
        """

        tables: dict[
            str,
            dict[str, Any],
        ] = {}

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

            table_name = table.get(
                "table_name"
            )

            if not table_name:
                continue

            tables[
                table_name
            ] = table

        return tables

    # =====================================================
    # DECLARED MYSQL FOREIGN KEYS
    # =====================================================

    def _extract_declared_foreign_keys(
        self,
    ) -> list[Relationship]:

        """
        Extract real MySQL foreign keys.

        Enterprise improvement:
        Composite foreign keys are preserved as ONE
        relationship instead of splitting them into
        multiple independent relationships.
        """

        relationships: list[
            Relationship
        ] = []

        for (
            source_table_name,
            source_table,
        ) in self.business_tables.items():

            foreign_keys = source_table.get(
                "foreign_keys",
                [],
            )

            for fk in foreign_keys:

                target_table_name = fk.get(
                    "referenced_table"
                )

                if not target_table_name:
                    continue

                # Ignore FK pointing to disabled table
                if (
                    target_table_name
                    not in self.business_tables
                ):
                    continue

                source_columns = list(
                    fk.get(
                        "columns",
                        [],
                    )
                )

                target_columns = list(
                    fk.get(
                        "referenced_columns",
                        [],
                    )
                )

                if (
                    not source_columns
                    or not target_columns
                ):
                    continue

                if (
                    len(source_columns)
                    != len(target_columns)
                ):

                    logger.warning(
                        "Skipping malformed FK %s -> %s: "
                        "column counts do not match.",
                        source_table_name,
                        target_table_name,
                    )

                    continue

                target_table = (
                    self.business_tables[
                        target_table_name
                    ]
                )

                cardinality = (
                    self._infer_cardinality(
                        source_table=(
                            source_table
                        ),
                        source_columns=(
                            source_columns
                        ),
                        target_table=(
                            target_table
                        ),
                        target_columns=(
                            target_columns
                        ),
                    )
                )

                description = (
                    f"{source_table_name}."
                    f"{','.join(source_columns)} "
                    f"references "
                    f"{target_table_name}."
                    f"{','.join(target_columns)}"
                )

                relationship = Relationship(

                    source_table=(
                        source_table_name
                    ),

                    source_columns=(
                        source_columns
                    ),

                    target_table=(
                        target_table_name
                    ),

                    target_columns=(
                        target_columns
                    ),

                    relationship_type=(
                        RelationshipType.FOREIGN_KEY
                    ),

                    relationship_source=(
                        RelationshipSource.DATABASE
                    ),

                    cardinality=(
                        cardinality
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
                                "foreign key constraint."
                            ),
                        )
                    ],

                    description=description,

                    normalization=(
                        RelationshipNormalization()
                    ),

                    tenant_scope=(
                        RelationshipTenantScope()
                    ),

                    governance=(
                        RelationshipGovernance(
                            approved_by=(
                                "database_constraint"
                            ),
                            approval_reason=(
                                "Declared MySQL "
                                "foreign key."
                            ),
                        )
                    ),

                    provenance=(
                        self._build_provenance()
                    ),

                    active=True,
                )

                relationships.append(
                    relationship
                )

        return relationships

    # =====================================================
    # MANUAL RELATIONSHIPS
    # =====================================================

    def _extract_manual_relationships(
        self,
    ) -> list[Relationship]:

        """
        Read human/business relationships from
        schema_metadata.json.

        Supports both:

        Old:
        source_column
        target_column

        New:
        source_columns
        target_columns
        """

        relationships: list[
            Relationship
        ] = []

        manual_relationships = (
            self.metadata.get(
                "manual_relationships",
                [],
            )
        )

        for item in manual_relationships:

            source_table_name = item.get(
                "source_table"
            )

            target_table_name = item.get(
                "target_table"
            )

            source_columns = (
                self._extract_relationship_columns(
                    item=item,
                    plural_key="source_columns",
                    singular_key="source_column",
                )
            )

            target_columns = (
                self._extract_relationship_columns(
                    item=item,
                    plural_key="target_columns",
                    singular_key="target_column",
                )
            )

            if (
                not source_table_name
                or not target_table_name
                or not source_columns
                or not target_columns
            ):

                logger.warning(
                    "Skipping incomplete manual "
                    "relationship: %s",
                    item,
                )

                continue

            if (
                source_table_name
                not in self.business_tables
                or target_table_name
                not in self.business_tables
            ):

                logger.info(
                    "Skipping manual relationship "
                    "because one table is disabled: "
                    "%s -> %s",
                    source_table_name,
                    target_table_name,
                )

                continue

            if (
                len(source_columns)
                != len(target_columns)
            ):

                logger.warning(
                    "Skipping manual relationship "
                    "%s -> %s because source/target "
                    "column counts differ.",
                    source_table_name,
                    target_table_name,
                )

                continue

            if not self._columns_exist(
                source_table_name,
                source_columns,
            ):

                logger.warning(
                    "Manual relationship has "
                    "unknown source column(s): "
                    "%s.%s",
                    source_table_name,
                    source_columns,
                )

                continue

            if not self._columns_exist(
                target_table_name,
                target_columns,
            ):

                logger.warning(
                    "Manual relationship has "
                    "unknown target column(s): "
                    "%s.%s",
                    target_table_name,
                    target_columns,
                )

                continue

            source_table = (
                self.business_tables[
                    source_table_name
                ]
            )

            target_table = (
                self.business_tables[
                    target_table_name
                ]
            )

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

            explicit_cardinality = (
                item.get(
                    "cardinality"
                )
            )

            if explicit_cardinality:

                cardinality = (
                    self._parse_cardinality(
                        explicit_cardinality
                    )
                )

            else:

                cardinality = (
                    self._infer_cardinality(
                        source_table=source_table,
                        source_columns=(
                            source_columns
                        ),
                        target_table=target_table,
                        target_columns=(
                            target_columns
                        ),
                    )
                )

            confidence_score = float(
                item.get(
                    "confidence_score",
                    (
                        1.0
                        if status
                        == RelationshipStatus.APPROVED
                        else 0.90
                    ),
                )
            )

            normalization = (
                self._build_manual_normalization(
                    item
                )
            )

            tenant_scope = (
                self._build_manual_tenant_scope(
                    item=item,
                    source_table=(
                        source_table_name
                    ),
                    target_table=(
                        target_table_name
                    ),
                )
            )

            governance = (
                self._build_manual_governance(
                    item=item,
                    status=status,
                )
            )

            relationship = Relationship(

                source_table=(
                    source_table_name
                ),

                source_columns=(
                    source_columns
                ),

                target_table=(
                    target_table_name
                ),

                target_columns=(
                    target_columns
                ),

                relationship_type=(
                    relationship_type
                ),

                relationship_source=(
                    RelationshipSource.MANUAL
                ),

                cardinality=(
                    cardinality
                ),

                join_operator=item.get(
                    "join_operator",
                    "=",
                ),

                confidence_score=(
                    confidence_score
                ),

                status=status,

                evidence=[
                    RelationshipEvidence(
                        rule=(
                            "manual_business_mapping"
                        ),
                        score=(
                            confidence_score
                        ),
                        description=(
                            "Relationship was "
                            "defined in manually "
                            "maintained schema metadata."
                        ),
                    )
                ],

                description=item.get(
                    "description"
                ),

                normalization=(
                    normalization
                ),

                tenant_scope=(
                    tenant_scope
                ),

                governance=(
                    governance
                ),

                provenance=(
                    self._build_provenance(
                        item.get(
                            "provenance"
                        )
                    )
                ),

                active=item.get(
                    "active",
                    True,
                ),
            )

            relationships.append(
                relationship
            )

        return relationships

    # =====================================================
    # AUTOMATIC CANDIDATE DISCOVERY
    # =====================================================

    def _discover_candidate_relationships(
        self,
        existing_keys: set[
            tuple[
                str,
                tuple[str, ...],
                str,
                tuple[str, ...],
            ]
        ],
    ) -> list[Relationship]:

        """
        Conservative automatic discovery.

        Enterprise rule:

        Candidate target must normally be a PK/unique
        reference key AND source column must provide a
        direction signal such as:

        vehicleid -> vehicle
        ticketid  -> ticket
        branchcode -> branch

        This strongly reduces reverse/noisy candidates.
        """

        candidates: list[
            Relationship
        ] = []

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
                    source_column.get(
                        "name"
                    )
                )

                if not source_column_name:
                    continue

                normalized_source_name = (
                    self._normalize_name(
                        source_column_name
                    )
                )

                if (
                    normalized_source_name
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
                            target_column.get(
                                "name"
                            )
                        )

                        if not target_column_name:
                            continue

                        key = (
                            source_table_name,
                            (
                                source_column_name,
                            ),
                            target_table_name,
                            (
                                target_column_name,
                            ),
                        )

                        if key in existing_keys:
                            continue

                        # ---------------------------------
                        # Enterprise direction guard
                        # ---------------------------------

                        if not (
                            self._is_plausible_reference_direction(
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
                        ):
                            continue

                        scored = (
                            self._score_candidate(
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

                        if scored is None:
                            continue

                        (
                            confidence,
                            evidence,
                        ) = scored

                        if (
                            confidence
                            < self.CANDIDATE_THRESHOLD
                        ):
                            continue

                        relationship_type = (
                            self._infer_relationship_type(
                                source_column
                            )
                        )

                        cardinality = (
                            self._infer_cardinality(
                                source_table=(
                                    source_table
                                ),
                                source_columns=[
                                    source_column_name
                                ],
                                target_table=(
                                    target_table
                                ),
                                target_columns=[
                                    target_column_name
                                ],
                            )
                        )

                        candidate = Relationship(

                            source_table=(
                                source_table_name
                            ),

                            source_columns=[
                                source_column_name
                            ],

                            target_table=(
                                target_table_name
                            ),

                            target_columns=[
                                target_column_name
                            ],

                            relationship_type=(
                                relationship_type
                            ),

                            relationship_source=(
                                RelationshipSource.DISCOVERED
                            ),

                            cardinality=(
                                cardinality
                            ),

                            join_operator="=",

                            confidence_score=round(
                                confidence,
                                4,
                            ),

                            status=(
                                RelationshipStatus.CANDIDATE
                            ),

                            evidence=evidence,

                            description=(
                                "Automatically discovered "
                                "candidate relationship."
                            ),

                            # Do not automatically force
                            # TRIM/LOWER into production
                            # join logic.
                            normalization=(
                                RelationshipNormalization()
                            ),

                            # Tenant scope is NEVER
                            # guessed automatically.
                            tenant_scope=(
                                RelationshipTenantScope()
                            ),

                            governance=(
                                RelationshipGovernance()
                            ),

                            provenance=(
                                self._build_provenance()
                            ),

                            active=True,
                        )

                        candidates.append(
                            candidate
                        )

        return candidates

    # =====================================================
    # DIRECTION GUARD
    # =====================================================

    def _is_plausible_reference_direction(
        self,
        source_column: dict[str, Any],
        target_table_name: str,
        target_table: dict[str, Any],
        target_column: dict[str, Any],
    ) -> bool:

        """
        Avoid reverse relationships.

        Example bad direction:

        role.roleid
            ->
        userrolesaccess.roleid

        Better direction:

        userrolesaccess.roleid
            ->
        role.roleid

        We expect the target side to be PK/unique.
        """

        target_column_name = (
            target_column.get(
                "name"
            )
        )

        if not target_column_name:
            return False

        target_is_pk = (
            self._is_primary_key_columns(
                target_table,
                [target_column_name],
            )
        )

        target_is_unique = (
            self._is_unique_columns(
                target_table,
                [target_column_name],
            )
        )

        if not (
            target_is_pk
            or target_is_unique
        ):
            return False

        table_hint = (
            self._column_mentions_table(
                source_column.get(
                    "name",
                    "",
                ),
                target_table_name,
            )
        )

        semantic_type = (
            self._get_semantic_type(
                source_column
            )
        )

        semantic_reference = (
            semantic_type
            in {
                "foreign_key",
                "business_key",
            }
        )

        return (
            table_hint
            or semantic_reference
        )

    # =====================================================
    # CANDIDATE SCORING
    # =====================================================

    def _score_candidate(
        self,
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

        source_name = (
            self._normalize_name(
                source_column.get(
                    "name",
                    "",
                )
            )
        )

        target_name = (
            self._normalize_name(
                target_column.get(
                    "name",
                    "",
                )
            )
        )

        evidence: list[
            RelationshipEvidence
        ] = []

        score = 0.0

        # -------------------------------------------------
        # Rule 1: Column name similarity
        # -------------------------------------------------

        if source_name == target_name:

            score += 0.30

            evidence.append(
                RelationshipEvidence(
                    rule="column_name_match",
                    score=1.0,
                    description=(
                        "Normalized source and target "
                        "column names are identical."
                    ),
                )
            )

        # -------------------------------------------------
        # Rule 2: Datatype compatibility
        # -------------------------------------------------

        if not self._types_compatible(
            source_column.get(
                "data_type",
                "",
            ),
            target_column.get(
                "data_type",
                "",
            ),
        ):
            return None

        score += 0.20

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

        target_column_name = (
            target_column.get(
                "name"
            )
        )

        # -------------------------------------------------
        # Rule 3: Target PK
        # -------------------------------------------------

        if self._is_primary_key_columns(
            target_table,
            [target_column_name],
        ):

            score += 0.30

            evidence.append(
                RelationshipEvidence(
                    rule="target_primary_key",
                    score=1.0,
                    description=(
                        "Target column is the "
                        "primary key."
                    ),
                )
            )

        # -------------------------------------------------
        # Rule 4: Target unique
        # -------------------------------------------------

        if self._is_unique_columns(
            target_table,
            [target_column_name],
        ):

            score += 0.25

            evidence.append(
                RelationshipEvidence(
                    rule="target_unique",
                    score=1.0,
                    description=(
                        "Target column has a "
                        "unique constraint/index."
                    ),
                )
            )

        # -------------------------------------------------
        # Rule 5: Table/entity name hint
        # -------------------------------------------------

        if self._column_mentions_table(
            source_column.get(
                "name",
                "",
            ),
            target_table_name,
        ):

            score += 0.15

            evidence.append(
                RelationshipEvidence(
                    rule="table_name_hint",
                    score=1.0,
                    description=(
                        "Source column name indicates "
                        "the target business entity."
                    ),
                )
            )

        # -------------------------------------------------
        # Rule 6: Business metadata says FK/business key
        # -------------------------------------------------

        semantic_type = (
            self._get_semantic_type(
                source_column
            )
        )

        if semantic_type in {
            "foreign_key",
            "business_key",
        }:

            score += 0.15

            evidence.append(
                RelationshipEvidence(
                    rule="semantic_reference_hint",
                    score=1.0,
                    description=(
                        "Column metadata indicates "
                        "a reference/business key."
                    ),
                )
            )

        return (
            min(
                score,
                1.0,
            ),
            evidence,
        )

    # =====================================================
    # CARDINALITY
    # =====================================================

    def _infer_cardinality(
        self,
        source_table: dict[str, Any],
        source_columns: list[str],
        target_table: dict[str, Any],
        target_columns: list[str],
    ) -> RelationshipCardinality:

        """
        Infer structural cardinality from PK/unique
        constraints.

        Direction is:

        source -> target
        """

        source_unique = (
            self._is_reference_unique(
                source_table,
                source_columns,
            )
        )

        target_unique = (
            self._is_reference_unique(
                target_table,
                target_columns,
            )
        )

        if (
            source_unique
            and target_unique
        ):
            return (
                RelationshipCardinality.ONE_TO_ONE
            )

        if (
            not source_unique
            and target_unique
        ):
            return (
                RelationshipCardinality.MANY_TO_ONE
            )

        if (
            source_unique
            and not target_unique
        ):
            return (
                RelationshipCardinality.ONE_TO_MANY
            )

        return (
            RelationshipCardinality.MANY_TO_MANY
        )

    def _is_reference_unique(
        self,
        table: dict[str, Any],
        columns: list[str],
    ) -> bool:

        return (
            self._is_primary_key_columns(
                table,
                columns,
            )
            or self._is_unique_columns(
                table,
                columns,
            )
        )

    # =====================================================
    # PRIMARY KEY CHECK
    # =====================================================

    @staticmethod
    def _is_primary_key_columns(
        table: dict[str, Any],
        columns: list[str],
    ) -> bool:

        pk_columns = (
            table.get(
                "primary_key",
                {},
            )
            .get(
                "columns",
                [],
            )
        )

        return (
            len(pk_columns)
            == len(columns)
            and set(pk_columns)
            == set(columns)
        )

    # =====================================================
    # UNIQUE INDEX CHECK
    # =====================================================

    @staticmethod
    def _is_unique_columns(
        table: dict[str, Any],
        columns: list[str],
    ) -> bool:

        for index in table.get(
            "indexes",
            [],
        ):

            if not index.get(
                "unique",
                False,
            ):
                continue

            index_columns = [
                column
                for column in index.get(
                    "columns",
                    [],
                )
                if column is not None
            ]

            if (
                len(index_columns)
                == len(columns)
                and set(index_columns)
                == set(columns)
            ):
                return True

        return False

    # =====================================================
    # MANUAL NORMALIZATION
    # =====================================================

    @staticmethod
    def _build_manual_normalization(
        item: dict[str, Any],
    ) -> RelationshipNormalization:

        config = item.get(
            "normalization",
            {},
        )

        return RelationshipNormalization(
            trim=config.get(
                "trim",
                False,
            ),
            case_insensitive=config.get(
                "case_insensitive",
                False,
            ),
            empty_string_as_null=config.get(
                "empty_string_as_null",
                False,
            ),
        )

    # =====================================================
    # TENANT SCOPE
    # =====================================================

    def _build_manual_tenant_scope(
        self,
        item: dict[str, Any],
        source_table: str,
        target_table: str,
    ) -> RelationshipTenantScope:

        """
        Tenant scope is only enabled when explicitly
        defined in metadata.

        We do NOT automatically guess orgid/companyid
        relationships because that can change SQL logic.
        """

        config = item.get(
            "tenant_scope",
            {},
        )

        enabled = config.get(
            "enabled",
            False,
        )

        if not enabled:

            return RelationshipTenantScope()

        source_columns = list(
            config.get(
                "source_columns",
                [],
            )
        )

        target_columns = list(
            config.get(
                "target_columns",
                [],
            )
        )

        if (
            not source_columns
            or not target_columns
        ):

            logger.warning(
                "Tenant scope enabled but columns "
                "not supplied for %s -> %s. "
                "Tenant scope disabled.",
                source_table,
                target_table,
            )

            return RelationshipTenantScope()

        if (
            len(source_columns)
            != len(target_columns)
        ):

            logger.warning(
                "Tenant scope column count mismatch "
                "for %s -> %s. Tenant scope disabled.",
                source_table,
                target_table,
            )

            return RelationshipTenantScope()

        if not self._columns_exist(
            source_table,
            source_columns,
        ):

            logger.warning(
                "Invalid tenant source columns "
                "for %s: %s",
                source_table,
                source_columns,
            )

            return RelationshipTenantScope()

        if not self._columns_exist(
            target_table,
            target_columns,
        ):

            logger.warning(
                "Invalid tenant target columns "
                "for %s: %s",
                target_table,
                target_columns,
            )

            return RelationshipTenantScope()

        return RelationshipTenantScope(
            enabled=True,

            source_columns=(
                source_columns
            ),

            target_columns=(
                target_columns
            ),

            description=config.get(
                "description"
            ),
        )

    # =====================================================
    # GOVERNANCE
    # =====================================================

    def _build_manual_governance(
        self,
        item: dict[str, Any],
        status: RelationshipStatus,
    ) -> RelationshipGovernance:

        config = item.get(
            "governance",
            {},
        )

        approved_by = config.get(
            "approved_by"
        )

        approval_reason = config.get(
            "approval_reason"
        )

        if (
            status
            == RelationshipStatus.APPROVED
        ):

            approved_by = (
                approved_by
                or "manual_metadata"
            )

            approval_reason = (
                approval_reason
                or item.get(
                    "description"
                )
                or (
                    "Manually approved "
                    "business relationship."
                )
            )

        return RelationshipGovernance(

            approved_by=approved_by,

            approved_at=config.get(
                "approved_at"
            ),

            approval_reason=(
                approval_reason
            ),

            reviewed_by=config.get(
                "reviewed_by"
            ),

            review_notes=config.get(
                "review_notes"
            ),
        )

    # =====================================================
    # PROVENANCE
    # =====================================================

    def _build_provenance(
        self,
        config: dict[str, Any] | None = None,
    ) -> RelationshipProvenance:

        config = config or {}

        return RelationshipProvenance(

            relationship_version=(
                config.get(
                    "relationship_version",
                    1,
                )
            ),

            schema_hash=(
                config.get(
                    "schema_hash"
                )
                or self.schema_hash
            ),

            discovered_at=(
                config.get(
                    "discovered_at"
                )
                or self.generated_at
            ),

            validated_at=config.get(
                "validated_at"
            ),
        )

    # =====================================================
    # RELATIONSHIP TYPE
    # =====================================================

    def _infer_relationship_type(
        self,
        column: dict[str, Any],
    ) -> RelationshipType:

        semantic_type = (
            self._get_semantic_type(
                column
            )
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

        # Important:
        # Discovered relation is NOT marked as real FK.
        return (
            RelationshipType.INFERRED
        )

    # =====================================================
    # SEMANTIC TYPE
    # =====================================================

    @staticmethod
    def _get_semantic_type(
        column: dict[str, Any],
    ) -> str:

        ai_metadata = column.get(
            "ai_metadata",
            {},
        )

        return (
            str(
                ai_metadata.get(
                    "semantic_type",
                    "",
                )
            )
            .strip()
            .lower()
        )

    # =====================================================
    # DATA TYPE COMPATIBILITY
    # =====================================================

    def _types_compatible(
        self,
        source_type: str,
        target_type: str,
    ) -> bool:

        return (
            self._type_family(
                source_type
            )
            ==
            self._type_family(
                target_type
            )
        )

    @staticmethod
    def _type_family(
        data_type: str,
    ) -> str:

        value = str(
            data_type
        ).upper()

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

        if "DATETIME" in value:
            return "datetime"

        if "DATE" in value:
            return "date"

        if "TIME" in value:
            return "time"

        if "BIT" in value:
            return "boolean"

        return value

    # =====================================================
    # TABLE NAME HINT
    # =====================================================

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

        # Project naming examples:
        #
        # tvehicle -> vehicle
        # tdriver  -> driver

        alternatives = {
            table
        }

        if (
            table.startswith("t")
            and len(table) > 2
        ):
            alternatives.add(
                table[1:]
            )

        return any(
            candidate
            and candidate in column
            for candidate in alternatives
        )

    # =====================================================
    # COLUMN EXISTENCE
    # =====================================================

    def _columns_exist(
        self,
        table_name: str,
        column_names: list[str],
    ) -> bool:

        table = self.business_tables.get(
            table_name
        )

        if not table:
            return False

        available_columns = {
            column.get(
                "name"
            )
            for column in table.get(
                "columns",
                [],
            )
        }

        return all(
            column_name
            in available_columns
            for column_name
            in column_names
        )

    # =====================================================
    # OLD/NEW COLUMN FORMAT SUPPORT
    # =====================================================

    @staticmethod
    def _extract_relationship_columns(
        item: dict[str, Any],
        plural_key: str,
        singular_key: str,
    ) -> list[str]:

        values = item.get(
            plural_key
        )

        if values:

            return list(
                values
            )

        value = item.get(
            singular_key
        )

        if value:

            return [
                value
            ]

        return []

    # =====================================================
    # ENUM PARSERS
    # =====================================================

    @staticmethod
    def _parse_relationship_type(
        value: str | None,
    ) -> RelationshipType:

        if not value:

            return (
                RelationshipType.VALUE_MATCH
            )

        try:

            return RelationshipType(
                value
            )

        except ValueError:

            return (
                RelationshipType.VALUE_MATCH
            )

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

    @staticmethod
    def _parse_cardinality(
        value: str,
    ) -> RelationshipCardinality:

        try:

            return RelationshipCardinality(
                value
            )

        except ValueError:

            return (
                RelationshipCardinality.UNKNOWN
            )

    # =====================================================
    # NAME NORMALIZATION
    # =====================================================

    @staticmethod
    def _normalize_name(
        value: str,
    ) -> str:

        return re.sub(
            r"[^a-z0-9]",
            "",
            str(value).lower(),
        )

    # =====================================================
    # RELATIONSHIP KEY
    # =====================================================

    @staticmethod
    def _relationship_key(
        relationship: Relationship,
    ) -> tuple[
        str,
        tuple[str, ...],
        str,
        tuple[str, ...],
    ]:

        return (
            relationship.source_table,

            tuple(
                relationship.source_columns
            ),

            relationship.target_table,

            tuple(
                relationship.target_columns
            ),
        )

    # =====================================================
    # DEDUPLICATION
    # =====================================================

    def _deduplicate(
        self,
        relationships: list[
            Relationship
        ],
    ) -> list[Relationship]:

        """
        Priority follows insertion order:

        Database FK
            ↓
        Manual relationship
            ↓
        Discovered candidate

        So a discovered candidate cannot override
        an already trusted database/manual relation.
        """

        result: list[
            Relationship
        ] = []

        seen: set[
            tuple[
                str,
                tuple[str, ...],
                str,
                tuple[str, ...],
            ]
        ] = set()

        for relationship in relationships:

            key = self._relationship_key(
                relationship
            )

            if key in seen:
                continue

            seen.add(
                key
            )

            result.append(
                relationship
            )

        return result