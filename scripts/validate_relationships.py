import json
import logging
from pathlib import Path

from app.core.config import settings
from app.core.database import engine
from app.core.logging_config import configure_logging

from app.schema.relationships.models import (
    RelationshipCatalog,
)

from app.schema.relationships.relationship_validator import (
    RelationshipValidationError,
    RelationshipValidator,
)


logger = logging.getLogger(__name__)


def load_json(path: Path) -> dict:
    """
    Load JSON file as Python dictionary.
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
    Safely save JSON using a temporary file.
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

    relationship_candidates_path = Path(
        settings.RELATIONSHIP_CANDIDATES_PATH
    )

    output_path = Path(
        settings.VALIDATED_RELATIONSHIPS_PATH
    )

    logger.info(
        "Starting relationship validation"
    )

    try:

        # -------------------------------------------------
        # Step 1:
        # Load enriched schema
        # -------------------------------------------------

        logger.info(
            "Loading enriched schema: %s",
            enriched_schema_path,
        )

        enriched_catalog = load_json(
            enriched_schema_path
        )

        # -------------------------------------------------
        # Step 2:
        # Load discovered relationships
        # -------------------------------------------------

        logger.info(
            "Loading relationship candidates: %s",
            relationship_candidates_path,
        )

        candidate_data = load_json(
            relationship_candidates_path
        )

        # -------------------------------------------------
        # Step 3:
        # Convert JSON dictionary
        # into Pydantic model
        # -------------------------------------------------

        relationship_catalog = (
            RelationshipCatalog.model_validate(
                candidate_data
            )
        )

        logger.info(
            "Relationships loaded: %d",
            len(
                relationship_catalog.relationships
            ),
        )

        # -------------------------------------------------
        # Step 4:
        # Create validator
        # -------------------------------------------------

        validator = RelationshipValidator(

            engine=engine,

            enriched_catalog=(
                enriched_catalog
            ),

            relationship_catalog=(
                relationship_catalog
            ),
        )

        # -------------------------------------------------
        # Step 5:
        # Validate relationships
        # -------------------------------------------------

        validated_catalog = (
            validator.validate()
        )

        # -------------------------------------------------
        # Step 6:
        # Convert Pydantic model to JSON-safe dict
        # -------------------------------------------------

        output_data = (
            validated_catalog.model_dump(
                mode="json"
            )
        )

        # -------------------------------------------------
        # Step 7:
        # Save validation result
        # -------------------------------------------------

        save_json(
            data=output_data,
            output_path=output_path,
        )

        # -------------------------------------------------
        # Summary
        # -------------------------------------------------

        logger.info(
            "Relationship validation completed successfully"
        )

        logger.info(
            "Approved relationships: %d",
            validated_catalog.approved_count,
        )

        logger.info(
            "Needs review: %d",
            validated_catalog.needs_review_count,
        )

        logger.info(
            "Rejected relationships: %d",
            validated_catalog.rejected_count,
        )

        logger.info(
            "Total relationships: %d",
            len(
                validated_catalog.relationships
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

    except RelationshipValidationError as exc:

        logger.error(
            "Relationship validation failed: %s",
            exc,
        )

        raise SystemExit(1)

    except Exception:

        logger.exception(
            "Unexpected relationship validation error"
        )

        raise SystemExit(1)

    finally:

        engine.dispose()


if __name__ == "__main__":
    main()