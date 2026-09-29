import logging

from app.core.logging_config import (
    configure_logging,
)

from app.graph.join_path_finder import (
    JoinPathAmbiguityError,
    JoinPathFinder,
    JoinPathNotFoundError,
)

from app.graph.schema_graph import (
    SchemaGraph,
)


logger = logging.getLogger(__name__)


def main() -> None:

    configure_logging()

    logger.info(
        "Loading Python schema graph..."
    )

    graph = (
        SchemaGraph.from_settings()
    )

    summary = (
        graph.summary()
    )

    logger.info(
        "Schema graph loaded"
    )

    logger.info(
        "Tables: %d",
        summary.table_count,
    )

    logger.info(
        "Columns: %d",
        summary.column_count,
    )

    logger.info(
        "Relationships: %d",
        summary.relationship_count,
    )

    logger.info(
        "Isolated tables: %d",
        summary.isolated_table_count,
    )

#     logger.info(
#     "========== ALL GRAPH RELATIONSHIPS =========="
# )

#     for relationship in graph.get_relationships():

#         logger.info(
#             "%s | %s.%s -> %s.%s | "
#             "Cardinality=%s | "
#             "Source=%s | "
#             "Confidence=%.2f | "
#             "Status=%s",
#             relationship.relationship_id,
#             relationship.source_table,
#             list(
#                 relationship.source_columns
#             ),
#             relationship.target_table,
#             list(
#                 relationship.target_columns
#             ),
#             relationship.cardinality.value,
#             relationship.relationship_source.value,
#             relationship.confidence_score,
#             relationship.status.value,
#         )

#     logger.info(
#         "========== END RELATIONSHIPS =========="
#     )

    finder = (
        JoinPathFinder(
            graph
        )
    )

    # -----------------------------------------------------
    # TEST:
    # customer -> trip
    # -----------------------------------------------------

    try:

        path = (
            finder.find_shortest_path(
                "customer",
                "trip",
            )
        )

        logger.info(
            "Join path found: %s",
            " -> ".join(
                path.tables
            ),
        )

        logger.info(
            "Hop count: %d",
            path.hop_count,
        )

        for step in path.steps:

            logger.info(
                "Step: %s -> %s | "
                "Relationship=%s | "
                "Cardinality=%s",
                step.from_table,
                step.to_table,
                step.relationship_id,
                step.traversal_cardinality.value,
            )

            for condition in (
                step.join_conditions
            ):

                logger.info(
                    "Join: %s.%s %s %s.%s "
                    "| tenant=%s",
                    condition.from_table,
                    condition.from_column,
                    condition.operator,
                    condition.to_table,
                    condition.to_column,
                    condition.is_tenant_scope,
                )

    except JoinPathNotFoundError as exc:

        logger.warning(
            "%s",
            exc,
        )

    except JoinPathAmbiguityError as exc:

        logger.warning(
            "%s",
            exc,
        )


if __name__ == "__main__":
    main()