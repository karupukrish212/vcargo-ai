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


EXPECTED_RELATIONSHIP_SCHEMA_VERSION = "2.0"


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


def validate_relationship_artifact(
    candidate_data: dict,
) -> None:
    """
    Validate relationship candidate artifact
    before passing it to the validator.
    """

    version = candidate_data.get(
        "relationship_schema_version"
    )

    if version != EXPECTED_RELATIONSHIP_SCHEMA_VERSION:

        raise RelationshipValidationError(
            "Unsupported relationship schema version. "
            f"Expected "
            f"{EXPECTED_RELATIONSHIP_SCHEMA_VERSION}, "
            f"received {version!r}. "
            "Re-run relationship discovery."
        )

    schema_hash = candidate_data.get(
        "schema_hash"
    )

    if not schema_hash:

        raise RelationshipValidationError(
            "Relationship candidate file does not "
            "contain schema_hash. "
            "Re-run relationship discovery."
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
        "Starting enterprise relationship validation"
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
        # Load relationship candidates
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
        # Validate artifact version
        # -------------------------------------------------

        validate_relationship_artifact(
            candidate_data
        )

        logger.info(
            "Relationship schema version: %s",
            candidate_data.get(
                "relationship_schema_version"
            ),
        )

        logger.info(
            "Relationship schema hash: %s",
            candidate_data.get(
                "schema_hash"
            ),
        )

        # -------------------------------------------------
        # Step 4:
        # Convert JSON -> Pydantic model
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
        # Step 5:
        # Create enterprise validator
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
        # Step 6:
        # Validate
        # -------------------------------------------------

        validated_catalog = (
            validator.validate()
        )

        # -------------------------------------------------
        # Step 7:
        # Convert Pydantic -> JSON-safe dict
        # -------------------------------------------------

        output_data = (
            validated_catalog.model_dump(
                mode="json"
            )
        )

        # -------------------------------------------------
        # Step 8:
        # Save validated relationship catalog
        # -------------------------------------------------

        save_json(
            data=output_data,
            output_path=output_path,
        )

        # -------------------------------------------------
        # Summary
        # -------------------------------------------------

        logger.info(
            "Enterprise relationship validation "
            "completed successfully"
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