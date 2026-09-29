import logging
from pathlib import Path

from app.core.logging_config import (
    configure_logging,
)

from app.graph.schema_graph import (
    SchemaGraph,
)

from app.retrieval.models import (
    SchemaDocumentType,
)

from app.retrieval.schema_document_builder import (
    SchemaDocumentBuilder,
)


logger = logging.getLogger(__name__)


def main() -> None:

    configure_logging()

    logger.info(
        "Loading schema graph..."
    )

    graph = (
        SchemaGraph.from_settings()
    )

    logger.info(
        "Building schema documents..."
    )

    builder = (
        SchemaDocumentBuilder(
            graph
        )
    )

    catalog = (
        builder.build_catalog()
    )

    output_path = Path(
        "data/schema_documents.json"
    )

    builder.export_catalog(
        catalog=catalog,
        output_path=output_path,
    )

    logger.info(
        "=================================="
    )

    logger.info(
        "Schema Document Build Completed"
    )

    logger.info(
        "Schema Hash: %s",
        catalog.schema_hash,
    )

    logger.info(
        "Table Documents: %d",
        catalog.table_document_count,
    )

    logger.info(
        "Column Documents: %d",
        catalog.column_document_count,
    )

    logger.info(
        "Total Documents: %d",
        catalog.total_document_count,
    )

    logger.info(
        "Output: %s",
        output_path,
    )

    logger.info(
        "=================================="
    )

    # -----------------------------------------------------
    # TEST: trip table document
    # -----------------------------------------------------

    trip_document = next(
        (
            document

            for document
            in catalog.documents

            if (
                document.document_type
                == SchemaDocumentType.TABLE

                and document.table_name
                == "trip"
            )
        ),
        None,
    )

    if trip_document:

        logger.info(
            "\n========== SAMPLE TABLE DOCUMENT ==========\n%s",
            trip_document.text,
        )

    # -----------------------------------------------------
    # TEST: trip.revenue column
    # -----------------------------------------------------

    revenue_document = next(
        (
            document

            for document
            in catalog.documents

            if (
                document.document_type
                == SchemaDocumentType.COLUMN

                and document.table_name
                == "trip"

                and document.column_name
                == "revenue"
            )
        ),
        None,
    )

    if revenue_document:

        logger.info(
            "\n========== SAMPLE COLUMN DOCUMENT ==========\n%s",
            revenue_document.text,
        )


if __name__ == "__main__":
    main()