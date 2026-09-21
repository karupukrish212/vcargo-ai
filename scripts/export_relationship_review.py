import json
import logging
from pathlib import Path

from app.core.config import settings
from app.core.logging_config import configure_logging


logger = logging.getLogger(__name__)


def load_json(path: Path) -> dict:
    """
    Load JSON file.
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
    Safely save JSON using temporary file.
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

    validated_path = Path(
        settings.VALIDATED_RELATIONSHIPS_PATH
    )

    review_path = Path(
        settings.RELATIONSHIP_REVIEW_PATH
    )

    logger.info(
        "Starting relationship review export"
    )

    try:

        # -----------------------------------------
        # Step 1:
        # Load validated relationships
        # -----------------------------------------

        validated_data = load_json(
            validated_path
        )

        relationships = (
            validated_data.get(
                "relationships",
                [],
            )
        )

        # -----------------------------------------
        # Step 2:
        # Filter needs_review relationships
        # -----------------------------------------

        needs_review = []

        for relationship in relationships:

            if (
                relationship.get("status")
                != "needs_review"
            ):
                continue

            review_item = {
                "source_table": relationship.get(
                    "source_table"
                ),

                "source_column": relationship.get(
                    "source_column"
                ),

                "target_table": relationship.get(
                    "target_table"
                ),

                "target_column": relationship.get(
                    "target_column"
                ),

                "relationship_type": relationship.get(
                    "relationship_type"
                ),

                "relationship_source": relationship.get(
                    "relationship_source"
                ),

                "confidence_score": relationship.get(
                    "confidence_score"
                ),

                "validation": relationship.get(
                    "validation"
                ),

                # ---------------------------------
                # Human review fields
                # ---------------------------------

                "review_decision": "pending",

                "review_reason": "",

                "reviewed_by": "",

                "notes": "",
            }

            needs_review.append(
                review_item
            )

        # -----------------------------------------
        # Step 3:
        # Create review catalog
        # -----------------------------------------

        output_data = {

            "schema_hash": (
                validated_data.get(
                    "schema_hash"
                )
            ),

            "review_count": len(
                needs_review
            ),

            "allowed_decisions": [
                "approved",
                "rejected",
                "reverse_relationship",
                "pending",
            ],

            "relationships": (
                needs_review
            ),
        }

        # -----------------------------------------
        # Step 4:
        # Save file
        # -----------------------------------------

        save_json(
            data=output_data,
            output_path=review_path,
        )

        logger.info(
            "Relationship review export completed"
        )

        logger.info(
            "Relationships requiring review: %d",
            len(needs_review),
        )

        logger.info(
            "Output file: %s",
            review_path,
        )

    except FileNotFoundError as exc:

        logger.error(
            "%s",
            exc,
        )

        raise SystemExit(1)

    except Exception:

        logger.exception(
            "Relationship review export failed"
        )

        raise SystemExit(1)


if __name__ == "__main__":
    main()