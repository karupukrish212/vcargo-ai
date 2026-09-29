import logging
from datetime import datetime, timezone
from typing import Any

from sqlalchemy import text
from sqlalchemy.engine import Engine
from sqlalchemy.exc import SQLAlchemyError

from app.schema.relationships.models import (
    Relationship,
    RelationshipCardinality,
    RelationshipCatalog,
    RelationshipSource,
    RelationshipStatus,
    RelationshipValidation,
    ValidatedRelationship,
    ValidatedRelationshipCatalog,
)


logger = logging.getLogger(__name__)


# =========================================================
# EXCEPTION
# =========================================================


class RelationshipValidationError(Exception):
    """
    Raised when relationship validation cannot
    be completed safely.
    """

    pass


# =========================================================
# VALIDATOR
# =========================================================


class RelationshipValidator:
    """
    Enterprise-grade relationship validator.

    Supports:

    - Single-column relationships
    - Composite relationships
    - Tenant-aware joins
    - Data overlap validation
    - Source/target uniqueness validation
    - Cardinality validation
    - Manual approval protection
    - Provenance updates
    - Schema-hash protection
    - Read-only MySQL validation

    Important behaviour:

    1. MySQL declared FK
       -> trusted

    2. Manual + approved relationship
       -> structurally validated
       -> data statistics collected
       -> remains approved even if sample size is small

    3. Automatically discovered relationship
       -> must pass data validation
    """

    APPROVE_OVERLAP_THRESHOLD = 0.95

    REVIEW_OVERLAP_THRESHOLD = 0.70

    MIN_DISTINCT_VALUES_FOR_AUTO_APPROVAL = 5

    ALLOWED_JOIN_OPERATORS = {
        "=",
    }

    # =====================================================
    # INIT
    # =====================================================

    def __init__(
        self,
        engine: Engine,
        enriched_catalog: dict[str, Any],
        relationship_catalog: RelationshipCatalog,
    ) -> None:

        self.engine = engine

        self.enriched_catalog = (
            enriched_catalog
        )

        self.relationship_catalog = (
            relationship_catalog
        )

        self.tables = (
            self._build_table_lookup()
        )

        self.current_schema_hash = (
            self._get_schema_hash()
        )

    # =====================================================
    # MAIN VALIDATION
    # =====================================================

    def validate(
        self,
    ) -> ValidatedRelationshipCatalog:

        logger.info(
            "Starting enterprise relationship validation"
        )

        # -------------------------------------------------
        # Ensure relationship candidates belong to
        # current enriched schema.
        # -------------------------------------------------

        self._validate_schema_hash()

        validated_relationships: list[
            ValidatedRelationship
        ] = []

        for relationship in (
            self.relationship_catalog.relationships
        ):

            # -------------------------------------------------
            # Inactive relationship
            # -------------------------------------------------

            if not relationship.active:

                logger.info(
                    "Skipping inactive relationship: "
                    "%s",
                    relationship.relationship_id,
                )

                continue

            # -------------------------------------------------
            # Declared MySQL FK
            #
            # Database constraint itself is trusted.
            # No expensive data scan required.
            # -------------------------------------------------

            if (
                relationship.relationship_source
                == RelationshipSource.DATABASE
                and relationship.status
                == RelationshipStatus.APPROVED
            ):

                validated_relationships.append(
                    self._copy_database_relationship(
                        relationship
                    )
                )

                continue

            # -------------------------------------------------
            # Manual / discovered relationship
            # -------------------------------------------------

            validated_relationship = (
                self._validate_relationship(
                    relationship
                )
            )

            validated_relationships.append(
                validated_relationship
            )

        # -------------------------------------------------
        # Counts
        # -------------------------------------------------

        approved_count = sum(
            1
            for relationship
            in validated_relationships
            if relationship.status
            == RelationshipStatus.APPROVED
        )

        needs_review_count = sum(
            1
            for relationship
            in validated_relationships
            if relationship.status
            == RelationshipStatus.NEEDS_REVIEW
        )

        rejected_count = sum(
            1
            for relationship
            in validated_relationships
            if relationship.status
            == RelationshipStatus.REJECTED
        )

        logger.info(
            "Relationship validation completed. "
            "Approved=%d NeedsReview=%d Rejected=%d",
            approved_count,
            needs_review_count,
            rejected_count,
        )

        return ValidatedRelationshipCatalog(

            schema_hash=(
                self.relationship_catalog.schema_hash
            ),

            approved_count=(
                approved_count
            ),

            needs_review_count=(
                needs_review_count
            ),

            rejected_count=(
                rejected_count
            ),

            relationships=(
                validated_relationships
            ),
        )

    # =====================================================
    # VALIDATE ONE RELATIONSHIP
    # =====================================================

    def _validate_relationship(
        self,
        relationship: Relationship,
    ) -> ValidatedRelationship:

        logger.info(
            "Validating relationship: "
            "%s.%s -> %s.%s",
            relationship.source_table,
            relationship.source_columns,
            relationship.target_table,
            relationship.target_columns,
        )

        try:

            # -------------------------------------------------
            # 1. Structural validation
            # -------------------------------------------------

            self._validate_schema_objects(
                relationship
            )

            # -------------------------------------------------
            # 2. Effective relationship key
            #
            # Example:
            #
            # trip.branchcode = branch.branchcode
            #
            # Tenant-aware:
            #
            # AND trip.orgid = branch.orgid
            # -------------------------------------------------

            key_pairs = (
                self._build_effective_key_pairs(
                    relationship
                )
            )

            # -------------------------------------------------
            # 3. Datatype compatibility
            # -------------------------------------------------

            for pair in key_pairs:

                if (
                    pair["source_type_family"]
                    != pair["target_type_family"]
                ):

                    validation = (
                        RelationshipValidation(

                            tenant_scope_applied=(
                                relationship
                                .tenant_scope
                                .enabled
                            ),

                            validated_at=(
                                self._utc_now()
                            ),

                            validation_note=(
                                "Relationship rejected "
                                "because source and target "
                                "column datatype families "
                                "are incompatible. "
                                f"Source "
                                f"{pair['source_column']}="
                                f"{pair['source_type_family']}, "
                                f"target "
                                f"{pair['target_column']}="
                                f"{pair['target_type_family']}."
                            ),
                        )
                    )

                    return self._build_result(

                        relationship=(
                            relationship
                        ),

                        status=(
                            RelationshipStatus.REJECTED
                        ),

                        validation=(
                            validation
                        ),
                    )

            # -------------------------------------------------
            # 4. Source statistics
            # -------------------------------------------------

            source_stats = (
                self._get_key_statistics(

                    table_name=(
                        relationship.source_table
                    ),

                    alias="s",

                    key_pairs=(
                        key_pairs
                    ),

                    side="source",

                    relationship=(
                        relationship
                    ),
                )
            )

            # -------------------------------------------------
            # 5. Target statistics
            # -------------------------------------------------

            target_stats = (
                self._get_key_statistics(

                    table_name=(
                        relationship.target_table
                    ),

                    alias="t",

                    key_pairs=(
                        key_pairs
                    ),

                    side="target",

                    relationship=(
                        relationship
                    ),
                )
            )

            # -------------------------------------------------
            # 6. Matched distinct values
            # -------------------------------------------------

            matched_values = (
                self._get_matched_distinct_count(
                    relationship=(
                        relationship
                    ),
                    key_pairs=(
                        key_pairs
                    ),
                )
            )

            source_distinct = int(
                source_stats[
                    "distinct_values"
                ]
            )

            target_distinct = int(
                target_stats[
                    "distinct_values"
                ]
            )

            unmatched_values = max(
                source_distinct
                - matched_values,
                0,
            )

            # -------------------------------------------------
            # 7. Overlap ratio
            # -------------------------------------------------

            if source_distinct > 0:

                overlap_ratio = (
                    matched_values
                    / source_distinct
                )

            else:

                overlap_ratio = 0.0

            # -------------------------------------------------
            # 8. Null ratio
            # -------------------------------------------------

            total_rows = int(
                source_stats[
                    "total_rows"
                ]
            )

            complete_key_rows = int(
                source_stats[
                    "non_null_rows"
                ]
            )

            if total_rows > 0:

                source_null_ratio = (
                    (
                        total_rows
                        - complete_key_rows
                    )
                    / total_rows
                )

            else:

                source_null_ratio = 0.0

            # -------------------------------------------------
            # 9. Duplicate / uniqueness information
            # -------------------------------------------------

            source_duplicate_groups = int(
                source_stats[
                    "duplicate_groups"
                ]
            )

            target_duplicate_groups = int(
                target_stats[
                    "duplicate_groups"
                ]
            )

            source_unique = (
                self._resolve_uniqueness(

                    distinct_values=(
                        source_distinct
                    ),

                    duplicate_groups=(
                        source_duplicate_groups
                    ),
                )
            )

            target_unique = (
                self._resolve_uniqueness(

                    distinct_values=(
                        target_distinct
                    ),

                    duplicate_groups=(
                        target_duplicate_groups
                    ),
                )
            )

            # -------------------------------------------------
            # 10. Observed cardinality
            # -------------------------------------------------

            observed_cardinality = (
                self._infer_observed_cardinality(

                    source_unique=(
                        source_unique
                    ),

                    target_unique=(
                        target_unique
                    ),
                )
            )

            # -------------------------------------------------
            # 11. Compare declared vs observed cardinality
            # -------------------------------------------------

            cardinality_compatible = (
                self._is_cardinality_compatible(

                    declared=(
                        relationship.cardinality
                    ),

                    observed=(
                        observed_cardinality
                    ),
                )
            )

            validated_at = (
                self._utc_now()
            )

            # -------------------------------------------------
            # 12. Build validation evidence
            # -------------------------------------------------

            validation = (
                RelationshipValidation(

                    source_total_rows=(
                        total_rows
                    ),

                    source_non_null_rows=(
                        complete_key_rows
                    ),

                    source_distinct_values=(
                        source_distinct
                    ),

                    target_distinct_values=(
                        target_distinct
                    ),

                    matched_distinct_values=(
                        matched_values
                    ),

                    unmatched_distinct_values=(
                        unmatched_values
                    ),

                    value_overlap_ratio=round(
                        overlap_ratio,
                        4,
                    ),

                    source_null_ratio=round(
                        source_null_ratio,
                        4,
                    ),

                    source_duplicate_groups=(
                        source_duplicate_groups
                    ),

                    target_duplicate_groups=(
                        target_duplicate_groups
                    ),

                    source_unique=(
                        source_unique
                    ),

                    target_unique=(
                        target_unique
                    ),

                    observed_cardinality=(
                        observed_cardinality
                    ),

                    cardinality_compatible=(
                        cardinality_compatible
                    ),

                    tenant_scope_applied=(
                        relationship
                        .tenant_scope
                        .enabled
                    ),

                    validated_at=(
                        validated_at
                    ),
                )
            )

            # -------------------------------------------------
            # 13. Statistical validation decision
            # -------------------------------------------------

            (
                statistical_status,
                statistical_note,
            ) = self._decide_status(

                declared_cardinality=(
                    relationship.cardinality
                ),

                source_distinct=(
                    source_distinct
                ),

                target_distinct=(
                    target_distinct
                ),

                overlap_ratio=(
                    overlap_ratio
                ),

                source_unique=(
                    source_unique
                ),

                target_unique=(
                    target_unique
                ),

                cardinality_compatible=(
                    cardinality_compatible
                ),
            )

            # =================================================
            # IMPORTANT ENTERPRISE RULE
            #
            # Manual + Approved relationship
            #
            # Development/business team already confirmed it.
            #
            # Data validation becomes monitoring evidence.
            #
            # Low sample size / temporary data drift should NOT
            # remove the manual approval.
            # =================================================

            if self._is_manually_approved(
                relationship
            ):

                status = (
                    RelationshipStatus.APPROVED
                )

                if (
                    statistical_status
                    == RelationshipStatus.APPROVED
                ):

                    validation.validation_note = (
                        "Relationship is manually approved "
                        "and current database validation "
                        "also supports the relationship. "
                        f"{statistical_note}"
                    )

                else:

                    validation.validation_note = (
                        "Relationship remains approved "
                        "because it was explicitly "
                        "confirmed in business metadata. "
                        "Current database validation "
                        "reported a monitoring observation: "
                        f"{statistical_note}"
                    )

            else:

                status = (
                    statistical_status
                )

                validation.validation_note = (
                    statistical_note
                )

            # -------------------------------------------------
            # 14. Final result
            # -------------------------------------------------

            return self._build_result(

                relationship=(
                    relationship
                ),

                status=(
                    status
                ),

                validation=(
                    validation
                ),
            )

        except RelationshipValidationError:

            raise

        except SQLAlchemyError as exc:

            logger.exception(
                "Database validation failed for "
                "%s.%s -> %s.%s",
                relationship.source_table,
                relationship.source_columns,
                relationship.target_table,
                relationship.target_columns,
            )

            raise RelationshipValidationError(
                "Relationship validation query failed "
                f"for relationship "
                f"{relationship.relationship_id}."
            ) from exc

    # =====================================================
    # MANUAL APPROVAL CHECK
    # =====================================================

    @staticmethod
    def _is_manually_approved(
        relationship: Relationship,
    ) -> bool:
        """
        Manual approval is authoritative.

        Example:

        schema_metadata.json

        relationship_source = manual
        status = approved
        """

        return (
            relationship.relationship_source
            == RelationshipSource.MANUAL

            and relationship.status
            == RelationshipStatus.APPROVED
        )

    # =====================================================
    # EFFECTIVE KEY
    # =====================================================

    def _build_effective_key_pairs(
        self,
        relationship: Relationship,
    ) -> list[dict[str, Any]]:

        """
        Build complete relationship key.

        Main example:

        trip.branchcode
            =
        branch.branchcode

        Tenant example:

        trip.branchcode = branch.branchcode
        AND
        trip.orgid = branch.orgid
        """

        pairs: list[
            dict[str, Any]
        ] = []

        # -------------------------------------------------
        # Main relationship columns
        # -------------------------------------------------

        for (
            source_column,
            target_column,
        ) in zip(
            relationship.source_columns,
            relationship.target_columns,
            strict=True,
        ):

            pairs.append(
                self._build_key_pair(

                    relationship=(
                        relationship
                    ),

                    source_column=(
                        source_column
                    ),

                    target_column=(
                        target_column
                    ),

                    tenant_column=False,
                )
            )

        # -------------------------------------------------
        # Tenant scope
        # -------------------------------------------------

        if (
            relationship
            .tenant_scope
            .enabled
        ):

            for (
                source_column,
                target_column,
            ) in zip(

                relationship
                .tenant_scope
                .source_columns,

                relationship
                .tenant_scope
                .target_columns,

                strict=True,
            ):

                # Avoid duplicate condition
                already_exists = any(

                    pair[
                        "source_column"
                    ]
                    == source_column

                    and pair[
                        "target_column"
                    ]
                    == target_column

                    for pair in pairs
                )

                if already_exists:
                    continue

                pairs.append(
                    self._build_key_pair(

                        relationship=(
                            relationship
                        ),

                        source_column=(
                            source_column
                        ),

                        target_column=(
                            target_column
                        ),

                        tenant_column=True,
                    )
                )

        if not pairs:

            raise RelationshipValidationError(
                "Relationship does not contain "
                "any valid key columns."
            )

        return pairs

    # =====================================================
    # BUILD KEY PAIR
    # =====================================================

    def _build_key_pair(
        self,
        relationship: Relationship,
        source_column: str,
        target_column: str,
        tenant_column: bool,
    ) -> dict[str, Any]:

        source_definition = (
            self._get_column(
                relationship.source_table,
                source_column,
            )
        )

        target_definition = (
            self._get_column(
                relationship.target_table,
                target_column,
            )
        )

        return {

            "source_column": (
                source_column
            ),

            "target_column": (
                target_column
            ),

            "source_type_family": (
                self._type_family(
                    source_definition.get(
                        "data_type",
                        "",
                    )
                )
            ),

            "target_type_family": (
                self._type_family(
                    target_definition.get(
                        "data_type",
                        "",
                    )
                )
            ),

            "tenant_column": (
                tenant_column
            ),
        }

    # =====================================================
    # KEY STATISTICS
    # =====================================================

    def _get_key_statistics(
        self,
        table_name: str,
        alias: str,
        key_pairs: list[dict[str, Any]],
        side: str,
        relationship: Relationship,
    ) -> dict[str, int]:

        table = (
            self._quote_identifier(
                table_name
            )
        )

        expressions = (
            self._build_side_expressions(

                alias=(
                    alias
                ),

                key_pairs=(
                    key_pairs
                ),

                side=(
                    side
                ),

                relationship=(
                    relationship
                ),
            )
        )

        if not expressions:

            raise RelationshipValidationError(
                "Relationship has no "
                "validation expressions."
            )

        # -------------------------------------------------
        # Example:
        #
        # s.`branchcode` IS NOT NULL
        # AND
        # s.`orgid` IS NOT NULL
        # -------------------------------------------------

        non_null_condition = (
            " AND ".join(
                f"{expression} IS NOT NULL"
                for expression
                in expressions
            )
        )

        # -------------------------------------------------
        # Used inside subquery
        # -------------------------------------------------

        select_expressions = (
            ", ".join(
                (
                    f"{expression} "
                    f"AS key_{index}"
                )

                for index, expression
                in enumerate(
                    expressions
                )
            )
        )

        group_expressions = (
            ", ".join(
                expressions
            )
        )

        # -------------------------------------------------
        # Query 1:
        # total + complete-key rows
        # -------------------------------------------------

        row_query = text(
            f"""
            SELECT
                COUNT(*) AS total_rows,

                COALESCE(
                    SUM(
                        CASE
                            WHEN {non_null_condition}
                            THEN 1
                            ELSE 0
                        END
                    ),
                    0
                ) AS non_null_rows

            FROM {table} AS {alias}
            """
        )

        # -------------------------------------------------
        # Query 2:
        # distinct relationship keys
        #
        # Works for:
        #
        # userid
        #
        # AND composite:
        #
        # (orgid, branchcode)
        # -------------------------------------------------

        distinct_query = text(
            f"""
            SELECT
                COUNT(*) AS distinct_values

            FROM (
                SELECT DISTINCT
                    {select_expressions}

                FROM {table} AS {alias}

                WHERE
                    {non_null_condition}
            ) AS distinct_keys
            """
        )

        # -------------------------------------------------
        # Query 3:
        # duplicate key groups
        # -------------------------------------------------

        duplicate_query = text(
            f"""
            SELECT
                COUNT(*) AS duplicate_groups

            FROM (
                SELECT
                    {select_expressions}

                FROM {table} AS {alias}

                WHERE
                    {non_null_condition}

                GROUP BY
                    {group_expressions}

                HAVING
                    COUNT(*) > 1
            ) AS duplicate_keys
            """
        )

        with self.engine.connect() as connection:

            row_result = (
                connection.execute(
                    row_query
                )
                .mappings()
                .one()
            )

            distinct_result = (
                connection.execute(
                    distinct_query
                )
                .mappings()
                .one()
            )

            duplicate_result = (
                connection.execute(
                    duplicate_query
                )
                .mappings()
                .one()
            )

        return {

            "total_rows": int(
                row_result[
                    "total_rows"
                ]
                or 0
            ),

            "non_null_rows": int(
                row_result[
                    "non_null_rows"
                ]
                or 0
            ),

            "distinct_values": int(
                distinct_result[
                    "distinct_values"
                ]
                or 0
            ),

            "duplicate_groups": int(
                duplicate_result[
                    "duplicate_groups"
                ]
                or 0
            ),
        }

    # =====================================================
    # MATCHED DISTINCT COUNT
    # =====================================================

    def _get_matched_distinct_count(
        self,
        relationship: Relationship,
        key_pairs: list[dict[str, Any]],
    ) -> int:

        source_table = (
            self._quote_identifier(
                relationship.source_table
            )
        )

        target_table = (
            self._quote_identifier(
                relationship.target_table
            )
        )

        source_expressions = (
            self._build_side_expressions(

                alias="s",

                key_pairs=(
                    key_pairs
                ),

                side="source",

                relationship=(
                    relationship
                ),
            )
        )

        target_expressions = (
            self._build_side_expressions(

                alias="t",

                key_pairs=(
                    key_pairs
                ),

                side="target",

                relationship=(
                    relationship
                ),
            )
        )

        # -------------------------------------------------
        # Build JOIN
        # -------------------------------------------------

        join_conditions = (
            " AND ".join(
                (
                    f"{source_expression} "
                    f"{relationship.join_operator} "
                    f"{target_expression}"
                )

                for (
                    source_expression,
                    target_expression,
                )

                in zip(
                    source_expressions,
                    target_expressions,
                    strict=True,
                )
            )
        )

        # -------------------------------------------------
        # Ignore incomplete source relationship keys
        # -------------------------------------------------

        source_non_null = (
            " AND ".join(
                f"{expression} IS NOT NULL"
                for expression
                in source_expressions
            )
        )

        select_expressions = (
            ", ".join(
                (
                    f"{expression} "
                    f"AS key_{index}"
                )

                for index, expression
                in enumerate(
                    source_expressions
                )
            )
        )

        query = text(
            f"""
            SELECT
                COUNT(*) AS matched_values

            FROM (
                SELECT DISTINCT
                    {select_expressions}

                FROM {source_table} AS s

                INNER JOIN
                    {target_table} AS t

                    ON {join_conditions}

                WHERE
                    {source_non_null}
            ) AS matched_keys
            """
        )

        with self.engine.connect() as connection:

            row = (
                connection.execute(
                    query
                )
                .mappings()
                .one()
            )

        return int(
            row[
                "matched_values"
            ]
            or 0
        )

    # =====================================================
    # SQL SIDE EXPRESSIONS
    # =====================================================

    def _build_side_expressions(
        self,
        alias: str,
        key_pairs: list[dict[str, Any]],
        side: str,
        relationship: Relationship,
    ) -> list[str]:

        expressions: list[
            str
        ] = []

        for pair in key_pairs:

            column_name = pair[
                f"{side}_column"
            ]

            type_family = pair[
                f"{side}_type_family"
            ]

            expression = (
                self._normalized_expression(

                    alias=(
                        alias
                    ),

                    column_name=(
                        column_name
                    ),

                    type_family=(
                        type_family
                    ),

                    relationship=(
                        relationship
                    ),
                )
            )

            expressions.append(
                expression
            )

        return expressions

    # =====================================================
    # NORMALIZATION
    # =====================================================

    def _normalized_expression(
        self,
        alias: str,
        column_name: str,
        type_family: str,
        relationship: Relationship,
    ) -> str:

        column = (
            self._quote_identifier(
                column_name
            )
        )

        expression = (
            f"{alias}.{column}"
        )

        normalization = (
            relationship.normalization
        )

        # -------------------------------------------------
        # Apply string normalization only when
        # explicitly configured in relationship metadata.
        # -------------------------------------------------

        if type_family == "string":

            if normalization.trim:

                expression = (
                    f"TRIM({expression})"
                )

            if (
                normalization
                .case_insensitive
            ):

                expression = (
                    f"LOWER({expression})"
                )

            if (
                normalization
                .empty_string_as_null
            ):

                expression = (
                    f"NULLIF({expression}, '')"
                )

        return expression

    # =====================================================
    # AUTOMATIC STATUS DECISION
    # =====================================================

    def _decide_status(
        self,
        declared_cardinality: RelationshipCardinality,
        source_distinct: int,
        target_distinct: int,
        overlap_ratio: float,
        source_unique: bool | None,
        target_unique: bool | None,
        cardinality_compatible: bool | None,
    ) -> tuple[
        RelationshipStatus,
        str,
    ]:

        # -------------------------------------------------
        # Source empty
        # -------------------------------------------------

        if source_distinct == 0:

            return (
                RelationshipStatus.NEEDS_REVIEW,

                (
                    "Source relationship key currently "
                    "contains no non-null distinct values. "
                    "Relationship cannot be statistically "
                    "confirmed from current data."
                ),
            )

        # -------------------------------------------------
        # Target empty
        # -------------------------------------------------

        if target_distinct == 0:

            return (
                RelationshipStatus.NEEDS_REVIEW,

                (
                    "Target relationship key currently "
                    "contains no non-null distinct values. "
                    "Relationship cannot be statistically "
                    "confirmed from current data."
                ),
            )

        # -------------------------------------------------
        # Small dataset
        # -------------------------------------------------

        if (
            source_distinct
            < self.MIN_DISTINCT_VALUES_FOR_AUTO_APPROVAL
        ):

            return (
                RelationshipStatus.NEEDS_REVIEW,

                (
                    "Relationship currently has only "
                    f"{source_distinct} distinct source "
                    "key value(s). Minimum required for "
                    "automatic approval is "
                    f"{self.MIN_DISTINCT_VALUES_FOR_AUTO_APPROVAL}."
                ),
            )

        # -------------------------------------------------
        # Cardinality contradiction
        # -------------------------------------------------

        if (
            cardinality_compatible
            is False
        ):

            return (
                RelationshipStatus.NEEDS_REVIEW,

                (
                    "Observed database cardinality "
                    "does not match the declared "
                    f"cardinality "
                    f"'{declared_cardinality.value}'."
                ),
            )

        # -------------------------------------------------
        # Weak overlap
        # -------------------------------------------------

        if (
            overlap_ratio
            < self.REVIEW_OVERLAP_THRESHOLD
        ):

            return (
                RelationshipStatus.REJECTED,

                (
                    "Relationship value overlap "
                    f"is {overlap_ratio:.2%}, which "
                    "is below the minimum review "
                    f"threshold of "
                    f"{self.REVIEW_OVERLAP_THRESHOLD:.0%}."
                ),
            )

        # -------------------------------------------------
        # Moderate overlap
        # -------------------------------------------------

        if (
            overlap_ratio
            < self.APPROVE_OVERLAP_THRESHOLD
        ):

            return (
                RelationshipStatus.NEEDS_REVIEW,

                (
                    "Relationship has moderate "
                    f"value overlap of "
                    f"{overlap_ratio:.2%}. "
                    "Human review is recommended."
                ),
            )

        # =================================================
        # HIGH OVERLAP
        #
        # Now cardinality-specific uniqueness checks
        # =================================================

        # -------------------------------------------------
        # ONE -> ONE
        # -------------------------------------------------

        if (
            declared_cardinality
            == RelationshipCardinality.ONE_TO_ONE
        ):

            if (
                source_unique is True
                and target_unique is True
            ):

                return (
                    RelationshipStatus.APPROVED,

                    (
                        "High value overlap and both "
                        "source and target keys are unique, "
                        "supporting one-to-one cardinality."
                    ),
                )

            return (
                RelationshipStatus.NEEDS_REVIEW,

                (
                    "High value overlap found, but "
                    "one-to-one cardinality requires "
                    "both source and target keys "
                    "to be unique."
                ),
            )

        # -------------------------------------------------
        # MANY -> ONE
        # -------------------------------------------------

        if (
            declared_cardinality
            == RelationshipCardinality.MANY_TO_ONE
        ):

            if target_unique is True:

                return (
                    RelationshipStatus.APPROVED,

                    (
                        "High value overlap with a "
                        "unique target key, supporting "
                        "many-to-one cardinality."
                    ),
                )

            return (
                RelationshipStatus.NEEDS_REVIEW,

                (
                    "High value overlap found, but "
                    "the target key is not unique. "
                    "This may cause duplicate rows "
                    "during SQL joins."
                ),
            )

        # -------------------------------------------------
        # ONE -> MANY
        # -------------------------------------------------

        if (
            declared_cardinality
            == RelationshipCardinality.ONE_TO_MANY
        ):

            if source_unique is True:

                return (
                    RelationshipStatus.APPROVED,

                    (
                        "High value overlap with a "
                        "unique source key, supporting "
                        "one-to-many cardinality."
                    ),
                )

            return (
                RelationshipStatus.NEEDS_REVIEW,

                (
                    "High value overlap found, but "
                    "the source key is not unique "
                    "as expected for one-to-many "
                    "cardinality."
                ),
            )

        # -------------------------------------------------
        # MANY -> MANY
        # -------------------------------------------------

        if (
            declared_cardinality
            == RelationshipCardinality.MANY_TO_MANY
        ):

            return (
                RelationshipStatus.APPROVED,

                (
                    "High value overlap supports "
                    "the declared many-to-many "
                    "relationship."
                ),
            )

        # -------------------------------------------------
        # Cardinality unknown
        # -------------------------------------------------

        return (
            RelationshipStatus.NEEDS_REVIEW,

            (
                "High relationship value overlap "
                "was found, but relationship "
                "cardinality is unknown."
            ),
        )

    # =====================================================
    # UNIQUENESS
    # =====================================================

    @staticmethod
    def _resolve_uniqueness(
        distinct_values: int,
        duplicate_groups: int,
    ) -> bool | None:

        # No data:
        # cannot conclude uniqueness.

        if distinct_values == 0:

            return None

        return (
            duplicate_groups == 0
        )

    # =====================================================
    # OBSERVED CARDINALITY
    # =====================================================

    @staticmethod
    def _infer_observed_cardinality(
        source_unique: bool | None,
        target_unique: bool | None,
    ) -> RelationshipCardinality:

        if (
            source_unique is None
            or target_unique is None
        ):

            return (
                RelationshipCardinality.UNKNOWN
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

    # =====================================================
    # CARDINALITY COMPATIBILITY
    # =====================================================

    @staticmethod
    def _is_cardinality_compatible(
        declared: RelationshipCardinality,
        observed: RelationshipCardinality,
    ) -> bool | None:

        """
        Important:

        Current data can show a narrower relationship
        than the database/business model allows.

        Example:

        Declared:
            MANY_TO_ONE

        Current test data:
            ONE_TO_ONE

        That is still compatible.
        """

        if (
            declared
            == RelationshipCardinality.UNKNOWN
            or observed
            == RelationshipCardinality.UNKNOWN
        ):

            return None

        # -------------------------------------------------
        # One-to-one must remain one-to-one
        # -------------------------------------------------

        if (
            declared
            == RelationshipCardinality.ONE_TO_ONE
        ):

            return (
                observed
                == RelationshipCardinality.ONE_TO_ONE
            )

        # -------------------------------------------------
        # Many-to-one may currently appear one-to-one
        # -------------------------------------------------

        if (
            declared
            == RelationshipCardinality.MANY_TO_ONE
        ):

            return observed in {

                RelationshipCardinality.ONE_TO_ONE,

                RelationshipCardinality.MANY_TO_ONE,
            }

        # -------------------------------------------------
        # One-to-many may currently appear one-to-one
        # -------------------------------------------------

        if (
            declared
            == RelationshipCardinality.ONE_TO_MANY
        ):

            return observed in {

                RelationshipCardinality.ONE_TO_ONE,

                RelationshipCardinality.ONE_TO_MANY,
            }

        # -------------------------------------------------
        # Many-to-many permits narrower current samples
        # -------------------------------------------------

        if (
            declared
            == RelationshipCardinality.MANY_TO_MANY
        ):

            return True

        return None

    # =====================================================
    # SCHEMA TABLE LOOKUP
    # =====================================================

    def _build_table_lookup(
        self,
    ) -> dict[str, dict[str, Any]]:

        return {

            table[
                "table_name"
            ]: table

            for table
            in self.enriched_catalog.get(
                "tables",
                [],
            )

            if table.get(
                "table_name"
            )
        }

    # =====================================================
    # GET COLUMN
    # =====================================================

    def _get_column(
        self,
        table_name: str,
        column_name: str,
    ) -> dict[str, Any]:

        table = (
            self.tables.get(
                table_name
            )
        )

        if not table:

            raise RelationshipValidationError(
                f"Unknown relationship table: "
                f"{table_name}"
            )

        for column in table.get(
            "columns",
            [],
        ):

            if (
                column.get(
                    "name"
                )
                == column_name
            ):

                return column

        raise RelationshipValidationError(
            f"Unknown relationship column: "
            f"{table_name}.{column_name}"
        )

    # =====================================================
    # STRUCTURAL VALIDATION
    # =====================================================

    def _validate_schema_objects(
        self,
        relationship: Relationship,
    ) -> None:

        # -------------------------------------------------
        # Join operator safety
        # -------------------------------------------------

        if (
            relationship.join_operator
            not in self.ALLOWED_JOIN_OPERATORS
        ):

            raise RelationshipValidationError(
                "Unsupported relationship join operator: "
                f"{relationship.join_operator!r}"
            )

        # -------------------------------------------------
        # Table existence
        # -------------------------------------------------

        if (
            relationship.source_table
            not in self.tables
        ):

            raise RelationshipValidationError(
                "Unknown source table: "
                f"{relationship.source_table}"
            )

        if (
            relationship.target_table
            not in self.tables
        ):

            raise RelationshipValidationError(
                "Unknown target table: "
                f"{relationship.target_table}"
            )

        # -------------------------------------------------
        # Main relationship column count
        # -------------------------------------------------

        if (
            len(
                relationship.source_columns
            )
            != len(
                relationship.target_columns
            )
        ):

            raise RelationshipValidationError(
                "Relationship source_columns and "
                "target_columns must have equal length."
            )

        if not relationship.source_columns:

            raise RelationshipValidationError(
                "Relationship source_columns "
                "cannot be empty."
            )

        # -------------------------------------------------
        # Main columns
        # -------------------------------------------------

        for column in (
            relationship.source_columns
        ):

            self._get_column(
                relationship.source_table,
                column,
            )

        for column in (
            relationship.target_columns
        ):

            self._get_column(
                relationship.target_table,
                column,
            )

        # -------------------------------------------------
        # Tenant scope
        # -------------------------------------------------

        if (
            relationship
            .tenant_scope
            .enabled
        ):

            tenant_source_columns = (
                relationship
                .tenant_scope
                .source_columns
            )

            tenant_target_columns = (
                relationship
                .tenant_scope
                .target_columns
            )

            if (
                not tenant_source_columns
                or not tenant_target_columns
            ):

                raise RelationshipValidationError(
                    "Tenant scope is enabled, but "
                    "tenant columns are missing."
                )

            if (
                len(
                    tenant_source_columns
                )
                != len(
                    tenant_target_columns
                )
            ):

                raise RelationshipValidationError(
                    "Tenant scope source_columns and "
                    "target_columns must have "
                    "equal length."
                )

            for column in (
                tenant_source_columns
            ):

                self._get_column(
                    relationship.source_table,
                    column,
                )

            for column in (
                tenant_target_columns
            ):

                self._get_column(
                    relationship.target_table,
                    column,
                )

    # =====================================================
    # SCHEMA HASH
    # =====================================================

    def _get_schema_hash(
        self,
    ) -> str:

        return (
            self.enriched_catalog.get(
                "schema_hash"
            )
            or self.enriched_catalog.get(
                "source_schema_hash"
            )
            or ""
        )

    def _validate_schema_hash(
        self,
    ) -> None:

        relationship_hash = (
            self.relationship_catalog.schema_hash
        )

        if not relationship_hash:

            raise RelationshipValidationError(
                "Relationship catalog does not "
                "contain schema_hash."
            )

        if not self.current_schema_hash:

            raise RelationshipValidationError(
                "Enriched schema does not "
                "contain schema_hash."
            )

        if (
            relationship_hash
            != self.current_schema_hash
        ):

            raise RelationshipValidationError(
                "Relationship catalog schema hash "
                "does not match the current enriched "
                "schema. Re-run relationship discovery."
            )

    # =====================================================
    # DATA TYPE FAMILY
    # =====================================================

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
                "VARCHAR",
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
                "MEDIUMINT",
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

        if "TIMESTAMP" in value:

            return "datetime"

        if "DATETIME" in value:

            return "datetime"

        if "DATE" in value:

            return "date"

        if "TIME" in value:

            return "time"

        if (
            "BOOLEAN" in value
            or "BOOL" in value
            or "BIT" in value
        ):

            return "boolean"

        return value

    # =====================================================
    # SAFE MYSQL IDENTIFIER
    # =====================================================

    @staticmethod
    def _quote_identifier(
        identifier: str,
    ) -> str:

        safe_identifier = (
            str(
                identifier
            ).replace(
                "`",
                "``",
            )
        )

        return (
            f"`{safe_identifier}`"
        )

    # =====================================================
    # DATABASE FK
    # =====================================================

    def _copy_database_relationship(
        self,
        relationship: Relationship,
    ) -> ValidatedRelationship:

        """
        MySQL FK is trusted.

        We still update provenance to record that
        the relationship passed through the current
        validation pipeline.

        No data scan is performed.
        """

        validated_at = (
            self._utc_now()
        )

        data = (
            relationship.model_dump()
        )

        provenance = (
            relationship
            .provenance
            .model_copy(
                deep=True
            )
        )

        provenance.schema_hash = (
            self.current_schema_hash
        )

        provenance.validated_at = (
            validated_at
        )

        data[
            "provenance"
        ] = (
            provenance.model_dump()
        )

        validation = (
            RelationshipValidation(

                tenant_scope_applied=(
                    relationship
                    .tenant_scope
                    .enabled
                ),

                observed_cardinality=(
                    RelationshipCardinality.UNKNOWN
                ),

                cardinality_compatible=None,

                validated_at=(
                    validated_at
                ),

                validation_note=(
                    "Relationship is backed by a "
                    "declared MySQL foreign key "
                    "constraint. Data-level scanning "
                    "was not required."
                ),
            )
        )

        return ValidatedRelationship(
            **data,
            validation=validation,
        )

    # =====================================================
    # BUILD FINAL RESULT
    # =====================================================

    def _build_result(
        self,
        relationship: Relationship,
        status: RelationshipStatus,
        validation: RelationshipValidation,
    ) -> ValidatedRelationship:

        data = (
            relationship.model_dump()
        )

        data[
            "status"
        ] = (
            status
        )

        # -------------------------------------------------
        # Update provenance
        # -------------------------------------------------

        provenance = (
            relationship
            .provenance
            .model_copy(
                deep=True
            )
        )

        provenance.schema_hash = (
            self.current_schema_hash
        )

        provenance.validated_at = (
            validation.validated_at
            or self._utc_now()
        )

        data[
            "provenance"
        ] = (
            provenance.model_dump()
        )

        # -------------------------------------------------
        # Automatically discovered relationship passed
        # data validation.
        #
        # discovered
        #     ↓
        # validated_inference
        # -------------------------------------------------

        if (
            status
            == RelationshipStatus.APPROVED

            and relationship.relationship_source
            == RelationshipSource.DISCOVERED
        ):

            data[
                "relationship_source"
            ] = (
                RelationshipSource.VALIDATED_INFERENCE
            )

            governance = (
                relationship
                .governance
                .model_copy(
                    deep=True
                )
            )

            governance.approved_by = (
                governance.approved_by
                or "relationship_validator"
            )

            governance.approved_at = (
                governance.approved_at
                or validation.validated_at
                or self._utc_now()
            )

            governance.approval_reason = (
                governance.approval_reason
                or validation.validation_note
            )

            data[
                "governance"
            ] = (
                governance.model_dump()
            )

        return ValidatedRelationship(
            **data,
            validation=validation,
        )

    # =====================================================
    # UTC TIME
    # =====================================================

    @staticmethod
    def _utc_now() -> datetime:

        return datetime.now(
            timezone.utc
        )