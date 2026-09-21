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


def relationship_key(
    relationship: dict,
) -> tuple[str, str, str, str]:
    """
    Create a unique key for one relationship.
    """

    return (
        relationship.get(
            "source_table",
            "",
        ),
        relationship.get(
            "source_column",
            "",
        ),
        relationship.get(
            "target_table",
            "",
        ),
        relationship.get(
            "target_column",
            "",
        ),
    )


def main() -> None:

    configure_logging()

    validated_path = Path(
        settings.VALIDATED_RELATIONSHIPS_PATH
    )

    review_path = Path(
        settings.RELATIONSHIP_REVIEW_PATH
    )

    output_path = Path(
        settings.GRAPH_READY_RELATIONSHIPS_PATH
    )

    logger.info(
        "Starting graph-ready relationship build"
    )

    try:

        # -----------------------------------------
        # Step 1:
        # Load validated relationships
        # -----------------------------------------

        validated_data = load_json(
            validated_path
        )

        validated_relationships = (
            validated_data.get(
                "relationships",
                [],
            )
        )

        # -----------------------------------------
        # Step 2:
        # Load human review decisions
        # -----------------------------------------

        review_data = load_json(
            review_path
        )

        review_relationships = (
            review_data.get(
                "relationships",
                [],
            )
        )

        # -----------------------------------------
        # Step 3:
        # Build lookup for human decisions
        # -----------------------------------------

        review_lookup = {}

        for relationship in review_relationships:

            key = relationship_key(
                relationship
            )

            review_lookup[key] = (
                relationship
            )

        # -----------------------------------------
        # Step 4:
        # Collect graph-safe relationships
        # -----------------------------------------

        graph_relationships = []

        for relationship in validated_relationships:

            key = relationship_key(
                relationship
            )

            status = relationship.get(
                "status"
            )

            # -------------------------------------
            # Already approved automatically
            # -------------------------------------

            if status == "approved":

                graph_relationships.append(
                    relationship
                )

                continue

            # -------------------------------------
            # Needs-review relationships
            # must have human approval
            # -------------------------------------

            if status != "needs_review":
                continue

            review_item = review_lookup.get(
                key
            )

            if not review_item:
                continue

            decision = review_item.get(
                "review_decision",
                "pending",
            )

            if decision != "approved":
                continue

            approved_relationship = (
                relationship.copy()
            )

            approved_relationship[
                "status"
            ] = "approved"

            approved_relationship[
                "relationship_source"
            ] = "manual"

            approved_relationship[
                "manual_review"
            ] = {
                "decision": (
                    review_item.get(
                        "review_decision"
                    )
                ),
                "reason": (
                    review_item.get(
                        "review_reason"
                    )
                ),
                "reviewed_by": (
                    review_item.get(
                        "reviewed_by"
                    )
                ),
                "notes": (
                    review_item.get(
                        "notes"
                    )
                ),
            }

            graph_relationships.append(
                approved_relationship
            )

        # -----------------------------------------
        # Step 5:
        # Remove duplicates
        # -----------------------------------------

        unique_relationships = {}

        for relationship in graph_relationships:

            key = relationship_key(
                relationship
            )

            unique_relationships[
                key
            ] = relationship

        final_relationships = list(
            unique_relationships.values()
        )

        # -----------------------------------------
        # Step 6:
        # Create final graph catalog
        # -----------------------------------------

        output_data = {

            "schema_hash": (
                validated_data.get(
                    "schema_hash"
                )
            ),

            "relationship_count": len(
                final_relationships
            ),

            "relationships": (
                final_relationships
            ),
        }

        # -----------------------------------------
        # Step 7:
        # Save
        # -----------------------------------------

        save_json(
            data=output_data,
            output_path=output_path,
        )

        logger.info(
            "Graph-ready relationship build completed"
        )

        logger.info(
            "Graph-ready relationships: %d",
            len(final_relationships),
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
            "Graph-ready relationship build failed"
        )

        raise SystemExit(1)


if __name__ == "__main__":
    main()