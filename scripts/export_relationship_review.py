import json
import logging
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from app.core.config import settings
from app.core.logging_config import configure_logging


logger = logging.getLogger(__name__)


EXPECTED_RELATIONSHIP_SCHEMA_VERSION = "2.0"

ALLOWED_REVIEW_DECISIONS = [
    "approved",
    "rejected",
    "reverse_relationship",
    "pending",
]


# =========================================================
# JSON HELPERS
# =========================================================


def load_json(
    path: Path,
) -> dict[str, Any]:
    """
    Load required JSON file.
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


def load_optional_json(
    path: Path,
) -> dict[str, Any] | None:
    """
    Load JSON only when file exists.

    Used to preserve previous human review decisions.
    """

    if not path.exists():
        return None

    with path.open(
        "r",
        encoding="utf-8",
    ) as file:

        return json.load(file)


def save_json(
    data: dict[str, Any],
    output_path: Path,
) -> None:
    """
    Safely write JSON using a temporary file.

    Prevents partially written/corrupted output.
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


# =========================================================
# TIME
# =========================================================


def utc_now_iso() -> str:
    """
    Return current UTC time in ISO format.
    """

    return datetime.now(
        timezone.utc
    ).isoformat()


# =========================================================
# ARTIFACT VALIDATION
# =========================================================


def validate_validated_artifact(
    validated_data: dict[str, Any],
) -> None:
    """
    Ensure validated_relationships.json belongs
    to the enterprise relationship schema.
    """

    version = validated_data.get(
        "relationship_schema_version"
    )

    if (
        version
        != EXPECTED_RELATIONSHIP_SCHEMA_VERSION
    ):

        raise ValueError(
            "Unsupported relationship schema version. "
            f"Expected "
            f"{EXPECTED_RELATIONSHIP_SCHEMA_VERSION}, "
            f"received {version!r}. "
            "Re-run relationship discovery and validation."
        )

    schema_hash = validated_data.get(
        "schema_hash"
    )

    if not schema_hash:

        raise ValueError(
            "validated_relationships.json "
            "does not contain schema_hash."
        )


# =========================================================
# COLUMN FORMAT HELPERS
# =========================================================


def get_columns(
    relationship: dict[str, Any],
    plural_key: str,
    singular_key: str,
) -> list[str]:
    """
    Enterprise format:

        source_columns
        target_columns

    Also supports older single-column format:

        source_column
        target_column
    """

    values = relationship.get(
        plural_key
    )

    if values:

        return list(
            values
        )

    value = relationship.get(
        singular_key
    )

    if value:

        return [
            value
        ]

    return []


# =========================================================
# REVIEW IDENTITY
# =========================================================


def relationship_review_key(
    relationship: dict[str, Any],
) -> str:
    """
    relationship_id is the preferred enterprise key.

    Legacy fallback exists so older review decisions
    can still be preserved during migration.
    """

    relationship_id = relationship.get(
        "relationship_id"
    )

    if relationship_id:

        return str(
            relationship_id
        )

    source_columns = get_columns(
        relationship=relationship,
        plural_key="source_columns",
        singular_key="source_column",
    )

    target_columns = get_columns(
        relationship=relationship,
        plural_key="target_columns",
        singular_key="target_column",
    )

    return "|".join(
        [
            str(
                relationship.get(
                    "source_table",
                    "",
                )
            ),

            ",".join(
                source_columns
            ),

            str(
                relationship.get(
                    "target_table",
                    "",
                )
            ),

            ",".join(
                target_columns
            ),
        ]
    )


# =========================================================
# EXISTING REVIEW LOOKUP
# =========================================================


def build_existing_review_lookup(
    existing_review_data: (
        dict[str, Any]
        | None
    ),
    current_schema_hash: str,
) -> dict[str, dict[str, Any]]:
    """
    Preserve existing human decisions ONLY when
    they belong to the same schema version/hash.

    If database schema changed, old approvals
    should not be silently reused.
    """

    if not existing_review_data:

        return {}

    existing_schema_hash = (
        existing_review_data.get(
            "schema_hash"
        )
    )

    if (
        existing_schema_hash
        != current_schema_hash
    ):

        logger.warning(
            "Existing relationship review belongs "
            "to a different schema hash. "
            "Previous review decisions will NOT "
            "be reused."
        )

        return {}

    lookup: dict[
        str,
        dict[str, Any],
    ] = {}

    for relationship in (
        existing_review_data.get(
            "relationships",
            [],
        )
    ):

        key = relationship_review_key(
            relationship
        )

        lookup[
            key
        ] = relationship

    return lookup


# =========================================================
# REVIEW ITEM BUILDER
# =========================================================


def build_review_item(
    relationship: dict[str, Any],
    previous_review: (
        dict[str, Any]
        | None
    ),
) -> dict[str, Any]:
    """
    Build one human-review record.

    Enterprise relationship information is
    preserved so reviewers have full context.
    """

    source_columns = get_columns(
        relationship=relationship,
        plural_key="source_columns",
        singular_key="source_column",
    )

    target_columns = get_columns(
        relationship=relationship,
        plural_key="target_columns",
        singular_key="target_column",
    )

    # -----------------------------------------------------
    # Previous human review fields
    # -----------------------------------------------------

    review_decision = "pending"
    review_reason = ""
    reviewed_by = ""
    reviewed_at = None
    notes = ""

    if previous_review:

        review_decision = (
            previous_review.get(
                "review_decision",
                "pending",
            )
        )

        if (
            review_decision
            not in ALLOWED_REVIEW_DECISIONS
        ):

            review_decision = "pending"

        review_reason = (
            previous_review.get(
                "review_reason",
                "",
            )
        )

        reviewed_by = (
            previous_review.get(
                "reviewed_by",
                "",
            )
        )

        reviewed_at = (
            previous_review.get(
                "reviewed_at"
            )
        )

        notes = (
            previous_review.get(
                "notes",
                "",
            )
        )

    # -----------------------------------------------------
    # Enterprise review record
    # -----------------------------------------------------

    return {

        "relationship_id": (
            relationship.get(
                "relationship_id"
            )
        ),

        "source_table": (
            relationship.get(
                "source_table"
            )
        ),

        "source_columns": (
            source_columns
        ),

        "target_table": (
            relationship.get(
                "target_table"
            )
        ),

        "target_columns": (
            target_columns
        ),

        "relationship_type": (
            relationship.get(
                "relationship_type"
            )
        ),

        "relationship_source": (
            relationship.get(
                "relationship_source"
            )
        ),

        "cardinality": (
            relationship.get(
                "cardinality"
            )
        ),

        "join_operator": (
            relationship.get(
                "join_operator",
                "=",
            )
        ),

        "confidence_score": (
            relationship.get(
                "confidence_score",
                0.0,
            )
        ),

        "active": (
            relationship.get(
                "active",
                True,
            )
        ),

        "description": (
            relationship.get(
                "description"
            )
        ),

        "evidence": (
            relationship.get(
                "evidence",
                [],
            )
        ),

        "normalization": (
            relationship.get(
                "normalization",
                {}
            )
        ),

        "tenant_scope": (
            relationship.get(
                "tenant_scope",
                {}
            )
        ),

        "governance": (
            relationship.get(
                "governance",
                {}
            )
        ),

        "provenance": (
            relationship.get(
                "provenance",
                {}
            )
        ),

        "validation": (
            relationship.get(
                "validation"
            )
        ),

        # -------------------------------------------------
        # Human review fields
        # -------------------------------------------------

        "review_decision": (
            review_decision
        ),

        "review_reason": (
            review_reason
        ),

        "reviewed_by": (
            reviewed_by
        ),

        "reviewed_at": (
            reviewed_at
        ),

        "notes": (
            notes
        ),
    }


# =========================================================
# MAIN
# =========================================================


def main() -> None:

    configure_logging()

    validated_path = Path(
        settings.VALIDATED_RELATIONSHIPS_PATH
    )

    review_path = Path(
        settings.RELATIONSHIP_REVIEW_PATH
    )

    logger.info(
        "Starting enterprise relationship review export"
    )

    try:

        # -------------------------------------------------
        # Step 1:
        # Load validated relationships
        # -------------------------------------------------

        logger.info(
            "Loading validated relationships: %s",
            validated_path,
        )

        validated_data = load_json(
            validated_path
        )

        validate_validated_artifact(
            validated_data
        )

        current_schema_hash = (
            validated_data[
                "schema_hash"
            ]
        )

        logger.info(
            "Relationship schema version: %s",
            validated_data.get(
                "relationship_schema_version"
            ),
        )

        logger.info(
            "Schema hash: %s",
            current_schema_hash,
        )

        # -------------------------------------------------
        # Step 2:
        # Load previous review file if available
        #
        # Important:
        # This prevents accidental loss of manual
        # approval/rejection decisions.
        # -------------------------------------------------

        existing_review_data = (
            load_optional_json(
                review_path
            )
        )

        existing_review_lookup = (
            build_existing_review_lookup(
                existing_review_data=(
                    existing_review_data
                ),
                current_schema_hash=(
                    current_schema_hash
                ),
            )
        )

        # -------------------------------------------------
        # Step 3:
        # Filter relationships requiring human review
        # -------------------------------------------------

        review_items: list[
            dict[str, Any]
        ] = []

        preserved_decision_count = 0

        for relationship in (
            validated_data.get(
                "relationships",
                [],
            )
        ):

            if (
                relationship.get(
                    "status"
                )
                != "needs_review"
            ):

                continue

            # Disabled relationship should not
            # enter human review/runtime graph.

            if not relationship.get(
                "active",
                True,
            ):

                continue

            key = (
                relationship_review_key(
                    relationship
                )
            )

            previous_review = (
                existing_review_lookup.get(
                    key
                )
            )

            if (
                previous_review
                and previous_review.get(
                    "review_decision"
                )
                not in (
                    None,
                    "",
                    "pending",
                )
            ):

                preserved_decision_count += 1

            review_item = (
                build_review_item(
                    relationship=(
                        relationship
                    ),
                    previous_review=(
                        previous_review
                    ),
                )
            )

            review_items.append(
                review_item
            )

        # -------------------------------------------------
        # Step 4:
        # Build review artifact
        # -------------------------------------------------

        output_data = {

            "relationship_schema_version": (
                EXPECTED_RELATIONSHIP_SCHEMA_VERSION
            ),

            "schema_hash": (
                current_schema_hash
            ),

            "generated_at": (
                utc_now_iso()
            ),

            "review_count": len(
                review_items
            ),

            "preserved_review_decision_count": (
                preserved_decision_count
            ),

            "allowed_decisions": (
                ALLOWED_REVIEW_DECISIONS
            ),

            "relationships": (
                review_items
            ),
        }

        # -------------------------------------------------
        # Step 5:
        # Save
        # -------------------------------------------------

        save_json(
            data=output_data,
            output_path=review_path,
        )

        logger.info(
            "Enterprise relationship review "
            "export completed"
        )

        logger.info(
            "Relationships requiring review: %d",
            len(
                review_items
            ),
        )

        logger.info(
            "Previous human decisions preserved: %d",
            preserved_decision_count,
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

    except ValueError as exc:

        logger.error(
            "Relationship review export failed: %s",
            exc,
        )

        raise SystemExit(1)

    except Exception:

        logger.exception(
            "Unexpected relationship review "
            "export error"
        )

        raise SystemExit(1)


if __name__ == "__main__":
    main()