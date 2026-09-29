import json
import logging
from pathlib import Path

from app.core.logging_config import (
    configure_logging,
)

from app.graph.schema_graph import (
    SchemaGraph,
)

from app.retrieval.embedding_service import (
    EmbeddingService,
)

from app.retrieval.graph_aware_retriever import (
    GraphAwareSchemaRetriever,
)

from app.retrieval.models import (
    SchemaDocumentCatalog,
)

from app.retrieval.schema_retriever import (
    HybridSchemaRetriever,
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
    # LOAD GRAPH
    # =====================================================

    logger.info(
        "Loading schema graph..."
    )

    graph = (
        SchemaGraph.from_settings()
    )

    # =====================================================
    # LOAD DOCUMENTS
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
    # TEMPORARY TEST EMBEDDINGS
    #
    # FAISS persistence comes next.
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
    # HYBRID RETRIEVER
    # =====================================================

    hybrid_retriever = (
        HybridSchemaRetriever(

            documents=(
                catalog.documents
            ),

            vector_store=(
                vector_store
            ),

            embedding_service=(
                embedding_service
            ),
        )
    )

    # =====================================================
    # GRAPH-AWARE RETRIEVER
    # =====================================================

    graph_retriever = (
        GraphAwareSchemaRetriever(

            hybrid_retriever=(
                hybrid_retriever
            ),

            graph=graph,
        )
    )

    # =====================================================
    # TEST QUERY
    # =====================================================

    # query = (
    #     "last week vehicle wise revenue"
    # )

    # response = (
    #     graph_retriever.search(

    #         query=query,

    #         top_k=10,

    #         candidate_k=50,
    #     )
    # )

    # # =====================================================
    # # OUTPUT
    # # =====================================================

    # logger.info(
    #     "=========================================="
    # )

    # logger.info(
    #     "Query: %s",
    #     response.query,
    # )

    # logger.info(
    #     "Terms: %s",
    #     response.normalized_terms,
    # )

    # logger.info(
    #     "Anchor Table: %s",
    #     response.anchor_table,
    # )

    # logger.info(
    #     "========== GRAPH-AWARE RESULTS ==========="
    # )

    # for result in response.results:

    #     logger.info(
    #         "#%d | "
    #         "Final=%.4f | "
    #         "Hybrid=%.4f | "
    #         "Graph=%.4f | "
    #         "Coherence=%.4f | "
    #         "Distance=%s | "
    #         "Table=%s | "
    #         "Column=%s | "
    #         "Matched=%s",
    #         result.rank,
    #         result.final_score,
    #         result.hybrid_score,
    #         result.graph_score,
    #         result.table_coherence_score,
    #         result.graph_distance,
    #         result.table_name,
    #         result.column_name,
    #         result.matched_terms,
    #     )

    # logger.info(
    #     "=========================================="
    # )
    


    test_queries = [
        "last week vehicle wise revenue",
        "customer wise trip revenue",
        "driver wise trip count",
        "show vehicle details",
        "customer mobile number",
        "trip profit",
        "fuel expenses",
        "vehicle maintenance details",
        "driver assigned vehicle",
        "trip invoice tax amount",
    ]

    for query in test_queries:

        response = graph_retriever.search(
            query=query,
            top_k=10,
            candidate_k=50,
        )

        logger.info(
            "\n\n=================================================="
        )

        logger.info(
            "Query: %s",
            response.query,
        )

        logger.info(
            "Terms: %s",
            response.normalized_terms,
        )

        logger.info(
            "Anchor Table: %s",
            response.anchor_table,
        )

        logger.info(
            "========== GRAPH-AWARE RESULTS ==========="
        )

        for result in response.results:

            logger.info(
                "#%d | "
                "Final=%.4f | "
                "Hybrid=%.4f | "
                "Graph=%.4f | "
                "Coherence=%.4f | "
                "Distance=%s | "
                "Table=%s | "
                "Column=%s | "
                "Matched=%s",
                result.rank,
                result.final_score,
                result.hybrid_score,
                result.graph_score,
                result.table_coherence_score,
                result.graph_distance,
                result.table_name,
                result.column_name,
                result.matched_terms,
            )

        logger.info(
            "=================================================="
        )


if __name__ == "__main__":
    main()