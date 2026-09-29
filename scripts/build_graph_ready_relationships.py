import json
import logging
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from app.core.config import settings
from app.core.logging_config import configure_logging


logger = logging.getLogger(__name__)


EXPECTED_RELATIONSHIP_SCHEMA_VERSION = "2.0"

ALLOWED_GRAPH_STATUSES = {
    "approved",
}


# =========================================================
# JSON HELPERS
# =========================================================


def load_json(
    path: Path,
) -> dict[str, Any]:
    """
    Load a required JSON file.
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
    data: dict[str, Any],
    output_path: Path,
) -> None:
    """
    Safely save JSON using temporary file first.

    This avoids partially written graph artifacts.
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
    Return current UTC timestamp.
    """

    return datetime.now(
        timezone.utc
    ).isoformat()


# =========================================================
# ARTIFACT VALIDATION
# =========================================================


def validate_artifacts(
    validated_data: dict[str, Any],
    review_data: dict[str, Any],
) -> None:
    """
    Ensure validated and human-review artifacts
    belong to the same enterprise relationship
    schema and same database schema version.
    """

    validated_version = (
        validated_data.get(
            "relationship_schema_version"
        )
    )

    review_version = (
        review_data.get(
            "relationship_schema_version"
        )
    )

    if (
        validated_version
        != EXPECTED_RELATIONSHIP_SCHEMA_VERSION
    ):

        raise ValueError(
            "validated_relationships.json uses "
            "an unsupported relationship schema "
            f"version: {validated_version!r}. "
            f"Expected "
            f"{EXPECTED_RELATIONSHIP_SCHEMA_VERSION}."
        )

    if (
        review_version
        != EXPECTED_RELATIONSHIP_SCHEMA_VERSION
    ):

        raise ValueError(
            "relationship_review.json uses "
            "an unsupported relationship schema "
            f"version: {review_version!r}. "
            f"Expected "
            f"{EXPECTED_RELATIONSHIP_SCHEMA_VERSION}."
        )

    validated_hash = (
        validated_data.get(
            "schema_hash"
        )
    )

    review_hash = (
        review_data.get(
            "schema_hash"
        )
    )

    if not validated_hash:

        raise ValueError(
            "validated_relationships.json "
            "does not contain schema_hash."
        )

    if not review_hash:

        raise ValueError(
            "relationship_review.json "
            "does not contain schema_hash."
        )

    if validated_hash != review_hash:

        raise ValueError(
            "Schema hash mismatch between "
            "validated relationships and "
            "relationship review. "
            "Re-run the relationship pipeline."
        )


# =========================================================
# COLUMN HELPERS
# =========================================================


def get_columns(
    relationship: dict[str, Any],
    plural_key: str,
    singular_key: str,
) -> list[str]:
    """
    Return enterprise multi-column representation.

    Backward compatibility is retained temporarily.
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
# RELATIONSHIP IDENTITY
# =========================================================


def relationship_key(
    relationship: dict[str, Any],
) -> tuple[
    str,
    tuple[str, ...],
    str,
    tuple[str, ...],
]:
    """
    Canonical relationship identity.

    Composite relationships are handled correctly.
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

    return (
        str(
            relationship.get(
                "source_table",
                "",
            )
        ),

        tuple(
            source_columns
        ),

        str(
            relationship.get(
                "target_table",
                "",
            )
        ),

        tuple(
            target_columns
        ),
    )


# =========================================================
# REVIEW LOOKUP
# =========================================================


def build_review_lookup(
    review_data: dict[str, Any],
) -> dict[str, dict[str, Any]]:
    """
    Build human-review lookup using relationship_id.

    relationship_id is the preferred enterprise key.
    """

    lookup: dict[
        str,
        dict[str, Any],
    ] = {}

    for relationship in (
        review_data.get(
            "relationships",
            [],
        )
    ):

        relationship_id = (
            relationship.get(
                "relationship_id"
            )
        )

        if not relationship_id:

            logger.warning(
                "Skipping review item without "
                "relationship_id: %s",
                relationship_key(
                    relationship
                ),
            )

            continue

        if relationship_id in lookup:

            raise ValueError(
                "Duplicate relationship_id found "
                "inside relationship_review.json: "
                f"{relationship_id}"
            )

        lookup[
            relationship_id
        ] = relationship

    return lookup


# =========================================================
# HUMAN APPROVAL MERGE
# =========================================================


def apply_human_approval(
    relationship: dict[str, Any],
    review_item: dict[str, Any],
) -> dict[str, Any]:
    """
    Convert a needs_review relationship into
    an approved graph-ready relationship after
    explicit human approval.

    Full validation/evidence history is retained.
    """

    approved = dict(
        relationship
    )

    approved[
        "status"
    ] = "approved"

    approved[
        "relationship_source"
    ] = "manual"

    # -----------------------------------------------------
    # Governance
    # -----------------------------------------------------

    governance = dict(
        approved.get(
            "governance",
            {}
        )
        or {}
    )

    reviewed_by = (
        review_item.get(
            "reviewed_by"
        )
        or "manual_review"
    )

    reviewed_at = (
        review_item.get(
            "reviewed_at"
        )
        or utc_now_iso()
    )

    review_reason = (
        review_item.get(
            "review_reason"
        )
        or (
            "Relationship manually approved "
            "during human review."
        )
    )

    notes = (
        review_item.get(
            "notes"
        )
    )

    governance[
        "approved_by"
    ] = reviewed_by

    governance[
        "approved_at"
    ] = reviewed_at

    governance[
        "approval_reason"
    ] = review_reason

    governance[
        "reviewed_by"
    ] = reviewed_by

    governance[
        "review_notes"
    ] = notes

    approved[
        "governance"
    ] = governance

    # -----------------------------------------------------
    # Preserve explicit review audit
    # -----------------------------------------------------

    approved[
        "manual_review"
    ] = {

        "decision": (
            review_item.get(
                "review_decision"
            )
        ),

        "reason": (
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

    return approved


# =========================================================
# RELATIONSHIP STRUCTURE VALIDATION
# =========================================================


def validate_graph_relationship(
    relationship: dict[str, Any],
) -> None:
    """
    Final validation before relationship enters
    runtime graph.
    """

    relationship_id = (
        relationship.get(
            "relationship_id"
        )
    )

    if not relationship_id:

        raise ValueError(
            "Graph-ready relationship does not "
            "contain relationship_id."
        )

    source_table = (
        relationship.get(
            "source_table"
        )
    )

    target_table = (
        relationship.get(
            "target_table"
        )
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

    if not source_table:

        raise ValueError(
            f"{relationship_id}: "
            "source_table is missing."
        )

    if not target_table:

        raise ValueError(
            f"{relationship_id}: "
            "target_table is missing."
        )

    if not source_columns:

        raise ValueError(
            f"{relationship_id}: "
            "source_columns are missing."
        )

    if not target_columns:

        raise ValueError(
            f"{relationship_id}: "
            "target_columns are missing."
        )

    if (
        len(source_columns)
        != len(target_columns)
    ):

        raise ValueError(
            f"{relationship_id}: "
            "source_columns and target_columns "
            "must have equal length."
        )

    status = (
        relationship.get(
            "status"
        )
    )

    if status not in ALLOWED_GRAPH_STATUSES:

        raise ValueError(
            f"{relationship_id}: "
            f"invalid graph status {status!r}."
        )

    if not relationship.get(
        "active",
        True,
    ):

        raise ValueError(
            f"{relationship_id}: "
            "inactive relationship cannot enter "
            "the runtime graph."
        )

    # -----------------------------------------------------
    # Tenant scope validation
    # -----------------------------------------------------

    tenant_scope = (
        relationship.get(
            "tenant_scope",
            {}
        )
        or {}
    )

    if tenant_scope.get(
        "enabled",
        False,
    ):

        tenant_source_columns = (
            tenant_scope.get(
                "source_columns",
                [],
            )
        )

        tenant_target_columns = (
            tenant_scope.get(
                "target_columns",
                [],
            )
        )

        if (
            not tenant_source_columns
            or not tenant_target_columns
        ):

            raise ValueError(
                f"{relationship_id}: tenant scope "
                "is enabled but tenant columns "
                "are missing."
            )

        if (
            len(
                tenant_source_columns
            )
            != len(
                tenant_target_columns
            )
        ):

            raise ValueError(
                f"{relationship_id}: tenant scope "
                "source/target column counts "
                "do not match."
            )


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

    output_path = Path(
        settings.GRAPH_READY_RELATIONSHIPS_PATH
    )

    logger.info(
        "Starting enterprise graph-ready "
        "relationship build"
    )

    try:

        # -------------------------------------------------
        # Step 1:
        # Load artifacts
        # -------------------------------------------------

        logger.info(
            "Loading validated relationships: %s",
            validated_path,
        )

        validated_data = load_json(
            validated_path
        )

        logger.info(
            "Loading relationship review: %s",
            review_path,
        )

        review_data = load_json(
            review_path
        )

        # -------------------------------------------------
        # Step 2:
        # Artifact compatibility checks
        # -------------------------------------------------

        validate_artifacts(
            validated_data=(
                validated_data
            ),
            review_data=(
                review_data
            ),
        )

        schema_hash = (
            validated_data[
                "schema_hash"
            ]
        )

        logger.info(
            "Relationship schema version: %s",
            EXPECTED_RELATIONSHIP_SCHEMA_VERSION,
        )

        logger.info(
            "Schema hash: %s",
            schema_hash,
        )

        # -------------------------------------------------
        # Step 3:
        # Human review lookup
        # -------------------------------------------------

        review_lookup = (
            build_review_lookup(
                review_data
            )
        )

        # -------------------------------------------------
        # Step 4:
        # Build graph-approved relationships
        # -------------------------------------------------

        graph_relationships: list[
            dict[str, Any]
        ] = []

        automatic_approved_count = 0

        human_approved_count = 0

        skipped_rejected_count = 0

        skipped_pending_count = 0

        reverse_relationship_count = 0

        inactive_count = 0

        for relationship in (
            validated_data.get(
                "relationships",
                [],
            )
        ):

            # ---------------------------------------------
            # Inactive relationships never enter graph
            # ---------------------------------------------

            if not relationship.get(
                "active",
                True,
            ):

                inactive_count += 1

                continue

            status = (
                relationship.get(
                    "status"
                )
            )

            relationship_id = (
                relationship.get(
                    "relationship_id"
                )
            )

            # ---------------------------------------------
            # Automatically / DB approved
            # ---------------------------------------------

            if status == "approved":

                validate_graph_relationship(
                    relationship
                )

                graph_relationships.append(
                    relationship
                )

                automatic_approved_count += 1

                continue

            # ---------------------------------------------
            # Explicit rejected relationship
            # ---------------------------------------------

            if status == "rejected":

                skipped_rejected_count += 1

                continue

            # ---------------------------------------------
            # Only needs_review can use human decision
            # ---------------------------------------------

            if status != "needs_review":

                logger.warning(
                    "Skipping relationship with "
                    "unsupported status: %s (%s)",
                    status,
                    relationship_id,
                )

                continue

            if not relationship_id:

                logger.warning(
                    "Skipping needs_review relationship "
                    "without relationship_id."
                )

                skipped_pending_count += 1

                continue

            review_item = (
                review_lookup.get(
                    relationship_id
                )
            )

            if not review_item:

                logger.warning(
                    "No human review record found "
                    "for relationship: %s",
                    relationship_id,
                )

                skipped_pending_count += 1

                continue

            decision = (
                review_item.get(
                    "review_decision",
                    "pending",
                )
            )

            # ---------------------------------------------
            # Human approved
            # ---------------------------------------------

            if decision == "approved":

                approved_relationship = (
                    apply_human_approval(
                        relationship=(
                            relationship
                        ),
                        review_item=(
                            review_item
                        ),
                    )
                )

                validate_graph_relationship(
                    approved_relationship
                )

                graph_relationships.append(
                    approved_relationship
                )

                human_approved_count += 1

                continue

            # ---------------------------------------------
            # Human rejected
            # ---------------------------------------------

            if decision == "rejected":

                skipped_rejected_count += 1

                continue

            # ---------------------------------------------
            # Reverse relationships
            #
            # Important enterprise rule:
            # We do NOT automatically reverse and approve.
            #
            # A reversed relationship changes:
            # - source/target
            # - cardinality
            # - validation meaning
            # - tenant direction
            #
            # Therefore it must go back through
            # metadata/discovery/validation.
            # ---------------------------------------------

            if (
                decision
                == "reverse_relationship"
            ):

                reverse_relationship_count += 1

                logger.warning(
                    "Relationship marked for reversal "
                    "will NOT enter runtime graph: %s. "
                    "Define the corrected direction "
                    "in metadata and re-run discovery/"
                    "validation.",
                    relationship_id,
                )

                continue

            # ---------------------------------------------
            # Pending
            # ---------------------------------------------

            skipped_pending_count += 1

        # -------------------------------------------------
        # Step 5:
        # Deduplicate by relationship_id and relationship key
        # -------------------------------------------------

        final_relationships: list[
            dict[str, Any]
        ] = []

        seen_ids: set[str] = set()

        seen_keys: set[
            tuple[
                str,
                tuple[str, ...],
                str,
                tuple[str, ...],
            ]
        ] = set()

        for relationship in graph_relationships:

            relationship_id = str(
                relationship[
                    "relationship_id"
                ]
            )

            key = relationship_key(
                relationship
            )

            if relationship_id in seen_ids:

                logger.warning(
                    "Duplicate relationship_id "
                    "removed: %s",
                    relationship_id,
                )

                continue

            if key in seen_keys:

                logger.warning(
                    "Duplicate relationship path "
                    "removed: %s",
                    key,
                )

                continue

            seen_ids.add(
                relationship_id
            )

            seen_keys.add(
                key
            )

            final_relationships.append(
                relationship
            )

        # -------------------------------------------------
        # Step 6:
        # Sort for deterministic output
        # -------------------------------------------------

        final_relationships.sort(
            key=lambda relationship: (
                str(
                    relationship.get(
                        "source_table",
                        "",
                    )
                ),

                tuple(
                    get_columns(
                        relationship,
                        "source_columns",
                        "source_column",
                    )
                ),

                str(
                    relationship.get(
                        "target_table",
                        "",
                    )
                ),

                tuple(
                    get_columns(
                        relationship,
                        "target_columns",
                        "target_column",
                    )
                ),
            )
        )

        # -------------------------------------------------
        # Step 7:
        # Graph-ready artifact
        # -------------------------------------------------

        output_data = {

            "relationship_schema_version": (
                EXPECTED_RELATIONSHIP_SCHEMA_VERSION
            ),

            "schema_hash": (
                schema_hash
            ),

            "generated_at": (
                utc_now_iso()
            ),

            "relationship_count": len(
                final_relationships
            ),

            "summary": {

                "automatic_approved": (
                    automatic_approved_count
                ),

                "human_approved": (
                    human_approved_count
                ),

                "skipped_rejected": (
                    skipped_rejected_count
                ),

                "skipped_pending": (
                    skipped_pending_count
                ),

                "reverse_relationships": (
                    reverse_relationship_count
                ),

                "inactive_relationships": (
                    inactive_count
                ),
            },

            "relationships": (
                final_relationships
            ),
        }

        # -------------------------------------------------
        # Step 8:
        # Save graph-ready artifact
        # -------------------------------------------------

        save_json(
            data=output_data,
            output_path=output_path,
        )

        logger.info(
            "Enterprise graph-ready relationship "
            "build completed"
        )

        logger.info(
            "Automatic approved relationships: %d",
            automatic_approved_count,
        )

        logger.info(
            "Human-approved relationships: %d",
            human_approved_count,
        )

        logger.info(
            "Graph-ready relationships: %d",
            len(
                final_relationships
            ),
        )

        logger.info(
            "Rejected relationships skipped: %d",
            skipped_rejected_count,
        )

        logger.info(
            "Pending relationships skipped: %d",
            skipped_pending_count,
        )

        logger.info(
            "Reverse relationships requiring "
            "rebuild: %d",
            reverse_relationship_count,
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

    except ValueError as exc:

        logger.error(
            "Graph-ready relationship build "
            "failed: %s",
            exc,
        )

        raise SystemExit(1)

    except Exception:

        logger.exception(
            "Unexpected graph-ready relationship "
            "build error"
        )

        raise SystemExit(1)


if __name__ == "__main__":
    main()