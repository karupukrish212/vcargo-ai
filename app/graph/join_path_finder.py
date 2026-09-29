import logging
from collections import deque

from app.graph.models import (
    GraphJoinPath,
    GraphJoinPathSearchResult,
    GraphJoinPathStep,
    GraphPathJoinCondition,
    GraphRelationship,
    GraphTraversalDirection,
)

from app.graph.schema_graph import (
    SchemaGraph,
)

from app.schema.relationships.models import (
    RelationshipCardinality,
)


logger = logging.getLogger(__name__)


# =========================================================
# EXCEPTIONS
# =========================================================


class JoinPathFinderError(Exception):
    """
    Base exception for join-path errors.
    """

    pass


class JoinPathNotFoundError(
    JoinPathFinderError
):
    """
    No trusted relationship path exists
    between requested tables.
    """

    pass


class JoinPathAmbiguityError(
    JoinPathFinderError
):
    """
    More than one equally short trusted
    relationship path was found.

    We intentionally do not silently choose one.
    """

    pass


# =========================================================
# JOIN PATH FINDER
# =========================================================


class JoinPathFinder:
    """
    Finds trusted join paths using the in-memory
    SchemaGraph.

    Algorithm:
        Breadth-First Search (BFS)

    Why BFS?

    Because an unweighted schema graph normally
    prefers the fewest number of joins.

    Example:

        customer
            ↓
        trip
            ↓
        tvehicle

    = 2 hops


    Enterprise safety principles:

    - Approved relationships only
      (already guaranteed by SchemaGraph)

    - No relationship guessing

    - No table guessing

    - Prevent traversal cycles

    - Limit maximum hops

    - Detect multiple shortest paths

    - Preserve exact join columns

    - Preserve tenant-scope joins

    - Preserve cardinality
    """

    DEFAULT_MAX_HOPS = 5

    DEFAULT_MAX_PATHS = 20

    def __init__(
        self,
        graph: SchemaGraph,
    ) -> None:

        self.graph = graph

    # =====================================================
    # UNIQUE SHORTEST PATH
    # =====================================================

    def find_shortest_path(
        self,
        start_table: str,
        end_table: str,
        max_hops: int | None = None,
    ) -> GraphJoinPath:
        """
        Return one shortest path ONLY when that
        shortest path is unambiguous.

        If multiple equally short paths exist,
        raise JoinPathAmbiguityError.

        This is safer than arbitrarily selecting
        a join route.
        """

        result = (
            self.find_all_shortest_paths(
                start_table=start_table,
                end_table=end_table,
                max_hops=max_hops,
            )
        )

        if not result.paths:

            raise JoinPathNotFoundError(
                "No trusted join path found "
                f"between {start_table!r} "
                f"and {end_table!r}."
            )

        if result.ambiguous:

            raise JoinPathAmbiguityError(
                "Multiple equally short trusted "
                "join paths were found between "
                f"{start_table!r} and "
                f"{end_table!r}. "
                "Additional business/schema context "
                "is required before generating SQL."
            )

        return result.paths[0]

    # =====================================================
    # ALL SHORTEST PATHS
    # =====================================================

    def find_all_shortest_paths(
        self,
        start_table: str,
        end_table: str,
        max_hops: int | None = None,
        max_paths: int | None = None,
    ) -> GraphJoinPathSearchResult:
        """
        Return all equally-short trusted paths.

        Example:

        A -> B -> D
        A -> C -> D

        Both are 2 hops.

        We preserve both instead of hiding
        the ambiguity.
        """

        self._validate_tables(
            start_table,
            end_table,
        )

        resolved_max_hops = (
            max_hops
            if max_hops is not None
            else self.DEFAULT_MAX_HOPS
        )

        resolved_max_paths = (
            max_paths
            if max_paths is not None
            else self.DEFAULT_MAX_PATHS
        )

        if resolved_max_hops < 0:

            raise ValueError(
                "max_hops cannot be negative."
            )

        if resolved_max_paths < 1:

            raise ValueError(
                "max_paths must be at least 1."
            )

        # -------------------------------------------------
        # Same table
        # -------------------------------------------------

        if start_table == end_table:

            path = GraphJoinPath(

                start_table=start_table,

                end_table=end_table,

                tables=(
                    start_table,
                ),

                steps=(),

                hop_count=0,

                minimum_confidence=1.0,

                average_confidence=1.0,
            )

            return GraphJoinPathSearchResult(

                start_table=start_table,

                end_table=end_table,

                shortest_hop_count=0,

                paths=(
                    path,
                ),

                ambiguous=False,
            )

        # =================================================
        # BFS QUEUE
        #
        # Each item:
        #
        # (
        #   current_table,
        #   tables_in_path,
        #   relationship_ids
        # )
        # =================================================

        queue = deque(
            [
                (
                    start_table,
                    (
                        start_table,
                    ),
                    (),
                )
            ]
        )

        # Best known depth for each table.
        #
        # Important:
        # Equal depth is still allowed because
        # there may be multiple shortest paths.

        best_depth: dict[
            str,
            int,
        ] = {
            start_table: 0
        }

        shortest_hops: int | None = None

        raw_paths: list[
            tuple[
                tuple[str, ...],
                tuple[str, ...],
            ]
        ] = []

        while queue:

            (
                current_table,
                path_tables,
                relationship_ids,
            ) = queue.popleft()

            current_depth = len(
                relationship_ids
            )

            # -------------------------------------------------
            # Once shortest path found,
            # deeper paths are unnecessary.
            # -------------------------------------------------

            if (
                shortest_hops is not None
                and current_depth
                >= shortest_hops
            ):

                continue

            if (
                current_depth
                >= resolved_max_hops
            ):

                continue

            neighbors = (
                self.graph.get_neighbors(
                    current_table
                )
            )

            for neighbor in neighbors:

                next_table = (
                    neighbor.adjacent_table
                )

                # ---------------------------------------------
                # Cycle prevention
                #
                # Example:
                #
                # trip -> customer -> trip
                # ---------------------------------------------

                if next_table in path_tables:
                    continue

                next_depth = (
                    current_depth
                    + 1
                )

                if (
                    next_depth
                    > resolved_max_hops
                ):

                    continue

                next_tables = (
                    path_tables
                    + (
                        next_table,
                    )
                )

                next_relationship_ids = (
                    relationship_ids
                    + (
                        neighbor.relationship_id,
                    )
                )

                # ---------------------------------------------
                # Destination reached
                # ---------------------------------------------

                if next_table == end_table:

                    if shortest_hops is None:

                        shortest_hops = (
                            next_depth
                        )

                    if (
                        next_depth
                        == shortest_hops
                    ):

                        raw_paths.append(
                            (
                                next_tables,
                                next_relationship_ids,
                            )
                        )

                        if (
                            len(
                                raw_paths
                            )
                            >= resolved_max_paths
                        ):

                            logger.warning(
                                "Maximum shortest path "
                                "result limit reached: %d",
                                resolved_max_paths,
                            )

                            break

                    continue

                # ---------------------------------------------
                # Don't explore deeper than already known
                # shortest destination.
                # ---------------------------------------------

                if (
                    shortest_hops is not None
                    and next_depth
                    >= shortest_hops
                ):

                    continue

                previous_best_depth = (
                    best_depth.get(
                        next_table
                    )
                )

                # If we already reached this table
                # through a shorter route, this route
                # cannot contribute to a shortest path.

                if (
                    previous_best_depth is not None
                    and next_depth
                    > previous_best_depth
                ):

                    continue

                if (
                    previous_best_depth is None
                    or next_depth
                    < previous_best_depth
                ):

                    best_depth[
                        next_table
                    ] = next_depth

                # Equal-depth alternatives are retained.

                queue.append(
                    (
                        next_table,
                        next_tables,
                        next_relationship_ids,
                    )
                )

            if (
                len(
                    raw_paths
                )
                >= resolved_max_paths
            ):

                break

        # -------------------------------------------------
        # No path
        # -------------------------------------------------

        if not raw_paths:

            return GraphJoinPathSearchResult(

                start_table=start_table,

                end_table=end_table,

                shortest_hop_count=None,

                paths=(),

                ambiguous=False,
            )

        # -------------------------------------------------
        # Deduplicate paths
        # -------------------------------------------------

        unique_raw_paths: list[
            tuple[
                tuple[str, ...],
                tuple[str, ...],
            ]
        ] = []

        seen: set[
            tuple[
                tuple[str, ...],
                tuple[str, ...],
            ]
        ] = set()

        for raw_path in raw_paths:

            if raw_path in seen:
                continue

            seen.add(
                raw_path
            )

            unique_raw_paths.append(
                raw_path
            )

        # -------------------------------------------------
        # Convert raw path -> runtime path models
        # -------------------------------------------------

        paths = tuple(
            self._build_join_path(
                tables=tables,
                relationship_ids=relationship_ids,
            )

            for (
                tables,
                relationship_ids,
            )
            in unique_raw_paths
        )

        logger.info(
            "Join path search: %s -> %s | "
            "shortest_hops=%s paths=%d",
            start_table,
            end_table,
            shortest_hops,
            len(
                paths
            ),
        )

        return GraphJoinPathSearchResult(

            start_table=start_table,

            end_table=end_table,

            shortest_hop_count=(
                shortest_hops
            ),

            paths=paths,

            ambiguous=(
                len(
                    paths
                )
                > 1
            ),
        )

    # =====================================================
    # DIRECT PATH CHECK
    # =====================================================

    def find_direct_paths(
        self,
        table_a: str,
        table_b: str,
    ) -> tuple[
        GraphJoinPath,
        ...
    ]:
        """
        Return direct one-hop relationships only.

        Useful before running multi-hop traversal.
        """

        self._validate_tables(
            table_a,
            table_b,
        )

        relationships = (
            self.graph.relationships_between(
                table_a,
                table_b,
            )
        )

        paths: list[
            GraphJoinPath
        ] = []

        for relationship in relationships:

            paths.append(
                self._build_join_path(
                    tables=(
                        table_a,
                        table_b,
                    ),
                    relationship_ids=(
                        relationship.relationship_id,
                    ),
                )
            )

        return tuple(
            paths
        )

    # =====================================================
    # PATH BUILDER
    # =====================================================

    def _build_join_path(
        self,
        tables: tuple[
            str,
            ...
        ],
        relationship_ids: tuple[
            str,
            ...
        ],
    ) -> GraphJoinPath:
        """
        Convert BFS path into full join details.
        """

        if (
            len(
                tables
            )
            != len(
                relationship_ids
            )
            + 1
        ):

            raise JoinPathFinderError(
                "Invalid internal path structure."
            )

        steps: list[
            GraphJoinPathStep
        ] = []

        confidence_scores: list[
            float
        ] = []

        for index, relationship_id in enumerate(
            relationship_ids
        ):

            from_table = (
                tables[
                    index
                ]
            )

            to_table = (
                tables[
                    index + 1
                ]
            )

            relationship = (
                self.graph.get_relationship(
                    relationship_id
                )
            )

            step = (
                self._build_path_step(
                    from_table=from_table,
                    to_table=to_table,
                    relationship=relationship,
                )
            )

            steps.append(
                step
            )

            confidence_scores.append(
                relationship.confidence_score
            )

        if confidence_scores:

            minimum_confidence = min(
                confidence_scores
            )

            average_confidence = (
                sum(
                    confidence_scores
                )
                / len(
                    confidence_scores
                )
            )

        else:

            minimum_confidence = 1.0

            average_confidence = 1.0

        return GraphJoinPath(

            start_table=(
                tables[0]
            ),

            end_table=(
                tables[-1]
            ),

            tables=(
                tables
            ),

            steps=tuple(
                steps
            ),

            hop_count=len(
                steps
            ),

            minimum_confidence=round(
                minimum_confidence,
                4,
            ),

            average_confidence=round(
                average_confidence,
                4,
            ),
        )

    # =====================================================
    # PATH STEP BUILDER
    # =====================================================

    def _build_path_step(
        self,
        from_table: str,
        to_table: str,
        relationship: GraphRelationship,
    ) -> GraphJoinPathStep:
        """
        Convert canonical relationship into the
        actual traversal direction.
        """

        if not relationship.connects(
            from_table
        ):

            raise JoinPathFinderError(
                f"Relationship "
                f"{relationship.relationship_id} "
                f"does not connect table "
                f"{from_table!r}."
            )

        expected_other_table = (
            relationship.other_table(
                from_table
            )
        )

        if (
            expected_other_table
            != to_table
        ):

            raise JoinPathFinderError(
                f"Relationship "
                f"{relationship.relationship_id} "
                f"does not connect "
                f"{from_table!r} to "
                f"{to_table!r}."
            )

        direction = (
            relationship.traversal_direction(
                from_table
            )
        )

        join_conditions: list[
            GraphPathJoinCondition
        ] = []

        for pair in (
            relationship.join_pairs(
                include_tenant_scope=True
            )
        ):

            if (
                direction
                == GraphTraversalDirection
                .SOURCE_TO_TARGET
            ):

                join_conditions.append(
                    GraphPathJoinCondition(

                        from_table=(
                            relationship
                            .source_table
                        ),

                        from_column=(
                            pair.source_column
                        ),

                        to_table=(
                            relationship
                            .target_table
                        ),

                        to_column=(
                            pair.target_column
                        ),

                        operator=(
                            relationship
                            .join_operator
                        ),

                        is_tenant_scope=(
                            pair.is_tenant_scope
                        ),
                    )
                )

            else:

                join_conditions.append(
                    GraphPathJoinCondition(

                        from_table=(
                            relationship
                            .target_table
                        ),

                        from_column=(
                            pair.target_column
                        ),

                        to_table=(
                            relationship
                            .source_table
                        ),

                        to_column=(
                            pair.source_column
                        ),

                        operator=(
                            relationship
                            .join_operator
                        ),

                        is_tenant_scope=(
                            pair.is_tenant_scope
                        ),
                    )
                )

        traversal_cardinality = (
            self._cardinality_for_direction(
                relationship.cardinality,
                direction,
            )
        )

        return GraphJoinPathStep(

            from_table=(
                from_table
            ),

            to_table=(
                to_table
            ),

            relationship_id=(
                relationship.relationship_id
            ),

            direction=(
                direction
            ),

            canonical_cardinality=(
                relationship.cardinality
            ),

            traversal_cardinality=(
                traversal_cardinality
            ),

            relationship_source=(
                relationship
                .relationship_source
            ),

            confidence_score=(
                relationship
                .confidence_score
            ),

            join_conditions=tuple(
                join_conditions
            ),
        )

    # =====================================================
    # CARDINALITY DIRECTION
    # =====================================================

    @staticmethod
    def _cardinality_for_direction(
        cardinality: RelationshipCardinality,
        direction: GraphTraversalDirection,
    ) -> RelationshipCardinality:
        """
        Canonical:

            trip -> customer
            MANY_TO_ONE

        Reverse traversal:

            customer -> trip
            ONE_TO_MANY
        """

        if (
            direction
            == GraphTraversalDirection
            .SOURCE_TO_TARGET
        ):

            return cardinality

        if (
            cardinality
            == RelationshipCardinality.MANY_TO_ONE
        ):

            return (
                RelationshipCardinality.ONE_TO_MANY
            )

        if (
            cardinality
            == RelationshipCardinality.ONE_TO_MANY
        ):

            return (
                RelationshipCardinality.MANY_TO_ONE
            )

        # These are symmetric.

        if (
            cardinality
            == RelationshipCardinality.ONE_TO_ONE
        ):

            return (
                RelationshipCardinality.ONE_TO_ONE
            )

        if (
            cardinality
            == RelationshipCardinality.MANY_TO_MANY
        ):

            return (
                RelationshipCardinality.MANY_TO_MANY
            )

        return (
            RelationshipCardinality.UNKNOWN
        )

    # =====================================================
    # INPUT VALIDATION
    # =====================================================

    def _validate_tables(
        self,
        start_table: str,
        end_table: str,
    ) -> None:

        if not start_table:

            raise ValueError(
                "start_table cannot be empty."
            )

        if not end_table:

            raise ValueError(
                "end_table cannot be empty."
            )

        if not self.graph.has_table(
            start_table
        ):

            raise KeyError(
                f"Unknown start table: "
                f"{start_table}"
            )

        if not self.graph.has_table(
            end_table
        ):

            raise KeyError(
                f"Unknown end table: "
                f"{end_table}"
            )