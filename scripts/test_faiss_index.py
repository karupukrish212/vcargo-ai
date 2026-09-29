import json
import logging
from pathlib import Path

from app.core.logging_config import (
    configure_logging,
)

from app.retrieval.embedding_service import (
    EmbeddingService,
)

from app.retrieval.models import (
    SchemaDocumentCatalog,
)

from app.retrieval.vector_store import (
    FaissSchemaVectorStore,
)


logger = logging.getLogger(__name__)


SCHEMA_DOCUMENTS_PATH = Path(
    "data/schema_documents.json"
)

FAISS_INDEX_PATH = Path(
    "data/schema_index.faiss"
)

FAISS_METADATA_PATH = Path(
    "data/schema_index_metadata.json"
)


def main() -> None:

    configure_logging()

    # =====================================================
    # LOAD DOCUMENT CATALOG
    # =====================================================

    with SCHEMA_DOCUMENTS_PATH.open(
        "r",
        encoding="utf-8",
    ) as file:

        payload = json.load(
            file
        )

    catalog = (
        SchemaDocumentCatalog
        .model_validate(
            payload
        )
    )

    # Fast lookup:
    # document_id -> document
    document_map = {
        document.document_id: document
        for document
        in catalog.documents
    }

    # =====================================================
    # LOAD EXISTING FAISS INDEX
    #
    # Notice:
    # We are NOT embedding 474 docs here.
    # =====================================================

    vector_store = (
        FaissSchemaVectorStore(

            index_path=(
                FAISS_INDEX_PATH
            ),

            metadata_path=(
                FAISS_METADATA_PATH
            ),
        )
    )

    vector_store.load(
        expected_catalog=catalog
    )

    # =====================================================
    # LOAD EMBEDDING MODEL
    # =====================================================

    embedding_service = (
        EmbeddingService()
    )

    embedding_service.load_model()

    # =====================================================
    # TEST QUERIES
    # =====================================================

    test_queries = [
        "last week vehicle wise revenue",
        "customer mobile number",
        "trip invoice tax amount",
    ]

    for query in test_queries:

        # ---------------------------------------------
        # ONLY query is embedded at runtime
        # ---------------------------------------------

        query_embedding = (
            embedding_service
            .embed_query(
                query
            )
        )

        hits = (
            vector_store.search(
                query_embedding=(
                    query_embedding
                ),
                top_k=10,
            )
        )

        logger.info(
            ""
        )

        logger.info(
            "========================================"
        )

        logger.info(
            "Query: %s",
            query,
        )

        logger.info(
            "========== FAISS RESULTS ================"
        )

        for hit in hits:

            document = (
                document_map[
                    hit.document_id
                ]
            )

            logger.info(
                "#%d | "
                "Score=%.4f | "
                "Type=%s | "
                "Table=%s | "
                "Column=%s",
                hit.rank,
                hit.score,
                document.document_type.value,
                document.table_name,
                document.column_name,
            )

        logger.info(
            "========================================"
        )


if __name__ == "__main__":
    main()