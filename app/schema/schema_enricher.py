import copy
import hashlib
import json
import logging
from datetime import datetime, timezone
from typing import Any


logger = logging.getLogger(__name__)


class SchemaEnricher:

    def __init__(
        self,
        schema_catalog: dict[str, Any],
        metadata: dict[str, Any],
    ) -> None:

        self.schema_catalog = schema_catalog
        self.metadata = metadata

    def enrich(self) -> dict[str, Any]:

        logger.info("Starting schema enrichment")

        enriched_catalog = copy.deepcopy(
            self.schema_catalog
        )

        global_rules = self.metadata.get(
            "global_column_rules",
            {},
        )

        table_overrides = self.metadata.get(
            "table_overrides",
            {},
        )

        enriched_tables = []

        for table in enriched_catalog.get(
            "tables",
            [],
        ):

            table_name = table["table_name"]

            table_metadata = table_overrides.get(
                table_name,
                {},
            )

            enriched_table = self._enrich_table(
                table=table,
                table_metadata=table_metadata,
                global_rules=global_rules,
            )

            enriched_tables.append(
                enriched_table
            )

        enriched_catalog["tables"] = enriched_tables

        enriched_catalog["enrichment"] = {
            "metadata_version": self.metadata.get(
                "metadata_version",
                "1.0",
            ),
            "generated_at": datetime.now(
                timezone.utc
            ).isoformat(),
        }

        enriched_catalog[
            "source_schema_hash"
        ] = self.schema_catalog.get(
            "schema_hash"
        )

        enriched_catalog[
            "enriched_schema_hash"
        ] = self._generate_hash(
            enriched_tables
        )

        logger.info(
            "Schema enrichment completed"
        )

        return enriched_catalog

    def _enrich_table(
        self,
        table: dict[str, Any],
        table_metadata: dict[str, Any],
        global_rules: dict[str, Any],
    ) -> dict[str, Any]:

        table_name = table["table_name"]

        column_overrides = table_metadata.get(
            "column_overrides",
            {},
        )

        table["ai_metadata"] = {
            "business_name": table_metadata.get(
                "business_name",
                table_name,
            ),
            "domain": table_metadata.get(
                "domain"
            ),
            "description": table_metadata.get(
                "description"
            ),
            "synonyms": table_metadata.get(
                "synonyms",
                [],
            ),
            "retrieval_enabled": table_metadata.get(
                "retrieval_enabled",
                True,
            ),
        }

        enriched_columns = []

        for column in table.get(
            "columns",
            [],
        ):

            column_name = column["name"]

            # Global metadata
            global_metadata = global_rules.get(
                column_name,
                {},
            )

            # Table-specific metadata
            specific_metadata = column_overrides.get(
                column_name,
                {},
            )

            # Specific metadata takes priority
            merged_metadata = {
                **global_metadata,
                **specific_metadata,
            }

            column["ai_metadata"] = (
                merged_metadata
            )

            enriched_columns.append(
                column
            )

        table["columns"] = enriched_columns

        return table

    @staticmethod
    def _generate_hash(
        tables: list[dict[str, Any]],
    ) -> str:

        normalized = json.dumps(
            tables,
            sort_keys=True,
            ensure_ascii=False,
            default=str,
        )

        return hashlib.sha256(
            normalized.encode("utf-8")
        ).hexdigest()