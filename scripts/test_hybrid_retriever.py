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

from app.retrieval.schema_retriever import (
    HybridSchemaRetriever,
)


logger = logging.getLogger(__name__)


SCHEMA_DOCUMENTS_PATH = Path(
    "data/schema_documents.json"
)


def main() -> None:

    configure_logging()

    # =====================================================
    # LOAD DOCUMENT CATALOG
    # =====================================================

    logger.info(
        "Loading schema documents..."
    )

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

    logger.info(
        "Documents loaded: %d",
        catalog.total_document_count,
    )

    # =====================================================
    # EMBEDDING SERVICE
    # =====================================================

    embedding_service = (
        EmbeddingService()
    )

    embedding_service.load_model()

    # =====================================================
    # TEMPORARY:
    #
    # Embed documents again for testing.
    #
    # Later FAISS will persist these vectors,
    # so runtime will NOT repeat this work.
    # =====================================================

    document_texts = [
        document.text
        for document
        in catalog.documents
    ]

    document_embeddings = (
        embedding_service
        .embed_documents(
            document_texts
        )
    )

    # =====================================================
    # HYBRID RETRIEVER
    # =====================================================

    retriever = (
        HybridSchemaRetriever(

            documents=(
                catalog.documents
            ),

            document_embeddings=(
                document_embeddings
            ),

            embedding_service=(
                embedding_service
            ),
        )
    )

    # =====================================================
    # TEST QUERY
    # =====================================================

    query = (
        "last week vehicle wise revenue"
    )

    response = (
        retriever.search(
            query=query,
            top_k=10,
        )
    )

    logger.info(
        "=========================================="
    )

    logger.info(
        "Query: %s",
        response.query,
    )

    logger.info(
        "Schema Terms: %s",
        response.normalized_terms,
    )

    logger.info(
        "========== HYBRID RESULTS ================"
    )

    for result in response.results:

        logger.info(
            "#%d | Final=%.4f | "
            "Semantic=%.4f | "
            "Lexical=%.4f | "
            "Type=%s | "
            "Table=%s | "
            "Column=%s | "
            "Matched=%s",
            result.rank,
            result.final_score,
            result.semantic_score,
            result.lexical_score,
            result.document_type.value,
            result.table_name,
            result.column_name,
            result.matched_terms,
        )

    logger.info(
        "=========================================="
    )


if __name__ == "__main__":
    main()