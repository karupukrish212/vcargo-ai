import logging
from pathlib import Path

from app.core.config import settings
from app.core.database import engine
from app.core.logging_config import configure_logging
from app.schema.exceptions import SchemaExtractionError
from app.schema.schema_reader import MySQLSchemaReader


logger = logging.getLogger(__name__)


def save_catalog(
    catalog,
    output_path: Path,
) -> None:

    output_path.parent.mkdir(
        parents=True,
        exist_ok=True,
    )

    temporary_path = Path(
        f"{output_path}.tmp"
    )

    json_content = catalog.model_dump_json(
        indent=2
    )

    temporary_path.write_text(
        json_content,
        encoding="utf-8",
    )

    temporary_path.replace(
        output_path
    )


def main() -> None:

    configure_logging()

    output_path = Path(
        settings.SCHEMA_CATALOG_PATH
    )

    logger.info(
        "Starting schema export"
    )

    try:

        reader = MySQLSchemaReader(

            engine=engine,

            database_name=settings.DB_NAME,
        )

        catalog = reader.build_catalog()

        save_catalog(
            catalog,
            output_path,
        )

        logger.info(
            "Schema catalog successfully created"
        )

        logger.info(
            "Tables discovered: %d",
            catalog.table_count,
        )

        logger.info(
            "Output path: %s",
            output_path,
        )

    except SchemaExtractionError as exc:

        logger.error(
            "Schema export failed: %s",
            exc,
        )

        raise SystemExit(1)

    finally:

        engine.dispose()


if __name__ == "__main__":
    main()