import json
import logging
from pathlib import Path

from app.core.config import (
    get_settings,
)

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

    settings = get_settings()

    # =====================================================
    # LOAD SCHEMA DOCUMENTS
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
        "Schema documents loaded. "
        "Documents=%d SchemaHash=%s",
        catalog.total_document_count,
        catalog.schema_hash,
    )

    # =====================================================
    # LOAD EMBEDDING MODEL
    # =====================================================

    embedding_service = (
        EmbeddingService()
    )

    embedding_service.load_model()

    # =====================================================
    # EMBED DOCUMENTS
    #
    # IMPORTANT:
    # This happens ONLY when rebuilding the index.
    # =====================================================

    document_texts = [
        document.text
        for document
        in catalog.documents
    ]

    embeddings = (
        embedding_service
        .embed_documents(
            document_texts
        )
    )

    # =====================================================
    # BUILD FAISS
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

    vector_store.build(

        catalog=catalog,

        embeddings=embeddings,

        embedding_model_name=(
            settings
            .EMBEDDING_MODEL_NAME
        ),

        normalize_embeddings=(
            settings
            .EMBEDDING_NORMALIZE
        ),
    )

    vector_store.save()

    logger.info(
        "========================================"
    )

    logger.info(
        "FAISS Build Completed"
    )

    logger.info(
        "Documents: %d",
        catalog.total_document_count,
    )

    logger.info(
        "Embedding Dimension: %d",
        embeddings.shape[1],
    )

    logger.info(
        "Index: %s",
        FAISS_INDEX_PATH,
    )

    logger.info(
        "Metadata: %s",
        FAISS_METADATA_PATH,
    )

    logger.info(
        "========================================"
    )


if __name__ == "__main__":
    main()