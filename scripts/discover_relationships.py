import json
import logging
from pathlib import Path

from app.core.config import settings
from app.core.logging_config import configure_logging
from app.schema.relationships.relationship_discovery import (
    RelationshipDiscovery,
)


logger = logging.getLogger(__name__)


def load_json(path: Path) -> dict:
    """
    Load a JSON file and return it as a Python dictionary.
    """

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
    """
    Safely write JSON using a temporary file first.
    """

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

    enriched_schema_path = Path(
        settings.ENRICHED_SCHEMA_CATALOG_PATH
    )

    metadata_path = Path(
        settings.SCHEMA_METADATA_PATH
    )

    output_path = Path(
        settings.RELATIONSHIP_CANDIDATES_PATH
    )

    logger.info(
        "Starting relationship discovery"
    )

    try:

        # -----------------------------------------
        # Step 1:
        # Load enriched schema
        # -----------------------------------------

        logger.info(
            "Loading enriched schema catalog: %s",
            enriched_schema_path,
        )

        enriched_catalog = load_json(
            enriched_schema_path
        )

        # -----------------------------------------
        # Step 2:
        # Load manually maintained metadata
        # -----------------------------------------

        logger.info(
            "Loading schema metadata: %s",
            metadata_path,
        )

        metadata = load_json(
            metadata_path
        )

        # -----------------------------------------
        # Step 3:
        # Create discovery engine
        # -----------------------------------------

        discovery = RelationshipDiscovery(
            enriched_catalog=(
                enriched_catalog
            ),
            metadata=metadata,
        )

        # -----------------------------------------
        # Step 4:
        # Discover relationships
        # -----------------------------------------

        relationship_catalog = (
            discovery.discover()
        )

        # Pydantic model
        #      ↓
        # normal JSON-compatible dict
        output_data = (
            relationship_catalog.model_dump(
                mode="json"
            )
        )

        # -----------------------------------------
        # Step 5:
        # Save output
        # -----------------------------------------

        save_json(
            data=output_data,
            output_path=output_path,
        )

        logger.info(
            "Relationship discovery completed successfully"
        )

        logger.info(
            "Business tables processed: %d",
            relationship_catalog.business_table_count,
        )

        logger.info(
            "Declared DB relationships: %d",
            relationship_catalog.declared_relationship_count,
        )

        logger.info(
            "Candidate relationships: %d",
            relationship_catalog.candidate_relationship_count,
        )

        logger.info(
            "Total relationships: %d",
            len(
                relationship_catalog.relationships
            ),
        )

        logger.info(
            "Output file: %s",
            output_path,
        )

    except FileNotFoundError as exc:

        logger.error(
            "%s",
            exc,
        )

        raise SystemExit(1)

    except Exception:

        logger.exception(
            "Relationship discovery failed"
        )

        raise SystemExit(1)


if __name__ == "__main__":
    main()