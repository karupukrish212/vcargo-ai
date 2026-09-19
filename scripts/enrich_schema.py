import json
import logging
from pathlib import Path

from app.core.config import settings
from app.core.logging_config import configure_logging
from app.schema.metadata_validator import (
    SchemaMetadataValidationError,
    SchemaMetadataValidator,
)
from app.schema.schema_enricher import SchemaEnricher


logger = logging.getLogger(__name__)


def load_json(path: Path) -> dict:

    if not path.exists():
        raise FileNotFoundError(
            f"Required file not found: {path}"
        )

    with path.open(
        "r",
        encoding="utf-8",
    ) as file:

        return json.load(file)


def save_json(
    data: dict,
    output_path: Path,
) -> None:

    output_path.parent.mkdir(
        parents=True,
        exist_ok=True,
    )

    temporary_path = Path(
        f"{output_path}.tmp"
    )

    with temporary_path.open(
        "w",
        encoding="utf-8",
    ) as file:

        json.dump(
            data,
            file,
            indent=2,
            ensure_ascii=False,
        )

    temporary_path.replace(
        output_path
    )


def main() -> None:

    configure_logging()

    schema_path = Path(
        settings.SCHEMA_CATALOG_PATH
    )

    metadata_path = Path(
        settings.SCHEMA_METADATA_PATH
    )

    output_path = Path(
        settings.ENRICHED_SCHEMA_CATALOG_PATH
    )

    logger.info(
        "Loading schema catalog"
    )

    try:

        schema_catalog = load_json(
            schema_path
        )

        metadata = load_json(
            metadata_path
        )

        # -----------------------------------------
        # Step 1: Validate metadata
        # -----------------------------------------

        validator = SchemaMetadataValidator(
            schema_catalog=schema_catalog,
            metadata=metadata,
        )

        validator.validate()

        # -----------------------------------------
        # Step 2: Enrich schema
        # -----------------------------------------

        enricher = SchemaEnricher(
            schema_catalog=schema_catalog,
            metadata=metadata,
        )

        enriched_catalog = (
            enricher.enrich()
        )

        # -----------------------------------------
        # Step 3: Save final catalog
        # -----------------------------------------

        save_json(
            enriched_catalog,
            output_path,
        )

        logger.info(
            "Enriched schema catalog created: %s",
            output_path,
        )

        logger.info(
            "Tables processed: %d",
            enriched_catalog[
                "table_count"
            ],
        )

        logger.info(
            "Enriched schema hash: %s",
            enriched_catalog[
                "enriched_schema_hash"
            ],
        )

    except SchemaMetadataValidationError as exc:

        logger.error(
            "Metadata validation failed: %s",
            exc,
        )

        raise SystemExit(1)

    except Exception:

        logger.exception(
            "Schema enrichment failed"
        )

        raise SystemExit(1)


if __name__ == "__main__":
    main()