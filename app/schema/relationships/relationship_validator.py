import logging
from typing import Any

from sqlalchemy import text
from sqlalchemy.engine import Engine
from sqlalchemy.exc import SQLAlchemyError

from app.schema.relationships.models import (
    Relationship,
    RelationshipCatalog,
    RelationshipSource,
    RelationshipStatus,
    RelationshipValidation,
    ValidatedRelationship,
    ValidatedRelationshipCatalog,
)


logger = logging.getLogger(__name__)


class RelationshipValidationError(Exception):
    """
    Raised when relationship validation fails.
    """

    pass


class RelationshipValidator:
    """
    Validates discovered relationships using actual
    MySQL data.

    Important:
    - Executes only SELECT queries
    - Existing database foreign keys remain approved
    - Candidate relationships are validated using:
        1. Source distinct values
        2. Target distinct values
        3. Value overlap
        4. Target duplicates
        5. Source null ratio
    """

    APPROVE_OVERLAP_THRESHOLD = 0.95
    REVIEW_OVERLAP_THRESHOLD = 0.70

    MIN_DISTINCT_VALUES_FOR_AUTO_APPROVAL = 5

    def __init__(
        self,
        engine: Engine,
        enriched_catalog: dict[str, Any],
        relationship_catalog: RelationshipCatalog,
    ) -> None:

        self.engine = engine
        self.enriched_catalog = enriched_catalog

        self.relationship_catalog = (
            relationship_catalog
        )

        self.tables = self._build_table_lookup()

    # --------------------------------------------------
    # MAIN METHOD
    # --------------------------------------------------

    def validate(
        self,
    ) -> ValidatedRelationshipCatalog:

        logger.info(
            "Starting relationship validation"
        )

        validated_relationships: list[
            ValidatedRelationship
        ] = []

        for relationship in (
            self.relationship_catalog.relationships
        ):

            # ------------------------------------------
            # Existing MySQL foreign keys are trusted
            # ------------------------------------------

            if (
                relationship.relationship_source
                == RelationshipSource.DATABASE
                and relationship.status
                == RelationshipStatus.APPROVED
            ):

                validated_relationships.append(
                    self._copy_without_validation(
                        relationship
                    )
                )

                continue

            # ------------------------------------------
            # Validate candidate/manual relationships
            # ------------------------------------------

            validated = (
                self._validate_relationship(
                    relationship
                )
            )

            validated_relationships.append(
                validated
            )

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

            approved_count=approved_count,

            needs_review_count=(
                needs_review_count
            ),

            rejected_count=rejected_count,

            relationships=(
                validated_relationships
            ),
        )

    # --------------------------------------------------
    # VALIDATE ONE RELATIONSHIP
    # --------------------------------------------------

    def _validate_relationship(
        self,
        relationship: Relationship,
    ) -> ValidatedRelationship:

        logger.info(
            "Validating relationship: %s.%s -> %s.%s",
            relationship.source_table,
            relationship.source_column,
            relationship.target_table,
            relationship.target_column,
        )

        try:

            self._validate_schema_objects(
                relationship
            )

            source_column = (
                self._get_column(
                    relationship.source_table,
                    relationship.source_column,
                )
            )

            target_column = (
                self._get_column(
                    relationship.target_table,
                    relationship.target_column,
                )
            )

            source_family = (
                self._type_family(
                    source_column.get(
                        "data_type",
                        "",
                    )
                )
            )

            target_family = (
                self._type_family(
                    target_column.get(
                        "data_type",
                        "",
                    )
                )
            )

            # Schema-level incompatible datatype
            if source_family != target_family:

                return self._build_result(
                    relationship=relationship,

                    status=(
                        RelationshipStatus.REJECTED
                    ),

                    validation=(
                        RelationshipValidation(
                            validation_note=(
                                "Source and target "
                                "column data types are "
                                "not compatible."
                            )
                        )
                    ),
                )

            # ------------------------------------------
            # Collect actual data statistics
            # ------------------------------------------

            source_stats = self._get_source_stats(
                table_name=(
                    relationship.source_table
                ),
                column_name=(
                    relationship.source_column
                ),
                type_family=source_family,
            )

            target_stats = self._get_target_stats(
                table_name=(
                    relationship.target_table
                ),
                column_name=(
                    relationship.target_column
                ),
                type_family=target_family,
            )

            matched_values = (
                self._get_matched_distinct_count(
                    relationship=relationship,
                    type_family=source_family,
                )
            )

            source_distinct = source_stats[
                "distinct_values"
            ]

            unmatched_values = max(
                source_distinct
                - matched_values,
                0,
            )

            if source_distinct > 0:

                overlap_ratio = (
                    matched_values
                    / source_distinct
                )

            else:

                overlap_ratio = 0.0

            total_rows = source_stats[
                "total_rows"
            ]

            non_null_rows = source_stats[
                "non_null_rows"
            ]

            if total_rows > 0:

                source_null_ratio = (
                    (
                        total_rows
                        - non_null_rows
                    )
                    / total_rows
                )

            else:

                source_null_ratio = 0.0

            target_distinct_values = target_stats[
                            "distinct_values"
                        ]
            
            duplicate_groups = target_stats[
                "duplicate_groups"
            ]

            if target_distinct_values == 0:
                target_unique = None
            else:
                target_unique = (
                    duplicate_groups == 0
                )

            validation = (
                RelationshipValidation(

                    source_total_rows=(
                        total_rows
                    ),

                    source_non_null_rows=(
                        non_null_rows
                    ),

                    source_distinct_values=(
                        source_distinct
                    ),

                    target_distinct_values=(
                        target_distinct_values
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

                    target_duplicate_groups=(
                        duplicate_groups
                    ),

                    target_unique=(
                        target_unique
                    ),
                )
            )

            status, note = (
                self._decide_status(
                    source_distinct=(
                        source_distinct
                    ),
                    overlap_ratio=(
                        overlap_ratio
                    ),
                    target_unique=(
                        target_unique
                    ),
                )
            )

            validation.validation_note = note

            return self._build_result(

                relationship=relationship,

                status=status,

                validation=validation,
            )

        except SQLAlchemyError as exc:

            logger.exception(
                "Database validation failed for "
                "%s.%s -> %s.%s",
                relationship.source_table,
                relationship.source_column,
                relationship.target_table,
                relationship.target_column,
            )

            raise RelationshipValidationError(
                "Relationship validation query failed."
            ) from exc

    # --------------------------------------------------
    # STATUS DECISION
    # --------------------------------------------------

    def _decide_status(
        self,
        source_distinct: int,
        overlap_ratio: float,
        target_unique: bool | None,
    ) -> tuple[
        RelationshipStatus,
        str,
    ]:

        # ------------------------------------------
        # No usable source data
        # ------------------------------------------

        if source_distinct == 0:

            return (
                RelationshipStatus.NEEDS_REVIEW,
                (
                    "Source column has no non-null "
                    "distinct values. Relationship "
                    "cannot be validated using data."
                ),
            )
        if target_unique is None:

            return (
                RelationshipStatus.NEEDS_REVIEW,
                (
                    "Target column has no non-null "
                    "distinct values. Relationship "
                    "cannot be validated using data."
                ),
            )

        # ------------------------------------------
        # Too little data for automatic approval
        # ------------------------------------------

        if (
            source_distinct
            < self.MIN_DISTINCT_VALUES_FOR_AUTO_APPROVAL
        ):

            return (
                RelationshipStatus.NEEDS_REVIEW,
                (
                    "Relationship has too few "
                    "distinct source values for "
                    "automatic approval."
                ),
            )

        # ------------------------------------------
        # Strong relationship
        # ------------------------------------------

        if (
            overlap_ratio
            >= self.APPROVE_OVERLAP_THRESHOLD
            and target_unique
        ):

            return (
                RelationshipStatus.APPROVED,
                (
                    "High value overlap and unique "
                    "target values."
                ),
            )

        # ------------------------------------------
        # Good overlap but target duplicates
        # ------------------------------------------

        if (
            overlap_ratio
            >= self.APPROVE_OVERLAP_THRESHOLD
            and not target_unique
        ):

            return (
                RelationshipStatus.NEEDS_REVIEW,
                (
                    "High value overlap found, "
                    "but target column contains "
                    "duplicate values."
                ),
            )

        # ------------------------------------------
        # Medium quality relationship
        # ------------------------------------------

        if (
            overlap_ratio
            >= self.REVIEW_OVERLAP_THRESHOLD
        ):

            return (
                RelationshipStatus.NEEDS_REVIEW,
                (
                    "Moderate value overlap. "
                    "Manual review is recommended."
                ),
            )

        # ------------------------------------------
        # Weak relationship
        # ------------------------------------------

        return (
            RelationshipStatus.REJECTED,
            (
                "Value overlap is below the "
                "minimum validation threshold."
            ),
        )

    # --------------------------------------------------
    # SOURCE STATISTICS
    # --------------------------------------------------

    def _get_source_stats(
        self,
        table_name: str,
        column_name: str,
        type_family: str,
    ) -> dict[str, int]:

        table = self._quote_identifier(
            table_name
        )

        expression = (
            self._normalized_expression(
                alias="s",
                column_name=column_name,
                type_family=type_family,
            )
        )

        query = text(
            f"""
            SELECT
                COUNT(*) AS total_rows,

                COUNT(
                    {expression}
                ) AS non_null_rows,

                COUNT(
                    DISTINCT {expression}
                ) AS distinct_values

            FROM {table} AS s
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

        return {
            "total_rows": int(
                row["total_rows"] or 0
            ),

            "non_null_rows": int(
                row["non_null_rows"] or 0
            ),

            "distinct_values": int(
                row["distinct_values"] or 0
            ),
        }

    # --------------------------------------------------
    # TARGET STATISTICS
    # --------------------------------------------------

    def _get_target_stats(
        self,
        table_name: str,
        column_name: str,
        type_family: str,
    ) -> dict[str, int]:

        table = self._quote_identifier(
            table_name
        )

        expression = (
            self._normalized_expression(
                alias="t",
                column_name=column_name,
                type_family=type_family,
            )
        )

        distinct_query = text(
            f"""
            SELECT
                COUNT(
                    DISTINCT {expression}
                ) AS distinct_values

            FROM {table} AS t
            """
        )

        duplicate_query = text(
            f"""
            SELECT COUNT(*) AS duplicate_groups

            FROM (
                SELECT
                    {expression} AS normalized_value

                FROM {table} AS t

                WHERE
                    {expression} IS NOT NULL

                GROUP BY
                    {expression}

                HAVING COUNT(*) > 1
            ) AS duplicates
            """
        )

        with self.engine.connect() as connection:

            distinct_row = (
                connection.execute(
                    distinct_query
                )
                .mappings()
                .one()
            )

            duplicate_row = (
                connection.execute(
                    duplicate_query
                )
                .mappings()
                .one()
            )

        return {
            "distinct_values": int(
                distinct_row[
                    "distinct_values"
                ]
                or 0
            ),

            "duplicate_groups": int(
                duplicate_row[
                    "duplicate_groups"
                ]
                or 0
            ),
        }

    # --------------------------------------------------
    # VALUE OVERLAP
    # --------------------------------------------------

    def _get_matched_distinct_count(
        self,
        relationship: Relationship,
        type_family: str,
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

        source_expression = (
            self._normalized_expression(
                alias="s",
                column_name=(
                    relationship.source_column
                ),
                type_family=type_family,
            )
        )

        target_expression = (
            self._normalized_expression(
                alias="t",
                column_name=(
                    relationship.target_column
                ),
                type_family=type_family,
            )
        )

        query = text(
            f"""
            SELECT COUNT(*) AS matched_values

            FROM (
                SELECT DISTINCT
                    {source_expression}
                    AS normalized_value

                FROM {source_table} AS s

                INNER JOIN {target_table} AS t
                    ON
                    {source_expression}
                    =
                    {target_expression}

                WHERE
                    {source_expression}
                    IS NOT NULL
            ) AS matches
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
            row["matched_values"] or 0
        )

    # --------------------------------------------------
    # NORMALIZED SQL EXPRESSION
    # --------------------------------------------------

    def _normalized_expression(
        self,
        alias: str,
        column_name: str,
        type_family: str,
    ) -> str:

        column = self._quote_identifier(
            column_name
        )

        reference = (
            f"{alias}.{column}"
        )

        # For text relationships:
        #
        # " KA01 "
        # "ka01"
        # "KA01"
        #
        # are considered equal during validation.

        if type_family == "string":

            return (
                f"NULLIF("
                f"LOWER(TRIM({reference})), "
                f"''"
                f")"
            )

        return reference

    # --------------------------------------------------
    # TABLE/COLUMN LOOKUP
    # --------------------------------------------------

    def _build_table_lookup(
        self,
    ) -> dict[str, dict[str, Any]]:

        return {
            table["table_name"]: table

            for table
            in self.enriched_catalog.get(
                "tables",
                [],
            )
        }

    def _get_column(
        self,
        table_name: str,
        column_name: str,
    ) -> dict[str, Any]:

        table = self.tables.get(
            table_name
        )

        if not table:

            raise RelationshipValidationError(
                f"Unknown table: {table_name}"
            )

        for column in table.get(
            "columns",
            [],
        ):

            if (
                column.get("name")
                == column_name
            ):

                return column

        raise RelationshipValidationError(
            f"Unknown column: "
            f"{table_name}.{column_name}"
        )

    def _validate_schema_objects(
        self,
        relationship: Relationship,
    ) -> None:

        self._get_column(
            relationship.source_table,
            relationship.source_column,
        )

        self._get_column(
            relationship.target_table,
            relationship.target_column,
        )

    # --------------------------------------------------
    # DATATYPE FAMILY
    # --------------------------------------------------

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

        if "DATETIME" in value:
            return "datetime"

        if "DATE" in value:
            return "date"

        if "TIME" in value:
            return "time"

        if "BIT" in value:
            return "boolean"

        return value

    # --------------------------------------------------
    # IDENTIFIER SAFETY
    # --------------------------------------------------

    @staticmethod
    def _quote_identifier(
        identifier: str,
    ) -> str:
        """
        Quote MySQL identifier.

        Table/column names are already validated
        against enriched_schema_catalog before use.
        """

        safe_identifier = (
            identifier.replace(
                "`",
                "``",
            )
        )

        return f"`{safe_identifier}`"

    # --------------------------------------------------
    # RESULT BUILDERS
    # --------------------------------------------------

    @staticmethod
    def _copy_without_validation(
        relationship: Relationship,
    ) -> ValidatedRelationship:

        return ValidatedRelationship(
            **relationship.model_dump(),
            validation=None,
        )

    @staticmethod
    def _build_result(
        relationship: Relationship,
        status: RelationshipStatus,
        validation: RelationshipValidation,
    ) -> ValidatedRelationship:

        data = relationship.model_dump()

        data["status"] = status

        # Once discovered inference is actually
        # validated successfully, update source.

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

        return ValidatedRelationship(
            **data,
            validation=validation,
        )