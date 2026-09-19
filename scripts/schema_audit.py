import json
import logging
from pathlib import Path
from typing import Any

from app.core.config import settings
from app.core.logging_config import configure_logging


logger = logging.getLogger(__name__)


DATE_COLUMN_KEYWORDS = {
    "date",
    "createdon",
    "modifiedon",
    "createdat",
    "updatedat",
    "createddate",
    "modifieddate",
    "fromdate",
    "todate",
}


def load_schema_catalog(
    catalog_path: Path,
) -> dict[str, Any]:

    if not catalog_path.exists():

        raise FileNotFoundError(
            f"Schema catalog not found: {catalog_path}"
        )

    with catalog_path.open(
        "r",
        encoding="utf-8",
    ) as file:

        return json.load(file)


def is_id_like_column(
    column_name: str,
) -> bool:

    name = column_name.lower().strip()

    return (
        name == "id"
        or name.endswith("id")
        or name.endswith("_id")
    )


def is_date_like_column(
    column_name: str,
) -> bool:

    name = (
        column_name
        .lower()
        .replace("_", "")
        .strip()
    )

    if name in DATE_COLUMN_KEYWORDS:
        return True

    return (
        name.endswith("date")
        or name.endswith("datetime")
        or name.endswith("time")
    )


def audit_schema(
    catalog: dict[str, Any],
) -> dict[str, Any]:

    tables = catalog.get(
        "tables",
        [],
    )

    tables_without_foreign_keys = []

    tables_without_comments = []

    id_like_columns = []

    suspicious_date_columns = []

    total_columns = 0

    for table in tables:

        table_name = table["table_name"]

        columns = table.get(
            "columns",
            [],
        )

        total_columns += len(columns)

        # ----------------------------------------
        # Missing table comments
        # ----------------------------------------

        if not table.get("comment"):

            tables_without_comments.append(
                table_name
            )

        # ----------------------------------------
        # Missing FK
        # ----------------------------------------

        foreign_keys = table.get(
            "foreign_keys",
            [],
        )

        if not foreign_keys:

            tables_without_foreign_keys.append(
                table_name
            )

        # ----------------------------------------
        # Column analysis
        # ----------------------------------------

        primary_key_columns = set(
            table
            .get("primary_key", {})
            .get("columns", [])
        )

        foreign_key_columns = set()

        for fk in foreign_keys:

            for column in fk.get(
                "columns",
                [],
            ):

                foreign_key_columns.add(
                    column
                )

        for column in columns:

            column_name = column["name"]

            data_type = (
                column
                .get("data_type", "")
                .upper()
            )

            # ------------------------------------
            # ID-like columns
            # ------------------------------------

            if is_id_like_column(
                column_name
            ):

                id_like_columns.append(
                    {
                        "table": table_name,
                        "column": column_name,
                        "data_type": data_type,
                        "is_primary_key": (
                            column_name
                            in primary_key_columns
                        ),
                        "is_declared_foreign_key": (
                            column_name
                            in foreign_key_columns
                        ),
                    }
                )

            # ------------------------------------
            # Suspicious date columns
            # ------------------------------------

            if (
                is_date_like_column(
                    column_name
                )
                and
                (
                    "CHAR" in data_type
                    or "TEXT" in data_type
                )
            ):

                suspicious_date_columns.append(
                    {
                        "table": table_name,
                        "column": column_name,
                        "physical_type": data_type,
                        "issue": (
                            "Date-like column stored "
                            "as text"
                        ),
                    }
                )

    return {
        "database": catalog.get(
            "database"
        ),

        "schema_hash": catalog.get(
            "schema_hash"
        ),

        "summary": {
            "total_tables": len(tables),
            "total_columns": total_columns,

            "tables_without_comments": len(
                tables_without_comments
            ),

            "tables_without_foreign_keys": len(
                tables_without_foreign_keys
            ),

            "id_like_columns": len(
                id_like_columns
            ),

            "suspicious_date_columns": len(
                suspicious_date_columns
            ),
        },

        "tables_without_comments": (
            tables_without_comments
        ),

        "tables_without_foreign_keys": (
            tables_without_foreign_keys
        ),

        "id_like_columns": (
            id_like_columns
        ),

        "suspicious_date_columns": (
            suspicious_date_columns
        ),
    }


def save_audit_report(
    audit: dict[str, Any],
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
            audit,
            file,
            indent=2,
            ensure_ascii=False,
        )

    temporary_path.replace(
        output_path
    )


def main() -> None:

    configure_logging()

    catalog_path = Path(
        settings.SCHEMA_CATALOG_PATH
    )

    audit_path = Path(
        "data/schema_audit.json"
    )

    logger.info(
        "Starting schema audit"
    )

    try:

        catalog = load_schema_catalog(
            catalog_path
        )

        audit = audit_schema(
            catalog
        )

        save_audit_report(
            audit,
            audit_path,
        )

        summary = audit["summary"]

        logger.info(
            "Schema audit completed"
        )

        logger.info(
            "Total tables: %d",
            summary["total_tables"],
        )

        logger.info(
            "Total columns: %d",
            summary["total_columns"],
        )

        logger.info(
            "Tables without foreign keys: %d",
            summary[
                "tables_without_foreign_keys"
            ],
        )

        logger.info(
            "Tables without comments: %d",
            summary[
                "tables_without_comments"
            ],
        )

        logger.info(
            "ID-like columns: %d",
            summary[
                "id_like_columns"
            ],
        )

        logger.info(
            "Suspicious date columns: %d",
            summary[
                "suspicious_date_columns"
            ],
        )

        logger.info(
            "Audit report: %s",
            audit_path,
        )

    except Exception:

        logger.exception(
            "Schema audit failed"
        )

        raise SystemExit(1)


if __name__ == "__main__":
    main()