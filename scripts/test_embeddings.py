import json
import logging
from pathlib import Path

import numpy as np

from app.core.logging_config import (
    configure_logging,
)

from app.retrieval.embedding_service import (
    EmbeddingService,
)


logger = logging.getLogger(__name__)


SCHEMA_DOCUMENTS_PATH = Path(
    "data/schema_documents.json"
)


def main() -> None:

    configure_logging()

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

        catalog = json.load(
            file
        )

    documents = (
        catalog.get(
            "documents",
            [],
        )
    )

    if not documents:

        raise RuntimeError(
            "No schema documents found."
        )

    logger.info(
        "Schema documents loaded: %d",
        len(
            documents
        ),
    )

    # =====================================================
    # CREATE SERVICE
    # =====================================================

    service = (
        EmbeddingService()
    )

    service.load_model()

    logger.info(
        "Embedding dimension: %d",
        service.dimension,
    )

    # =====================================================
    # EMBED ALL DOCUMENTS
    # =====================================================

    texts = [
        document["text"]
        for document in documents
    ]

    embeddings = (
        service.embed_documents(
            texts
        )
    )

    logger.info(
        "Document embedding matrix: %s",
        embeddings.shape,
    )

    # =====================================================
    # TEST USER QUESTION
    # =====================================================

    query = (
        "last week vehicle wise revenue"
    )

    logger.info(
        "Test query: %s",
        query,
    )

    query_embedding = (
        service.embed_query(
            query
        )
    )

    logger.info(
        "Query embedding shape: %s",
        query_embedding.shape,
    )

    # =====================================================
    # TEMPORARY SIMILARITY TEST
    #
    # FAISS NOT USED YET.
    #
    # Because embeddings are normalized,
    # dot product behaves like cosine similarity.
    # =====================================================

    scores = (
        embeddings
        @ query_embedding
    )

    top_k = 10

    top_indices = (
        np.argsort(
            scores
        )[::-1][:top_k]
    )

    logger.info(
        "========== TOP SEMANTIC MATCHES =========="
    )

    for rank, index in enumerate(
        top_indices,
        start=1,
    ):

        document = (
            documents[
                int(index)
            ]
        )

        logger.info(
            "#%d | Score=%.4f | "
            "Type=%s | "
            "Table=%s | "
            "Column=%s | "
            "BusinessName=%s",
            rank,
            float(
                scores[
                    index
                ]
            ),
            document.get(
                "document_type"
            ),
            document.get(
                "table_name"
            ),
            document.get(
                "column_name"
            ),
            document.get(
                "business_name"
            ),
        )

    logger.info(
        "=========================================="
    )


if __name__ == "__main__":
    main()