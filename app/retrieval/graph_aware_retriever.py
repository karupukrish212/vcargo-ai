import logging
from collections import deque

from app.graph.schema_graph import (
    SchemaGraph,
)

from app.retrieval.models import (
    GraphAwareRetrievalResponse,
    GraphAwareRetrievalResult,
    SchemaDocumentType,
    SchemaRetrievalResponse,
)

from app.retrieval.schema_retriever import (
    HybridSchemaRetriever,
)


logger = logging.getLogger(__name__)


class GraphAwareRetrieverError(Exception):
    """
    Base exception for graph-aware retrieval.
    """

    pass


class GraphAwareSchemaRetriever:
    """
    Graph-aware schema retriever.

    Pipeline:

        User Query
            ↓
        Hybrid Retrieval
            ↓
        Anchor Table Detection
            ↓
        Table Coherence
            ↓
        Graph Proximity
            ↓
        Final Re-ranking


    Example:

        Query:
            vehicle wise revenue

        Hybrid results:

            trip.revenue
            tyremaster.vehicle
            trip.vehicle
            fuel.vehicle

        Query terms:

            vehicle
            revenue

        trip covers:

            vehicle ✅
            revenue ✅

        Therefore:

            anchor_table = trip

        Then:

            trip.*      gets same-table coherence
            tvehicle    gets graph-neighbour coherence
            unrelated vehicle columns receive less boost
    """

    DEFAULT_HYBRID_WEIGHT = 0.75

    DEFAULT_GRAPH_WEIGHT = 0.15

    DEFAULT_TABLE_COHERENCE_WEIGHT = 0.10

    DEFAULT_CANDIDATE_K = 50

    DEFAULT_MAX_GRAPH_HOPS = 3

    def __init__(
        self,
        hybrid_retriever: HybridSchemaRetriever,
        graph: SchemaGraph,
        hybrid_weight: float = DEFAULT_HYBRID_WEIGHT,
        graph_weight: float = DEFAULT_GRAPH_WEIGHT,
        table_coherence_weight: float = (
            DEFAULT_TABLE_COHERENCE_WEIGHT
        ),
    ) -> None:

        self.hybrid_retriever = (
            hybrid_retriever
        )

        self.graph = graph

        if hybrid_weight < 0:
            raise ValueError(
                "hybrid_weight cannot be negative."
            )

        if graph_weight < 0:
            raise ValueError(
                "graph_weight cannot be negative."
            )

        if table_coherence_weight < 0:
            raise ValueError(
                "table_coherence_weight "
                "cannot be negative."
            )

        total_weight = (
            hybrid_weight
            + graph_weight
            + table_coherence_weight
        )

        if total_weight <= 0:

            raise ValueError(
                "At least one reranking weight "
                "must be greater than zero."
            )

        # Normalize weights automatically.

        self.hybrid_weight = (
            hybrid_weight
            / total_weight
        )

        self.graph_weight = (
            graph_weight
            / total_weight
        )

        self.table_coherence_weight = (
            table_coherence_weight
            / total_weight
        )

    # =====================================================
    # SEARCH
    # =====================================================

    def search(
        self,
        query: str,
        top_k: int = 10,
        candidate_k: int = DEFAULT_CANDIDATE_K,
        max_graph_hops: int = DEFAULT_MAX_GRAPH_HOPS,
    ) -> GraphAwareRetrievalResponse:
        """
        Run complete graph-aware retrieval.
        """

        if not isinstance(
            query,
            str,
        ):

            raise TypeError(
                "query must be a string."
            )

        clean_query = (
            query.strip()
        )

        if not clean_query:

            raise ValueError(
                "query cannot be empty."
            )

        if top_k < 1:

            raise ValueError(
                "top_k must be at least 1."
            )

        if candidate_k < top_k:

            candidate_k = top_k

        if max_graph_hops < 0:

            raise ValueError(
                "max_graph_hops cannot be negative."
            )

        # =================================================
        # STEP 1
        # HYBRID RETRIEVAL
        # =================================================

        hybrid_response = (
            self.hybrid_retriever.search(

                query=clean_query,

                top_k=(
                    candidate_k
                ),
            )
        )

        if not hybrid_response.results:

            raise GraphAwareRetrieverError(
                "Hybrid retrieval returned "
                "no schema candidates."
            )

        # =================================================
        # STEP 2
        # BUILD TABLE EVIDENCE
        # =================================================

        table_evidence = (
            self._build_table_evidence(
                hybrid_response
            )
        )

        # =================================================
        # STEP 3
        # SELECT ANCHOR TABLE
        # =================================================

        anchor_table = (
            self._select_anchor_table(
                hybrid_response=(
                    hybrid_response
                ),
                table_evidence=(
                    table_evidence
                ),
            )
        )

        logger.info(
            "Graph-aware anchor selected. "
            "Query=%r Anchor=%s",
            clean_query,
            anchor_table,
        )

        # =================================================
        # STEP 4
        # CALCULATE GRAPH DISTANCES
        # =================================================

        graph_distances = (
            self._calculate_graph_distances(
                start_table=anchor_table,
                max_hops=max_graph_hops,
            )
        )

        # =================================================
        # STEP 5
        # GRAPH-AWARE RERANKING
        # =================================================

        ranked_results: list[
            GraphAwareRetrievalResult
        ] = []

        temporary_results: list[
            dict
        ] = []

        for result in (
            hybrid_response.results
        ):

            # ---------------------------------------------
            # TABLE COHERENCE
            # ---------------------------------------------

            table_stats = (
                table_evidence.get(
                    result.table_name,
                    {},
                )
            )

            table_coherence_score = float(
                table_stats.get(
                    "coverage_ratio",
                    0.0,
                )
            )

            # ---------------------------------------------
            # GRAPH DISTANCE
            # ---------------------------------------------

            graph_distance = (
                graph_distances.get(
                    result.table_name
                )
            )

            graph_score = (
                self._graph_score_from_distance(
                    graph_distance
                )
            )

            # ---------------------------------------------
            # FINAL SCORE
            # ---------------------------------------------

            final_score = (

                self.hybrid_weight
                * result.final_score

                +

                self.graph_weight
                * graph_score

                +

                self.table_coherence_weight
                * table_coherence_score
            )

            temporary_results.append(
                {
                    "result": result,
                    "graph_distance": (
                        graph_distance
                    ),
                    "graph_score": (
                        graph_score
                    ),
                    "table_coherence_score": (
                        table_coherence_score
                    ),
                    "final_score": (
                        final_score
                    ),
                }
            )

        # =================================================
        # STEP 6
        # SORT
        # =================================================

        temporary_results.sort(

            key=lambda item: (

                item[
                    "final_score"
                ],

                item[
                    "table_coherence_score"
                ],

                item[
                    "graph_score"
                ],

                item[
                    "result"
                ].final_score,

            ),

            reverse=True,
        )

        # =================================================
        # STEP 7
        # FINAL TOP-K
        # =================================================

        for rank, item in enumerate(
            temporary_results[
                :top_k
            ],
            start=1,
        ):

            result = (
                item[
                    "result"
                ]
            )

            ranked_results.append(
                GraphAwareRetrievalResult(

                    rank=rank,

                    document_id=(
                        result.document_id
                    ),

                    document_type=(
                        result.document_type
                    ),

                    table_name=(
                        result.table_name
                    ),

                    column_name=(
                        result.column_name
                    ),

                    business_name=(
                        result.business_name
                    ),

                    semantic_score=(
                        result.semantic_score
                    ),

                    lexical_score=(
                        result.lexical_score
                    ),

                    hybrid_score=(
                        result.final_score
                    ),

                    table_coherence_score=round(
                        item[
                            "table_coherence_score"
                        ],
                        4,
                    ),

                    graph_score=round(
                        item[
                            "graph_score"
                        ],
                        4,
                    ),

                    final_score=round(
                        item[
                            "final_score"
                        ],
                        4,
                    ),

                    graph_distance=(
                        item[
                            "graph_distance"
                        ]
                    ),

                    matched_terms=(
                        result.matched_terms
                    ),
                )
            )

        logger.info(
            "Graph-aware retrieval completed. "
            "Query=%r Anchor=%s Results=%d",
            clean_query,
            anchor_table,
            len(
                ranked_results
            ),
        )

        return GraphAwareRetrievalResponse(

            query=clean_query,

            normalized_terms=(
                hybrid_response
                .normalized_terms
            ),

            anchor_table=(
                anchor_table
            ),

            results=tuple(
                ranked_results
            ),
        )

    # =====================================================
    # TABLE EVIDENCE
    # =====================================================

    @staticmethod
    def _build_table_evidence(
        hybrid_response: SchemaRetrievalResponse,
    ) -> dict[
        str,
        dict,
    ]:
        """
        Determine how strongly each table covers
        the query concepts.

        Example:

            Query terms:
                vehicle
                revenue

            trip:
                revenue → matched
                vehicle → matched

            coverage:
                2 / 2 = 1.0


            tyremaster:
                vehicle → matched

            coverage:
                1 / 2 = 0.5
        """

        query_terms = set(
            hybrid_response
            .normalized_terms
        )

        table_data: dict[
            str,
            dict,
        ] = {}

        for result in (
            hybrid_response.results
        ):

            data = (
                table_data.setdefault(
                    result.table_name,
                    {
                        "matched_terms": set(),
                        "best_score": 0.0,
                        "table_document_score": 0.0,
                        "term_scores": {},
                    },
                )
            )

            data[
                "best_score"
            ] = max(
                data[
                    "best_score"
                ],
                result.final_score,
            )

            # ---------------------------------------------
            # Table document evidence
            # ---------------------------------------------

            if (
                result.document_type
                == SchemaDocumentType.TABLE
            ):

                data[
                    "table_document_score"
                ] = max(
                    data[
                        "table_document_score"
                    ],
                    result.final_score,
                )

            # ---------------------------------------------
            # Query term evidence
            # ---------------------------------------------

            for term in (
                result.matched_terms
            ):

                data[
                    "matched_terms"
                ].add(
                    term
                )

                existing_score = (
                    data[
                        "term_scores"
                    ].get(
                        term,
                        0.0,
                    )
                )

                data[
                    "term_scores"
                ][
                    term
                ] = max(
                    existing_score,
                    result.final_score,
                )

        # -------------------------------------------------
        # Coverage calculations
        # -------------------------------------------------

        for data in (
            table_data.values()
        ):

            if query_terms:

                coverage_ratio = (
                    len(
                        data[
                            "matched_terms"
                        ]
                        & query_terms
                    )
                    / len(
                        query_terms
                    )
                )

            else:

                coverage_ratio = 0.0

            data[
                "coverage_ratio"
            ] = coverage_ratio

            if data[
                "term_scores"
            ]:

                term_strength = (
                    sum(
                        data[
                            "term_scores"
                        ].values()
                    )
                    / len(
                        data[
                            "term_scores"
                        ]
                    )
                )

            else:

                term_strength = 0.0

            data[
                "term_strength"
            ] = (
                term_strength
            )

        return table_data

    # =====================================================
    # ANCHOR TABLE SELECTION
    # =====================================================

    @staticmethod
    def _select_anchor_table(
        hybrid_response: SchemaRetrievalResponse,
        table_evidence: dict[
            str,
            dict,
        ],
    ) -> str:
        """
        Choose the table that best explains
        the query.

        Priority:

        1. Query-term coverage
        2. Strength of matched terms
        3. Explicit table document score
        4. Best hybrid result
        """

        if not table_evidence:

            return (
                hybrid_response
                .results[0]
                .table_name
            )

        ranked_tables: list[
            tuple[
                str,
                float,
                float,
                float,
                float,
            ]
        ] = []

        for (
            table_name,
            evidence,
        ) in (
            table_evidence.items()
        ):

            ranked_tables.append(
                (
                    table_name,

                    float(
                        evidence.get(
                            "coverage_ratio",
                            0.0,
                        )
                    ),

                    float(
                        evidence.get(
                            "term_strength",
                            0.0,
                        )
                    ),

                    float(
                        evidence.get(
                            "table_document_score",
                            0.0,
                        )
                    ),

                    float(
                        evidence.get(
                            "best_score",
                            0.0,
                        )
                    ),
                )
            )

        ranked_tables.sort(
            key=lambda item: (
                item[1],  # coverage
                item[3],  # explicit table document evidence
                item[2],  # matched term strength
                item[4],  # best hybrid score
            ),
            reverse=True,
        )
        return (
            ranked_tables[0][0]
        )

    # =====================================================
    # GRAPH DISTANCES
    # =====================================================

    def _calculate_graph_distances(
        self,
        start_table: str,
        max_hops: int,
    ) -> dict[
        str,
        int,
    ]:
        """
        BFS from anchor table.

        Example:

            trip       = 0 hops
            tvehicle   = 1 hop
            another    = 2 hops
        """

        if not self.graph.has_table(
            start_table
        ):

            raise GraphAwareRetrieverError(
                f"Anchor table "
                f"{start_table!r} "
                f"does not exist in graph."
            )

        distances: dict[
            str,
            int,
        ] = {
            start_table: 0
        }

        queue = deque(
            [
                start_table
            ]
        )

        while queue:

            current_table = (
                queue.popleft()
            )

            current_distance = (
                distances[
                    current_table
                ]
            )

            if (
                current_distance
                >= max_hops
            ):

                continue

            for neighbor in (
                self.graph.get_neighbors(
                    current_table
                )
            ):

                next_table = (
                    neighbor
                    .adjacent_table
                )

                if (
                    next_table
                    in distances
                ):

                    continue

                next_distance = (
                    current_distance
                    + 1
                )

                distances[
                    next_table
                ] = next_distance

                queue.append(
                    next_table
                )

        return distances

    # =====================================================
    # GRAPH DISTANCE SCORE
    # =====================================================

    @staticmethod
    def _graph_score_from_distance(
        distance: int | None,
    ) -> float:
        """
        Convert graph distance into coherence score.

        Same table:
            1.00

        Direct neighbour:
            0.80

        Two hops:
            0.45

        Three hops:
            0.20

        Disconnected / farther:
            0.00
        """

        if distance is None:

            return 0.0

        if distance == 0:

            return 1.0

        if distance == 1:

            return 0.80

        if distance == 2:

            return 0.45

        if distance == 3:

            return 0.20

        return 0.0