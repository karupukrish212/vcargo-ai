import json
import logging
from pathlib import Path
from app.agents.sql.prompt_builder import SQLPromptBuilder
from app.agents.sql.sql_generator import (
    SQLGenerator,
)
import asyncio
from app.agents.sql.sql_validator import (
    SQLValidator,
)


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

from app.retrieval.context_builder import (
    GraphRAGContextBuilder,
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

async def main() -> None:

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

    trip_table = (
        graph.get_table(
            "trip"
        )
    )

    raw_columns = getattr(
        trip_table,
        "columns",
        (),
    )

    if isinstance(
        raw_columns,
        dict,
    ):
        raw_columns = list(
            raw_columns.values()
        )

    tripstart_column = next(
        (
            column
            for column in raw_columns
            if (
                getattr(
                    column,
                    "name",
                    None,
                )
                or getattr(
                    column,
                    "column_name",
                    None,
                )
            )
            == "tripstarttime"
        ),
        None,
    )

    print(
        "\n========== TRIPSTARTTIME METADATA =========="
    )

    if tripstart_column is None:

        print(
            "tripstarttime column not found"
        )

    else:

        if hasattr(
            tripstart_column,
            "model_dump",
        ):

            print(
                tripstart_column.model_dump()
            )

        else:

            print(
                vars(
                    tripstart_column
                )
            )

    print(
        "============================================"
    )

    # =====================================================
    # LOAD DOCUMENTS
    # =====================================================

    # Temporary Code
    # tdriver_table = (
    #      graph.get_table(
    #         "tdriver"
    #     )
    # )

    # raw_columns = getattr(
    #     tdriver_table,
    #     "columns",
    #     (),
    # )

    # if isinstance(
    #     raw_columns,
    #     dict,
    # ):
    #     raw_columns = (
    #         raw_columns.values()
    #     )

    # print(
    #     "\n========== TDRIVER COLUMNS =========="
    # )

    trip_table = (
        graph.get_table(
            "trip"
        )
    )

    trip_columns = getattr(
        trip_table,
        "columns",
        (),
    )

    if isinstance(
        trip_columns,
        dict,
    ):
        trip_columns = (
            trip_columns.values()
        )

    print(
        "\n========== TRIP TIME COLUMNS =========="
    )

    for column in trip_columns:

        column_name = (
            getattr(
                column,
                "name",
                None,
            )
            or getattr(
                column,
                "column_name",
                None,
            )
        )

        semantic_type = getattr(
            column,
            "semantic_type",
            None,
        )

        business_name = getattr(
            column,
            "business_name",
            None,
        )

        normalized_name = (
            column_name.lower()
            if column_name
            else ""
        )

        is_time_candidate = (
            semantic_type == "datetime"
            or "date" in normalized_name
            or "time" in normalized_name
            or "createdon" in normalized_name
            or "modifiedon" in normalized_name
        )

        if not is_time_candidate:
            continue

        print(
            f"{column_name} | "
            f"business_name={business_name} | "
            f"semantic_type={semantic_type}"
        )

    print(
        "======================================="
    )

    for column in raw_columns:

        column_name = (
            getattr(
                column,
                "name",
                None,
            )
            or getattr(
                column,
                "column_name",
                None,
            )
        )

        business_name = getattr(
            column,
            "business_name",
            None,
        )

        semantic_type = getattr(
            column,
            "semantic_type",
            None,
        )

        print(
            f"{column_name} | "
            f"business_name={business_name} | "
            f"semantic_type={semantic_type}"
        )

    print(
        "====================================="
    )




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

    context_builder = (
        GraphRAGContextBuilder(
        graph=
            graph,
        
        max_tables=5,
        max_columns_per_table=8,
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
    


    # test_queries = [
    #     "last week vehicle wise revenue",
    #     "customer wise trip revenue",
    #     "driver wise trip count",
    #     "show vehicle details",
    #     "customer mobile number",
    #     "trip profit",
    #     "fuel expenses",
    #     "vehicle maintenance details",
    #     "driver assigned vehicle",
    #     "trip invoice tax amount",
    # ]

    test_queries = (
        "last week vehicle wise revenue",
        "customer wise trip revenue",
        "driver wise trip count",
    )

    sql_generator = SQLGenerator()
    validator = SQLValidator()


    for query in test_queries:

        response = graph_retriever.search(
            query=query,
            top_k=25,
            candidate_k=50,
        )

        context = context_builder.build(
            response=response   
        )

        # -------------------------------------------------
        # Generate SQL
        # -------------------------------------------------

        # if response.query == "last week vehicle wise revenue":

        #     sql_generator = (
        #         SQLGenerator()
        #     )

        generated_sql = (
            await sql_generator.generate(
                context=context
            )
        )

        validated_sql = validator.validate(
            sql=generated_sql,
            context=context,
        )

        print(
            "\n========== GENERATED SQL =========="
        )

        print(
            generated_sql
        )

        print(
            "==================================="
        )

        print(
            "\n========== VALIDATED SQL =========="
        )

        print(
            validated_sql
        )

        # SQL PROMPT GENERATION Started

        prompt_builder = (
            SQLPromptBuilder()
        )

        sql_prompt = (
            prompt_builder.build(
                context=context
            )
        )

        print(
            "\n========== SQL GENERATION PROMPT =========="
        )

        print(
            sql_prompt
        )

        print(
            "==========================================="
        )

        # =====================SQL PROMPT GENERATION Ended ================================

        logger.info(
            "Aggregation Object: %s",
            context.aggregation,
        )

        logger.info(
            "Temporal Filter Object: %s",
            context.temporal_filter,
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

    # -------------------------------------------------
        # GRAPHRAG CONTEXT OUTPUT
        # -------------------------------------------------

        logger.info(
            "\n"
            "========== GRAPHRAG CONTEXT ==========\n"
            "%s\n"
            "=======================================",
            context.llm_context,
        )

if __name__ == "__main__":

    asyncio.run(
        main()
    )