import logging
from typing import Any


logger = logging.getLogger(__name__)


class SchemaMetadataValidationError(Exception):
    pass


class SchemaMetadataValidator:

    def __init__(
        self,
        schema_catalog: dict[str, Any],
        metadata: dict[str, Any],
    ) -> None:
        self.schema_catalog = schema_catalog
        self.metadata = metadata

    def validate(self) -> None:
        """
        Validate manually maintained schema metadata
        against the actual database schema catalog.
        """

        logger.info("Validating schema metadata")

        errors: list[str] = []
        warnings: list[str] = []

        catalog_tables = {
            table["table_name"]: table
            for table in self.schema_catalog.get("tables", [])
        }

        table_overrides = self.metadata.get(
            "table_overrides",
            {},
        )

        global_rules = self.metadata.get(
            "global_column_rules",
            {},
        )

        # -----------------------------------------
        # Basic structure validation
        # -----------------------------------------

        if not isinstance(global_rules, dict):
            errors.append(
                "'global_column_rules' must be an object."
            )

        if not isinstance(table_overrides, dict):
            errors.append(
                "'table_overrides' must be an object."
            )

        # -----------------------------------------
        # Validate table overrides
        # -----------------------------------------

        for table_name, table_metadata in table_overrides.items():

            if table_name not in catalog_tables:
                errors.append(
                    f"Metadata contains unknown table: {table_name}"
                )
                continue

            actual_table = catalog_tables[table_name]

            actual_columns = {
                column["name"]
                for column in actual_table.get("columns", [])
            }

            column_overrides = table_metadata.get(
                "column_overrides",
                {},
            )

            if not isinstance(column_overrides, dict):
                errors.append(
                    f"{table_name}.column_overrides must be an object."
                )
                continue

            for column_name in column_overrides:

                if column_name not in actual_columns:
                    errors.append(
                        f"Unknown column "
                        f"'{table_name}.{column_name}' "
                        f"in schema metadata."
                    )

        # -----------------------------------------
        # Check whether global columns exist
        # -----------------------------------------

        all_column_names = {
            column["name"]
            for table in self.schema_catalog.get("tables", [])
            for column in table.get("columns", [])
        }

        for column_name in global_rules:

            if column_name not in all_column_names:
                warnings.append(
                    f"Global metadata column "
                    f"'{column_name}' was not found "
                    f"in the current schema."
                )

        for warning in warnings:
            logger.warning(warning)

        if errors:

            for error in errors:
                logger.error(error)

            raise SchemaMetadataValidationError(
                f"Schema metadata validation failed "
                f"with {len(errors)} error(s)."
            )

        logger.info(
            "Schema metadata validation successful"
        )