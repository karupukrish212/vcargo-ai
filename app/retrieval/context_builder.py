from __future__ import annotations
import re
import logging

from datetime import date, timedelta

from app.retrieval.models import (
    AggregationContext,
    ContextColumn,
    ContextJoinCondition,
    ContextTable,
    GraphAwareRetrievalResponse,
    GraphRAGContext,
    TemporalFilterContext,
)

from app.graph.join_path_finder import (
    JoinPathFinder,
)

from app.graph.schema_graph import (
    SchemaGraph,
)


logger = logging.getLogger(
    __name__
)


class GraphRAGContextBuilder:
    """
    Build compact structured schema context
    from graph-aware retrieval results.

    Current responsibilities:

    1. Identify anchor table
    2. Select relevant tables
    3. Select relevant columns
    4. Build compact LLM-readable context

    Join path integration will be added
    in the next step.
    """

    DEFAULT_MAX_TABLES = 5

    DEFAULT_MAX_COLUMNS_PER_TABLE = 8

    def __init__(
        self,
        graph: SchemaGraph,
        max_tables: int = DEFAULT_MAX_TABLES,
        max_columns_per_table: int = (
            DEFAULT_MAX_COLUMNS_PER_TABLE
        ),
    ) -> None:

        if graph is None:

            raise ValueError(
                "graph cannot be None."
            )

        if max_tables < 1:

            raise ValueError(
                "max_tables must be "
                "at least 1."
            )

        if max_columns_per_table < 1:

            raise ValueError(
                "max_columns_per_table "
                "must be at least 1."
            )

        self.graph = graph

        self.join_path_finder = (
            JoinPathFinder(
                graph
            )
        )

        self.max_tables = (
            max_tables
        )

        self.max_columns_per_table = (
            max_columns_per_table
        )
    # =====================================================
    # PUBLIC METHOD
    # =====================================================

    def build(
        self,
        response: GraphAwareRetrievalResponse,
    ) -> GraphRAGContext:
        """
        Convert graph-aware retrieval results
        into structured GraphRAG context.
        """

        if not response.results:

            raise ValueError(
                "Graph-aware retrieval "
                "contains no results."
            )

        anchor_table = (
            response.anchor_table
        )

        if not anchor_table:

            raise ValueError(
                "Graph-aware retrieval "
                "does not contain "
                "an anchor table."
            )

        temporal_intent = (
            self._detect_temporal_intent(
                response.query
            )
        )

        aggregation_intent = (
            self._detect_aggregation_intent(
                response.query
            )
        )

        logger.info(
            "Aggregation intent detected. "
            "Query='%s' Intent=%s",
            response.query,
            aggregation_intent,
        )

        time_column = (
            self._select_time_column(
                table_name=anchor_table,
                temporal_intent=(
                    temporal_intent
                ),
            )
        )

        temporal_range = (
            self._resolve_temporal_range(
                temporal_intent=(
                    temporal_intent
                )
            )
        )

        temporal_filter = None

        if (
            temporal_intent is not None
            and time_column is not None
            and temporal_range is not None
        ):

            (
                start_date,
                end_date_exclusive,
            ) = temporal_range

            time_column_metadata = (
                self._get_column_metadata(
                    table_name=anchor_table,
                    column_name=time_column,
                )
            )

            if time_column_metadata is None:
                raise ValueError(
                    "Temporal column metadata "
                    f"not found: "
                    f"{anchor_table}.{time_column}"
                )

            temporal_filter = (
                TemporalFilterContext(
                    intent=temporal_intent,

                    table_name=anchor_table,

                    column_name=time_column,

                    data_type=(
                        getattr(
                            time_column_metadata,
                            "data_type",
                            "UNKNOWN",
                        )
                    ),

                    requires_conversion=(
                        getattr(
                            time_column_metadata,
                            "requires_conversion",
                            False,
                        )
                    ),

                    stored_format=(
                        getattr(
                            time_column_metadata,
                            "stored_format",
                            None,
                        )
                    ),

                    mysql_format=(
                        getattr(
                            time_column_metadata,
                            "mysql_format",
                            None,
                        )
                    ),

                    start_date=start_date,

                    end_date_exclusive=(
                        end_date_exclusive
                    ),
                )
            )

        logger.info(
            "Temporal filter context created. "
            "Filter=%s",
            temporal_filter,
        )

        logger.info(
            "Temporal range resolved. "
            "Intent=%s Range=%s",
            temporal_intent,
            temporal_range,
        )

        logger.info(
            "Temporal context resolved. "
            "Intent=%s Table=%s Column=%s",
            temporal_intent,
            anchor_table,
            time_column,
        )

        logger.info(
            "Temporal intent detected. "
            "Query='%s' Intent=%s",
            response.query,
            temporal_intent,
        )

        # -------------------------------------------------
        # Select tables
        # -------------------------------------------------

        selected_table_names = (
            self._select_tables(
                response=response,
                anchor_table=anchor_table,
            )
        )

        # -------------------------------------------------
        # Build trusted joins
        # -------------------------------------------------

        trusted_joins = (
            self._build_trusted_joins(
                anchor_table=anchor_table,
                selected_table_names=(
                    selected_table_names
                ),
            )
        )

        # -------------------------------------------------
        # Build ContextTable objects
        # -------------------------------------------------

        context_tables: list[
            ContextTable
        ] = []

        for table_name in (
            selected_table_names
        ):

            context_table = (
                self._build_table_context(
                    response=response,
                    table_name=table_name,
                    anchor_table=anchor_table,
                    joins=trusted_joins,
                    time_column=time_column,
                )
            )

            context_tables.append(
                context_table
            )

        # -------------------------------------------------
        # Freeze ContextTable list as tuple
        # -------------------------------------------------

        context_tables_tuple = tuple(
            context_tables
        )

        # -------------------------------------------------
        # Resolve aggregation context
        # -------------------------------------------------

        aggregation_context = (
            self._resolve_aggregation_context(
                query=response.query,
                aggregation_type=(
                    aggregation_intent
                ),
                anchor_table=(
                    anchor_table
                ),
                tables=(
                    context_tables_tuple
                ),
                joins=(
                    trusted_joins
                ),
            )
        )

        logger.info(
            "Aggregation context resolved. "
            "Query='%s' Context=%s",
            response.query,
            aggregation_context,
        )

        # -------------------------------------------------
        # Debug complete ContextTable list
        # -------------------------------------------------

        logger.info(
            "ContextTable objects before LLM context: %s",
            tuple(
                (
                    table.table_name,
                    tuple(
                        column.column_name
                        for column in table.columns
                    ),
                )
                for table in context_tables
            ),
        )

        # -------------------------------------------------
        # Build LLM context text
        # -------------------------------------------------

        llm_context = (
            self._build_llm_context(
                query=response.query,
                anchor_table=anchor_table,
                tables=tuple(
                    context_tables_tuple
                ),
                joins=trusted_joins,
                temporal_filter=(
                    temporal_filter
                ),
                aggregation=(
                    aggregation_context
                ),
            )
        )

        # -------------------------------------------------
        # Safety check
        # -------------------------------------------------

        if not isinstance(
            llm_context,
            str,
        ):

            raise TypeError(
                "_build_llm_context() "
                "must return a string."
            )

        logger.info(
            "GraphRAG context built. "
            "Query=%r Anchor=%s Tables=%s",
            response.query,
            anchor_table,
            selected_table_names,
        )

        # -------------------------------------------------
        # Final GraphRAG context
        # -------------------------------------------------

        return GraphRAGContext(

            query=response.query,

            anchor_table=(
                anchor_table
            ),

            selected_tables=( context_tables_tuple
            ),

            joins=trusted_joins,

            temporal_filter=(
                temporal_filter
            ),

            aggregation=(
                aggregation_context
            ),


            llm_context=(
                llm_context
            ),
        )

    def _extract_required_related_terms(
        self,
        query: str,
        query_terms: tuple[str, ...],
        anchor_table: str,
    ) -> set[str]:
        """
        Identify query terms that truly require
        a related/master table.

        Examples:

        vehicle wise revenue
            -> vehicle

        customer wise trip revenue
            -> customer

        vehicle maintenance details
            -> vehicle

        driver assigned vehicle
            -> vehicle

        fuel expenses
            -> none
        """

        normalized_query = (
            query.lower().strip()
        )

        tokens = re.findall(
            r"[a-zA-Z0-9_]+",
            normalized_query,
        )

        normalized_anchor = (
            anchor_table
            .lower()
            .replace("_", "")
        )

        clean_query_terms = {
            term.lower().strip()
            for term in query_terms
            if term.strip()
        }

        required_terms: set[str] = set()

        # =================================================
        # RULE 1
        # "<entity> wise"
        #
        # vehicle wise revenue
        # customer wise revenue
        # =================================================

        for index, token in enumerate(
            tokens
        ):

            if (
                token == "wise"
                and index > 0
            ):

                previous_token = (
                    tokens[
                        index - 1
                    ]
                )

                if (
                    previous_token
                    in clean_query_terms
                ):

                    required_terms.add(
                        previous_token
                    )

        # =================================================
        # RULE 2
        # "by <entity>"
        # "per <entity>"
        #
        # revenue by vehicle
        # revenue per customer
        # =================================================

        for index, token in enumerate(
            tokens
        ):

            if token not in {
                "by",
                "per",
            }:

                continue

            if (
                index + 1
                >= len(tokens)
            ):

                continue

            next_token = (
                tokens[
                    index + 1
                ]
            )

            if (
                next_token
                in clean_query_terms
            ):

                required_terms.add(
                    next_token
                )

        # =================================================
        # RULE 3
        # Detail query with another entity
        #
        # vehicle maintenance details
        #
        # anchor = maintenance
        # vehicle = related entity
        #
        # show vehicle details:
        #
        # anchor = tvehicle
        # vehicle already belongs to anchor,
        # so no related table.
        # =================================================

        broad_detail_query = (
            "detail" in tokens
            or "details" in tokens
        )

        if broad_detail_query:

            for term in clean_query_terms:

                normalized_term = (
                    term.replace(
                        "_",
                        "",
                    )
                )

                if (
                    len(term) >= 3
                    and normalized_term
                    not in normalized_anchor
                ):

                    required_terms.add(
                        term
                    )

        # =================================================
        # RULE 4
        # Relationship/object query
        #
        # driver assigned vehicle
        #
        # anchor = tdriver
        # vehicle = related entity
        # =================================================

        relationship_words = {
            "assigned",
            "linked",
            "mapped",
            "associated",
            "allocated",
        }

        has_relationship_word = bool(
            relationship_words
            & set(tokens)
        )

        if has_relationship_word:

            for term in clean_query_terms:

                if term in relationship_words:

                    continue

                normalized_term = (
                    term.replace(
                        "_",
                        "",
                    )
                )

                if (
                    len(term) >= 3
                    and normalized_term
                    not in normalized_anchor
                ):

                    required_terms.add(
                        term
                    )

        return required_terms

    # =====================================================
    # TABLE SELECTION
    # =====================================================

    def _select_tables(
    self,
    response: GraphAwareRetrievalResponse,
    anchor_table: str,
) -> tuple[str, ...]:
        """
        Select only tables actually required
        for answering the query.

        Anchor table is always included.

        Related tables are added only when:

        - explicitly used as a dimension
        (vehicle wise, by customer, etc.)

        - explicitly requested in a detail query

        - explicitly involved in a relationship query
        (assigned vehicle, linked customer, etc.)

        - or the anchor table does not already
        satisfy that query concept.
        """

        selected: list[str] = [
            anchor_table
        ]

        query_terms = tuple(
            term.lower().strip()
            for term
            in response.normalized_terms
            if term.strip()
        )

        normalized_anchor = (
            anchor_table
            .lower()
            .replace("_", "")
        )

        # =================================================
        # Anchor table entity terms
        # =================================================

        anchor_entity_terms = {
            term
            for term in query_terms
            if (
                len(term) >= 3
                and term.replace(
                    "_",
                    "",
                )
                in normalized_anchor
            )
        }

        # =================================================
        # Terms already satisfied by anchor columns
        #
        # Example:
        #
        # fuel expenses
        #
        # trip.fuelcost -> fuel
        # trip.otherexpenses -> expenses
        #
        # Therefore fuel table is not automatically
        # required.
        # =================================================

        anchor_covered_terms: set[str] = set()

        for result in response.results:

            if (
                result.table_name
                != anchor_table
            ):

                continue

            if not result.column_name:

                continue

            anchor_covered_terms.update(
                term.lower()
                for term
                in result.matched_terms
            )

        # =================================================
        # Explicit related entities
        # =================================================

        required_related_terms = (
            self._extract_required_related_terms(
                query=response.query,
                query_terms=query_terms,
                anchor_table=anchor_table,
            )
        )

        # =================================================
        # RELATIONSHIP QUERY ALREADY SATISFIED
        # BY ANCHOR COLUMN
        #
        # Example:
        #
        # driver assigned vehicle
        #
        # Anchor:
        #   tdriver
        #
        # Column:
        #   assignedvehicle
        #
        # matched_terms:
        #   driver, assigned, vehicle
        #
        # In this case we do NOT need to force
        # tvehicle into the context.
        # =================================================

        query_tokens = set(
            re.findall(
                r"[a-zA-Z0-9_]+",
                response.query.lower(),
            )
        )

        relationship_words = {
            "assigned",
            "linked",
            "mapped",
            "associated",
            "allocated",
        }

        has_relationship_word = bool(
            query_tokens
            & relationship_words
        )

        broad_detail_query = (
            "detail" in query_tokens
            or "details" in query_tokens
        )

        if (
            has_relationship_word
            and not broad_detail_query
        ):

            for result in response.results:

                if (
                    result.table_name
                    != anchor_table
                ):

                    continue

                if not result.column_name:

                    continue

                matched_terms = {
                    term.lower()
                    for term
                    in result.matched_terms
                }

                # Remove related entity terms that are
                # already represented by an anchor column.
                #
                # Example:
                #
                # required_related_terms = {"vehicle"}
                #
                # assignedvehicle matched vehicle
                #
                # result:
                # required_related_terms = {}
                required_related_terms.difference_update(
                    matched_terms
                )

        # =================================================
        # Find candidate related tables
        # =================================================

        candidate_tables: dict[
            str,
            dict,
        ] = {}

        for result in response.results:

            table_name = (
                result.table_name
            )

            if not table_name:

                continue

            if (
                table_name
                == anchor_table
            ):

                continue

            normalized_table = (
                table_name
                .lower()
                .replace("_", "")
            )

            table_entity_terms = {
                term
                for term in query_terms
                if (
                    len(term) >= 3
                    and term.replace(
                        "_",
                        "",
                    )
                    in normalized_table
                )
            }

            # Remove terms already represented
            # by anchor table name.
            new_entity_terms = (
                table_entity_terms
                - anchor_entity_terms
            )

            if not new_entity_terms:

                continue

            # =================================================
            # Decide whether related table is actually needed
            # =================================================

            useful_terms: set[str] = set()

            for term in new_entity_terms:

                # Explicit dimension/entity request:
                #
                # vehicle wise
                # customer wise
                # assigned vehicle
                # maintenance details
                if (
                    term
                    in required_related_terms
                ):

                    useful_terms.add(
                        term
                    )

                    continue

                # If anchor table already has a column
                # satisfying this concept, don't add
                # another table automatically.
                #
                # fuel expenses:
                #
                # trip.fuelcost already satisfies fuel.
                if (
                    term
                    in anchor_covered_terms
                ):

                    continue

                useful_terms.add(
                    term
                )

            if not useful_terms:

                continue

            score = float(
                result.final_score
            )

            distance = (
                result.graph_distance
                if result.graph_distance
                is not None
                else 999
            )

            existing = (
                candidate_tables.get(
                    table_name
                )
            )

            if existing is None:

                candidate_tables[
                    table_name
                ] = {
                    "terms": set(
                        useful_terms
                    ),
                    "best_score": score,
                    "distance": distance,
                }

            else:

                existing[
                    "terms"
                ].update(
                    useful_terms
                )

                existing[
                    "best_score"
                ] = max(
                    existing[
                        "best_score"
                    ],
                    score,
                )

                existing[
                    "distance"
                ] = min(
                    existing[
                        "distance"
                    ],
                    distance,
                )

        # =================================================
        # Rank candidate tables
        # =================================================

        sorted_candidates = sorted(
            candidate_tables.items(),
            key=lambda item: (
                len(
                    item[1][
                        "terms"
                    ]
                ),
                -item[1][
                    "distance"
                ],
                item[1][
                    "best_score"
                ],
            ),
            reverse=True,
        )

        # =================================================
        # Add selected related tables
        # =================================================

        for (
            table_name,
            _
        ) in sorted_candidates:

            selected.append(
                table_name
            )

            if (
                len(selected)
                >= self.max_tables
            ):

                break

        logger.debug(
            "Context tables selected. "
            "Query=%r Anchor=%s "
            "AnchorTerms=%s "
            "AnchorCoveredTerms=%s "
            "RequiredRelatedTerms=%s "
            "Tables=%s",
            response.query,
            anchor_table,
            anchor_entity_terms,
            anchor_covered_terms,
            required_related_terms,
            selected,
        )

        return tuple(
            selected
        )  

    def _get_join_columns_for_table(
        self,
        table_name: str,
        joins: tuple[
            ContextJoinCondition,
            ...
        ],
    ) -> tuple[str, ...]:
        """
        Return columns required for trusted joins
        for a particular table.

        Example:

        trip.vehicle = tvehicle.tvehicleid

        trip     -> vehicle
        tvehicle -> tvehicleid
        """

        columns: list[str] = []

        for join in joins:

            if (
                join.source_table
                == table_name
            ):

                if (
                    join.source_column
                    not in columns
                ):

                    columns.append(
                        join.source_column
                    )

            if (
                join.target_table
                == table_name
            ):

                if (
                    join.target_column
                    not in columns
                ):

                    columns.append(
                        join.target_column
                    )

        return tuple(
            columns
        )



    # =====================================================
    # TABLE CONTEXT
    # =====================================================

    def _build_table_context(
        self,
        response: GraphAwareRetrievalResponse,
        table_name: str,
        anchor_table: str,
        joins: tuple[
            ContextJoinCondition,
            ...
        ],
        time_column: str | None,
    ) -> ContextTable:
        """
        Build context for one selected table.
        """

        table_results = [
            result
            for result in response.results
            if result.table_name
            == table_name
        ]

        # -------------------------------------------------
        # Best score for this table
        # -------------------------------------------------

        retrieval_score = 0.0

        if table_results:

            retrieval_score = max(
                float(
                    result.final_score
                )
                for result
                in table_results
            )

        # -------------------------------------------------
        # Graph distance
        # -------------------------------------------------

        graph_distances = [
            result.graph_distance
            for result
            in table_results
            if result.graph_distance
            is not None
        ]

        graph_distance = None

        if graph_distances:

            graph_distance = min(
                graph_distances
            )

        # -------------------------------------------------
        # Business name
        # -------------------------------------------------

        business_name = None

        for result in table_results:

            if result.business_name:

                business_name = (
                    result.business_name
                )

                break

        # -------------------------------------------------
        # Mandatory JOIN columns
        # -------------------------------------------------

        mandatory_join_columns = (
            self._get_join_columns_for_table(
                table_name=table_name,
                joins=joins,
            )
        )

        logger.info(
            "Mandatory join columns. "
            "Table=%s Columns=%s",
            table_name,
            mandatory_join_columns,
        )

        # -------------------------------------------------
        # Select columns
        # -------------------------------------------------

        columns = (
            self._select_columns(
                table_results=(
                    table_results
                ),
                query=(
                    response.query
                ),
                query_terms=(
                    response.normalized_terms
                ),
                table_name=(
                    table_name
                ),
                is_anchor=(
                    table_name
                    == anchor_table
                ),
                mandatory_join_columns=(
                    mandatory_join_columns
                ),
            )
        )

        # -------------------------------------------------
        # Add mandatory temporal/filter column
        # -------------------------------------------------

        selected_columns = list(
            columns
        )

        if (
            table_name == anchor_table
            and time_column is not None
        ):

            already_selected = any(
                column.column_name
                == time_column
                for column
                in selected_columns
            )

            if not already_selected:

                table = self.graph.get_table(
                    table_name
                )

                raw_columns = getattr(
                    table,
                    "columns",
                    (),
                )

                if isinstance(
                    raw_columns,
                    dict,
                ):
                    graph_columns = list(
                        raw_columns.values()
                    )
                else:
                    graph_columns = list(
                        raw_columns
                    )

                time_graph_column = next(
                    (
                        column
                        for column
                        in graph_columns
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
                        == time_column
                    ),
                    None,
                )

                business_name = None
                semantic_type = None

                if (
                    time_graph_column
                    is not None
                ):

                    business_name = getattr(
                        time_graph_column,
                        "business_name",
                        None,
                    )

                    semantic_type = getattr(
                        time_graph_column,
                        "semantic_type",
                        None,
                    )

                selected_columns.append(
                    ContextColumn(
                        table_name=(
                            table_name
                        ),
                        column_name=(
                            time_column
                        ),
                        business_name=(
                            business_name
                        ),
                        semantic_type=(
                            semantic_type
                        ),
                        retrieval_score=0.0,
                        matched_terms=(),
                    )
                )

                logger.info(
                    "Temporal filter column added "
                    "to context. Table=%s Column=%s",
                    table_name,
                    time_column,
                )

        columns = tuple(
            selected_columns
        )

        return ContextTable(

            table_name=table_name,

            business_name=(
                business_name
            ),

            domain=None,

            is_anchor=(
                table_name
                == anchor_table
            ),

            graph_distance=(
                graph_distance
            ),

            retrieval_score=round(
                retrieval_score,
                4,
            ),

            columns=columns,
        )

    def _find_display_column(
        self,
        table_name: str,
        query_terms: tuple[str, ...],
        mandatory_join_columns: tuple[str, ...],
    ) -> tuple[
        str,
        str | None,
        str | None,
    ] | None:
        """
        Find a safe user-facing display column.

        Priority examples:
            tdriver.name
            customer.customername
            tvehicle.vehiclenumber

        Never return join-key columns as display columns.
        """

        # -------------------------------------------------
        # Get table from trusted SchemaGraph
        # -------------------------------------------------

        table = self.graph.get_table(
            table_name
        )

        if table is None:
            return None

        raw_columns = getattr(
            table,
            "columns",
            (),
        )

        if isinstance(
            raw_columns,
            dict,
        ):
            graph_columns = list(
                raw_columns.values()
            )
        else:
            graph_columns = list(
                raw_columns
            )

        # -------------------------------------------------
        # Entity terms represented by table
        #
        # tdriver  + driver  -> driver
        # tvehicle + vehicle -> vehicle
        # customer + customer -> customer
        # -------------------------------------------------

        normalized_table = (
            table_name
            .lower()
            .replace("_", "")
        )

        entity_terms = [
            term.lower()
            for term in query_terms
            if (
                len(term) >= 3
                and term.lower()
                in normalized_table
            )
        ]

        candidates: list[
            tuple[
                int,
                str,
                str | None,
                str | None,
            ]
        ] = []

        # -------------------------------------------------
        # Evaluate every column
        # -------------------------------------------------

        for column in graph_columns:

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

            if not column_name:
                continue

            # Never use JOIN key as display column.
            if (
                column_name
                in mandatory_join_columns
            ):
                continue

            normalized_column = (
                column_name
                .lower()
                .replace("_", "")
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

            # =================================================
            # PRIORITY 1:
            # Generic display columns
            #
            # IMPORTANT:
            # This MUST happen BEFORE entity matching.
            #
            # Example:
            # tdriver.name
            #
            # "name" does not contain "driver",
            # but it is still a strong display column.
            # =================================================

            generic_display_scores = {
                "name": 200,
                "fullname": 190,
                "displayname": 185,
                "label": 180,
            }

            if (
                normalized_column
                in generic_display_scores
            ):

                candidates.append(
                    (
                        generic_display_scores[
                            normalized_column
                        ],
                        column_name,
                        business_name,
                        semantic_type,
                    )
                )

                continue

            # =================================================
            # PRIORITY 2:
            # Entity-specific columns
            #
            # customername
            # vehiclenumber
            # drivercode
            # =================================================

            matched_entity = False

            score = 0

            for entity_term in entity_terms:

                if (
                    entity_term
                    in normalized_column
                ):

                    matched_entity = True

                    score += 50

            if not matched_entity:
                continue

            # -------------------------------------------------
            # Strong display suffixes
            # -------------------------------------------------

            if normalized_column.endswith(
                "name"
            ):

                score += 150

            elif normalized_column.endswith(
                "number"
            ):

                score += 120

            elif normalized_column.endswith(
                "code"
            ):

                score += 100

            elif normalized_column.endswith(
                "title"
            ):

                score += 90

            else:

                # Example:
                # assignedvehicle / lasttrip
                #
                # Entity might match,
                # but it is NOT a safe display field.
                continue

            candidates.append(
                (
                    score,
                    column_name,
                    business_name,
                    semantic_type,
                )
            )

        # -------------------------------------------------
        # No safe display column found
        # -------------------------------------------------

        if not candidates:

            logger.debug(
                "No safe display column found. "
                "Table=%s",
                table_name,
            )

            return None

        # -------------------------------------------------
        # Highest-score display column wins
        # -------------------------------------------------

        candidates.sort(
            key=lambda item: item[0],
            reverse=True,
        )

        (
            score,
            column_name,
            business_name,
            semantic_type,
        ) = candidates[0]

        logger.info(
            "Display column selected. "
            "Table=%s Column=%s Score=%s",
            table_name,
            column_name,
            score,
        )

        return (
            column_name,
            business_name,
            semantic_type,
        )

    def _detect_temporal_intent(
    self,
    query: str,
) -> str | None:
        """
        Detect relative time intent from
        the original user question.

        This method only detects intent.
        It does NOT calculate SQL dates.
        """

        normalized_query = (
            query.lower().strip()
        )

        temporal_patterns = (
            (
                "last_week",
                (
                    "last week",
                    "previous week",
                ),
            ),
            (
                "this_week",
                (
                    "this week",
                    "current week",
                ),
            ),
            (
                "today",
                (
                    "today",
                ),
            ),
            (
                "yesterday",
                (
                    "yesterday",
                ),
            ),
            (
                "last_month",
                (
                    "last month",
                    "previous month",
                ),
            ),
            (
                "this_month",
                (
                    "this month",
                    "current month",
                ),
            ),
            (
                "last_year",
                (
                    "last year",
                    "previous year",
                ),
            ),
            (
                "this_year",
                (
                    "this year",
                    "current year",
                ),
            ),
        )

        for (
            temporal_intent,
            patterns,
        ) in temporal_patterns:

            for pattern in patterns:

                if (
                    pattern
                    in normalized_query
                ):
                    return temporal_intent

        return None

    def _detect_aggregation_intent(
        self,
        query: str,
    ) -> str | None:
        """
        Detect the aggregation requested by the user.

        Returns:
            count
            sum
            average
            None
        """

        normalized_query = (
            query.lower().strip()
        )

        # -----------------------------------------
        # COUNT
        # -----------------------------------------

        count_patterns = (
            "count",
            "how many",
            "number of",
        )

        for pattern in count_patterns:

            if pattern in normalized_query:
                return "count"

        # -----------------------------------------
        # AVERAGE
        # -----------------------------------------

        average_patterns = (
            "average",
            "avg",
            "mean",
        )

        for pattern in average_patterns:

            if pattern in normalized_query:
                return "average"

        # -----------------------------------------
        # EXPLICIT SUM / TOTAL
        # -----------------------------------------

        sum_patterns = (
            "sum",
            "total",
        )

        for pattern in sum_patterns:

            if pattern in normalized_query:
                return "sum"

        # -----------------------------------------
        # IMPLICIT BUSINESS METRICS
        #
        # Example:
        #   vehicle wise revenue
        #   customer wise revenue
        #
        # Usually means aggregated revenue
        # grouped by that entity.
        # -----------------------------------------

        additive_metrics = (
            "revenue",
            "amount",
            "cost",
            "expense",
            "expenses",
            "profit",
            "charges",
            "value",
        )

        grouping_patterns = (
            " wise ",
            " per ",
            " by ",
        )

        has_grouping = any(
            pattern in f" {normalized_query} "
            for pattern in grouping_patterns
        )

        has_additive_metric = any(
            metric in normalized_query
            for metric in additive_metrics
        )

        if (
            has_grouping
            and has_additive_metric
        ):
            return "sum"

        return None


    def _extract_grouping_term(
        self,
        query: str,
    ) -> str | None:
        """
        Examples:

        driver wise trip count
            -> driver

        vehicle wise revenue
            -> vehicle

        revenue by customer
            -> customer

        revenue per vehicle
            -> vehicle
        """

        normalized_query = (
            query
            .lower()
            .replace("-", " ")
            .strip()
        )

        words = normalized_query.split()

        for index, word in enumerate(
            words
        ):

            # driver wise
            if (
                word == "wise"
                and index > 0
            ):
                return words[
                    index - 1
                ]

            # by customer
            # per vehicle
            if (
                word in {
                    "by",
                    "per",
                }
                and index + 1 < len(words)
            ):
                return words[
                    index + 1
                ]

        return None

    def _resolve_temporal_range(
    self,
    temporal_intent: str | None,
    reference_date: date | None = None,
) -> tuple[date, date] | None:
        """
        Resolve a temporal intent into:

            start_date inclusive
            end_date exclusive

        Example:
            last_week
            -> 2026-09-14
            -> 2026-09-21

        SQL later:
            column >= start_date
            AND column < end_date
        """

        if temporal_intent is None:
            return None

        current_date = (
            reference_date
            or date.today()
        )

        # Monday = 0
        current_week_start = (
            current_date
            - timedelta(
                days=current_date.weekday()
            )
        )

        if temporal_intent == "today":

            return (
                current_date,
                current_date
                + timedelta(days=1),
            )

        if temporal_intent == "yesterday":

            yesterday = (
                current_date
                - timedelta(days=1)
            )

            return (
                yesterday,
                current_date,
            )

        if temporal_intent == "this_week":

            return (
                current_week_start,
                current_week_start
                + timedelta(days=7),
            )

        if temporal_intent == "last_week":

            previous_week_start = (
                current_week_start
                - timedelta(days=7)
            )

            return (
                previous_week_start,
                current_week_start,
            )

        if temporal_intent == "this_month":

            month_start = current_date.replace(
                day=1
            )

            if month_start.month == 12:

                next_month = date(
                    month_start.year + 1,
                    1,
                    1,
                )

            else:

                next_month = date(
                    month_start.year,
                    month_start.month + 1,
                    1,
                )

            return (
                month_start,
                next_month,
            )

        if temporal_intent == "last_month":

            this_month_start = (
                current_date.replace(
                    day=1
                )
            )

            last_month_end = (
                this_month_start
            )

            previous_day = (
                this_month_start
                - timedelta(days=1)
            )

            last_month_start = (
                previous_day.replace(
                    day=1
                )
            )

            return (
                last_month_start,
                last_month_end,
            )

        if temporal_intent == "this_year":

            return (
                date(
                    current_date.year,
                    1,
                    1,
                ),
                date(
                    current_date.year + 1,
                    1,
                    1,
                ),
            )

        if temporal_intent == "last_year":

            return (
                date(
                    current_date.year - 1,
                    1,
                    1,
                ),
                date(
                    current_date.year,
                    1,
                    1,
                ),
            )

        return None

    def _select_time_column(
    self,
    table_name: str,
    temporal_intent: str | None,
) -> str | None:
        """
        Select the safest business time column
        for a temporal query.

        Returns only a column name.
        Does not calculate date ranges.
        """

        if temporal_intent is None:
            return None

        table = self.graph.get_table(
            table_name
        )

        if table is None:
            return None

        raw_columns = getattr(
            table,
            "columns",
            (),
        )

        if isinstance(
            raw_columns,
            dict,
        ):
            graph_columns = list(
                raw_columns.values()
            )
        else:
            graph_columns = list(
                raw_columns
            )

        candidates: list[
            tuple[int, str]
        ] = []

        # Audit columns should not normally
        # represent the business event date.
        audit_columns = {
            "createdon",
            "modifiedon",
            "created_at",
            "updated_at",
            "createddate",
            "modifieddate",
        }

        for column in graph_columns:

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

            if not column_name:
                continue

            normalized_column = (
                column_name
                .lower()
                .replace("_", "")
            )

            if (
                normalized_column
                in audit_columns
            ):
                continue

            semantic_type = getattr(
                column,
                "semantic_type",
                None,
            )

            business_name = (
                getattr(
                    column,
                    "business_name",
                    None,
                )
                or ""
            )

            normalized_business_name = (
                business_name.lower()
            )

            score = 0

            # -----------------------------------------
            # Prefer true datetime columns
            # -----------------------------------------

            if semantic_type == "datetime":
                score += 100

            elif semantic_type == "date":
                score += 70

            elif semantic_type == "time":
                score += 20

            else:
                continue

            # -----------------------------------------
            # Strong business-event hints
            # -----------------------------------------

            if (
                "trip start"
                in normalized_business_name
            ):
                score += 150

            elif (
                "start date time"
                in normalized_business_name
            ):
                score += 120

            elif (
                "start date"
                in normalized_business_name
            ):
                score += 90

            elif (
                "trip end"
                in normalized_business_name
            ):
                score += 60

            # -----------------------------------------
            # Column-name hints
            # -----------------------------------------

            if (
                "tripstart"
                in normalized_column
            ):
                score += 140

            elif (
                normalized_column
                == "startdate"
            ):
                score += 80

            elif (
                normalized_column
                == "tripendtime"
            ):
                score += 50

            candidates.append(
                (
                    score,
                    column_name,
                )
            )

        if not candidates:
            return None

        candidates.sort(
            key=lambda item: item[0],
            reverse=True,
        )

        (
            score,
            selected_column,
        ) = candidates[0]

        logger.info(
            "Trusted time column selected. "
            "Table=%s Column=%s Score=%s Intent=%s",
            table_name,
            selected_column,
            score,
            temporal_intent,
        )

        return selected_column
    

    def _get_column_metadata(
    self,
    table_name: str,
    column_name: str,
):
        """
        Return trusted schema metadata for one column.
        """

        table = self.graph.get_table(
            table_name
        )

        if table is None:
            return None

        raw_columns = getattr(
            table,
            "columns",
            (),
        )

        if isinstance(
            raw_columns,
            dict,
        ):
            graph_columns = list(
                raw_columns.values()
            )
        else:
            graph_columns = list(
                raw_columns
            )

        for column in graph_columns:

            current_column_name = (
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

            if (
                current_column_name
                == column_name
            ):
                return column

        return None


    def _get_primary_key_column(
        self,
        table_name: str,
    ) -> str | None:
        """
        Return the trusted primary-key column
        for a table.
        """

        table = self.graph.get_table(
            table_name
        )

        if table is None:
            return None

        raw_columns = getattr(
            table,
            "columns",
            (),
        )

        if isinstance(
            raw_columns,
            dict,
        ):
            graph_columns = list(
                raw_columns.values()
            )
        else:
            graph_columns = list(
                raw_columns
            )

        for column in graph_columns:

            is_primary_key = getattr(
                column,
                "is_primary_key",
                False,
            )

            if not is_primary_key:
                continue

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

            if column_name:
                return column_name

        return None

    def _resolve_measure_column(
    self,
    aggregation_type: str,
    query: str,
    anchor_table: str,
    tables: tuple[
        ContextTable,
        ...
    ],
    joins: tuple[
        ContextJoinCondition,
        ...
    ],
) -> str | None:

        # -----------------------------------------
        # COUNT
        # -----------------------------------------

        if aggregation_type == "count":

            return (
                self._get_primary_key_column(
                    anchor_table
                )
            )

        # -----------------------------------------
        # SUM / AVERAGE
        # -----------------------------------------

        anchor_context = next(
            (
                table
                for table in tables
                if (
                    table.table_name
                    == anchor_table
                )
            ),
            None,
        )

        if anchor_context is None:
            return None

        normalized_query = (
            query.lower()
        )

        grouping_term = (
            self._extract_grouping_term(
                query
            )
        )

        join_columns = set(
            self._get_join_columns_for_table(
                table_name=anchor_table,
                joins=joins,
            )
        )

        candidates: list[
            tuple[int, str]
        ] = []

        numeric_types = {
            "INT",
            "INTEGER",
            "BIGINT",
            "SMALLINT",
            "TINYINT",
            "DECIMAL",
            "NUMERIC",
            "FLOAT",
            "DOUBLE",
            "REAL",
        }

        for column in (
            anchor_context.columns
        ):

            column_name = (
                column.column_name
            )

            # Join key should not become
            # SUM/AVG measure.
            if column_name in join_columns:
                continue

            searchable_name = (
                f"{column_name} "
                f"{column.business_name or ''}"
            ).lower()

            if (
                grouping_term
                and grouping_term
                in searchable_name
            ):
                continue

            score = 0

            if (
                column_name.lower()
                in normalized_query
            ):
                score += 100

            for matched_term in (
                column.matched_terms
            ):

                if (
                    matched_term
                    in normalized_query
                ):
                    score += 20

            metadata = (
                self._get_column_metadata(
                    table_name=anchor_table,
                    column_name=column_name,
                )
            )

            if metadata is not None:

                data_type = (
                    getattr(
                        metadata,
                        "data_type",
                        "",
                    )
                    or ""
                ).upper()

                if (
                    data_type
                    in numeric_types
                ):
                    score += 50

            if score > 0:

                candidates.append(
                    (
                        score,
                        column_name,
                    )
                )

        if not candidates:
            return None

        candidates.sort(
            key=lambda item: item[0],
            reverse=True,
        )

        return candidates[0][1]

    def _resolve_group_by_column(
        self,
        query: str,
        anchor_table: str,
        tables: tuple[
            ContextTable,
            ...
        ],
        joins: tuple[
            ContextJoinCondition,
            ...
        ],
    ) -> tuple[
        str | None,
        str | None,
    ]:

        grouping_term = (
            self._extract_grouping_term(
                query
            )
        )

        if grouping_term is None:

            return (
                None,
                None,
            )

        # -----------------------------------------
        # First preference:
        # related entity display column
        #
        # Example:
        # driver -> tdriver.name
        # vehicle -> tvehicle.vehiclenumber
        # customer -> customer.customername
        # -----------------------------------------

        for table in tables:

            if (
                table.table_name
                == anchor_table
            ):
                continue

            searchable_table = (
                f"{table.table_name} "
                f"{table.business_name or ''}"
            ).lower()

            if (
                grouping_term
                not in searchable_table
            ):
                continue

            join_columns = set(
                self._get_join_columns_for_table(
                    table_name=(
                        table.table_name
                    ),
                    joins=joins,
                )
            )

            for column in table.columns:

                # Skip PK/FK join key.
                if (
                    column.column_name
                    in join_columns
                ):
                    continue

                return (
                    table.table_name,
                    column.column_name,
                )

        # -----------------------------------------
        # Fallback:
        # grouping column exists on anchor table
        # -----------------------------------------

        anchor_context = next(
            (
                table
                for table in tables
                if (
                    table.table_name
                    == anchor_table
                )
            ),
            None,
        )

        if anchor_context is not None:

            for column in (
                anchor_context.columns
            ):

                searchable_column = (
                    f"{column.column_name} "
                    f"{column.business_name or ''}"
                ).lower()

                if (
                    grouping_term
                    in searchable_column
                ):

                    return (
                        anchor_table,
                        column.column_name,
                    )

        return (
            None,
            None,
        )

    def _resolve_aggregation_context(
        self,
        query: str,
        aggregation_type: str | None,
        anchor_table: str,
        tables: tuple[
            ContextTable,
            ...
        ],
        joins: tuple[
            ContextJoinCondition,
            ...
        ],
    ) -> AggregationContext | None:

        if aggregation_type is None:
            return None

        measure_column = (
            self._resolve_measure_column(
                aggregation_type=(
                    aggregation_type
                ),
                query=query,
                anchor_table=(
                    anchor_table
                ),
                tables=tables,
                joins=joins,
            )
        )

        if measure_column is None:

            raise ValueError(
                "Unable to resolve trusted "
                f"aggregation measure for "
                f"query: {query}"
            )

        (
            group_by_table,
            group_by_column,
        ) = (
            self._resolve_group_by_column(
                query=query,
                anchor_table=anchor_table,
                tables=tables,
                joins=joins,
            )
        )

        return AggregationContext(
            aggregation_type=(
                aggregation_type
            ),
            measure_table=(
                anchor_table
            ),
            measure_column=(
                measure_column
            ),
            group_by_table=(
                group_by_table
            ),
            group_by_column=(
                group_by_column
            ),
        )


    # =====================================================
    # COLUMN SELECTION
    # =====================================================

    def _select_columns(
        self,
        table_results,
        query: str,
        query_terms: tuple[str, ...],
        table_name: str,
        is_anchor: bool,
        mandatory_join_columns: tuple[
            str,
            ...
        ],
    ) -> tuple[
        ContextColumn,
        ...
    ]:

        selected: list[
            ContextColumn
        ] = []

        seen_columns: set[str] = set()

        normalized_query = (
            query.lower().strip()
        )

        broad_detail_query = (
            "detail" in normalized_query
            or "details" in normalized_query
        )

        normalized_table = (
            table_name
            .lower()
            .replace("_", "")
        )

        table_entity_terms = {
            term
            for term in query_terms
            if (
                len(term) >= 3
                and term.lower()
                in normalized_table
            )
        }

        # ---------------------------------------------
        # Column limit
        # ---------------------------------------------

        if (
            is_anchor
            and broad_detail_query
        ):

            column_limit = (
                self.max_columns_per_table
            )

        elif is_anchor:

            column_limit = min(
                self.max_columns_per_table,
                5,
            )

        else:

            # Related entity tables should not
            # automatically take arbitrary
            # retrieval-ranked columns.
            #
            # They will receive:
            #
            # 1. mandatory JOIN columns
            # 2. safe display columns
            #
            # separately below.
            column_limit = 0

        # =================================================
        # 1. Select retrieval-based columns
        # =================================================

        for result in table_results:

            column_name = (
                result.column_name
            )

            # ---------------------------------------------
            # Skip empty column result
            # ---------------------------------------------

            if not column_name:

                continue

            # ---------------------------------------------
            # Skip duplicate columns
            # ---------------------------------------------

            if (
                column_name
                in seen_columns
            ):

                continue

            # ---------------------------------------------
            # Related tables:
            #
            # Do NOT select arbitrary retrieval columns.
            #
            # Example:
            # tdriver.lasttrip should NOT be selected
            # just because "trip" matched.
            #
            # Related tables will receive:
            #
            # 1. mandatory JOIN columns
            # 2. safe display columns
            #
            # later.
            # ---------------------------------------------

            if not is_anchor:

                continue

            # ---------------------------------------------
            # Anchor table only from here
            # ---------------------------------------------

            matched_terms = tuple(
                result.matched_terms
            )

            matched_term_set = {
                term.lower()
                for term
                in matched_terms
            }

            informative_terms = (
                matched_term_set
                - table_entity_terms
            )

            # ---------------------------------------------
            # Anchor table filtering
            # ---------------------------------------------

            if broad_detail_query:

                pass

            elif not informative_terms:

                continue

            # ---------------------------------------------
            # Add anchor column
            # ---------------------------------------------

            selected.append(
                ContextColumn(

                    table_name=(
                        result.table_name
                    ),

                    column_name=(
                        column_name
                    ),

                    business_name=(
                        result.business_name
                    ),

                    semantic_type=None,

                    retrieval_score=round(
                        float(
                            result.final_score
                        ),
                        4,
                    ),

                    matched_terms=(
                        result.matched_terms
                    ),
                )
            )

            seen_columns.add(
                column_name
            )

            # ---------------------------------------------
            # Anchor column limit
            # ---------------------------------------------

            if (
                len(selected)
                >= column_limit
            ):

                break
        # =================================================
        # 2. ALWAYS ADD TRUSTED JOIN COLUMNS
        #
        # IMPORTANT:
        # This block must be OUTSIDE the loop above.
        # =================================================

        for join_column in (
            mandatory_join_columns
        ):

            if (
                join_column
                in seen_columns
            ):

                continue

            join_result = next(
                (
                    result
                    for result
                    in table_results
                    if (
                        result.column_name
                        == join_column
                    )
                ),
                None,
            )

            if (
                join_result
                is not None
            ):

                selected.append(
                    ContextColumn(

                        table_name=(
                            table_name
                        ),

                        column_name=(
                            join_column
                        ),

                        business_name=(
                            join_result.business_name
                        ),

                        semantic_type=None,

                        retrieval_score=round(
                            float(
                                join_result.final_score
                            ),
                            4,
                        ),

                        matched_terms=(
                            join_result.matched_terms
                        ),
                    )
                )

            else:

                # JoinPathFinder/SchemaGraph confirmed
                # this column even if retrieval did
                # not return the column in top results.

                selected.append(
                    ContextColumn(

                        table_name=(
                            table_name
                        ),

                        column_name=(
                            join_column
                        ),

                        business_name=None,

                        semantic_type=(
                            "identifier"
                        ),

                        retrieval_score=0.0,

                        matched_terms=(),
                    )
                )

            seen_columns.add(
                join_column
            )


            # =================================================
            # Add user-facing display column
            # for related entity tables
            # =================================================

            if not is_anchor:

                display_column = (
                    self._find_display_column(
                        table_name=table_name,
                        query_terms=query_terms,
                        mandatory_join_columns=(
                            mandatory_join_columns
                        ),
                    )
                )

                if (
                    display_column
                    is not None
                ):

                    (
                        display_column_name,
                        display_business_name,
                        display_semantic_type,
                    ) = display_column

                    if (
                        display_column_name
                        not in seen_columns
                    ):

                        selected.append(
                            ContextColumn(
                                table_name=(
                                    table_name
                                ),
                                column_name=(
                                    display_column_name
                                ),
                                business_name=(
                                    display_business_name
                                ),
                                semantic_type=(
                                    display_semantic_type
                                ),
                                retrieval_score=0.0,
                                matched_terms=(),
                            )
                        )

                        seen_columns.add(
                            display_column_name
                        )

        # =================================================
        # 3. RETURN ONLY AFTER JOIN COLUMNS ARE ADDED
        # =================================================

        return tuple(
            selected
        )
    
    def _build_trusted_joins(
        self,
        anchor_table: str,
        selected_table_names: tuple[str, ...],
    ) -> tuple[
        ContextJoinCondition,
        ...
    ]:
        """
        Build trusted JOIN conditions from the
        schema graph.

        Important:

        - No relationship guessing.
        - Only paths already present in SchemaGraph.
        - If multiple equal shortest paths exist,
        stop instead of choosing one silently.
        """

        joins: list[
            ContextJoinCondition
        ] = []

        seen_join_keys: set[
            tuple[
                str,
                str,
                str,
                str,
                str,
            ]
        ] = set()

        for target_table in (
            selected_table_names
        ):

            # Anchor does not need a join
            # to itself.
            if (
                target_table
                == anchor_table
            ):

                continue

            # ---------------------------------------------
            # Find all trusted shortest paths
            # ---------------------------------------------

            search_result = (
                self.join_path_finder
                .find_all_shortest_paths(
                    start_table=anchor_table,
                    end_table=target_table,
                )
            )

            # ---------------------------------------------
            # No trusted path
            # ---------------------------------------------

            if not search_result.paths:

                raise ValueError(
                    "No trusted join path found "
                    f"between '{anchor_table}' "
                    f"and '{target_table}'."
                )

            # ---------------------------------------------
            # Ambiguous path
            #
            # Enterprise rule:
            # do NOT guess.
            # ---------------------------------------------


            # -------------------------------------------------
            # Debug all candidate shortest paths
            # -------------------------------------------------

            if search_result.ambiguous:

                logger.warning(
                    "Ambiguous join paths detected. "
                    "Source=%s Target=%s PathCount=%d",
                    anchor_table,
                    target_table,
                    len(search_result.paths),
                )

                for path_index, path in enumerate(
                    search_result.paths,
                    start=1,
                ):

                    logger.warning(
                        "Candidate Path #%d | Hops=%d",
                        path_index,
                        len(path.steps),
                    )

                    for step in path.steps:

                        logger.warning(
                            "  Relationship=%s",
                            step.relationship_id,
                        )

                        for condition in (
                            step.join_conditions
                        ):

                            logger.warning(
                                "    %s.%s = %s.%s",
                                condition.from_table,
                                condition.from_column,
                                condition.to_table,
                                condition.to_column,
                            )

                raise ValueError(
                    "Multiple equally-short trusted "
                    "join paths found between "
                    f"'{anchor_table}' and "
                    f"'{target_table}'. "
                    "Join path requires review."
                )

            if search_result.ambiguous:

                raise ValueError(
                    "Multiple equally-short trusted "
                    "join paths found between "
                    f"'{anchor_table}' and "
                    f"'{target_table}'. "
                    "Join path requires review."
                )

            join_path = (
                search_result.paths[0]
            )

            # ---------------------------------------------
            # Path may contain multiple steps.
            #
            # Example:
            #
            # trip
            #   ↓
            # tvehicle
            #   ↓
            # fuel
            # ---------------------------------------------

            for step in (
                join_path.steps
            ):

                relationship = (
                    self.graph
                    .get_relationship(
                        step.relationship_id
                    )
                )

                relationship_type = (
                    relationship.relationship_type.value
                    if hasattr(
                        relationship.relationship_type,
                        "value",
                    )
                    else str(
                        relationship.relationship_type
                    )
                )

                cardinality = (
                    step.traversal_cardinality.value
                    if hasattr(
                        step.traversal_cardinality,
                        "value",
                    )
                    else str(
                        step.traversal_cardinality
                    )
                )

                # -----------------------------------------
                # Composite relationships may have
                # multiple join conditions.
                # -----------------------------------------

                for condition in (
                    step.join_conditions
                ):

                    join_key = (
                        step.relationship_id,
                        condition.from_table,
                        condition.from_column,
                        condition.to_table,
                        condition.to_column,
                    )

                    # Same relationship may appear
                    # in multiple requested paths.
                    if (
                        join_key
                        in seen_join_keys
                    ):

                        continue

                    joins.append(
                        ContextJoinCondition(

                            relationship_id=(
                                step.relationship_id
                            ),

                            source_table=(
                                condition.from_table
                            ),

                            source_column=(
                                condition.from_column
                            ),

                            target_table=(
                                condition.to_table
                            ),

                            target_column=(
                                condition.to_column
                            ),

                            relationship_type=(
                                relationship_type
                            ),

                            cardinality=(
                                cardinality
                            ),

                            confidence=round(
                                float(
                                    step.confidence_score
                                ),
                                4,
                            ),
                        )
                    )

                    seen_join_keys.add(
                        join_key
                    )

        return tuple(
            joins
        )

    # LLM CONTEXT
    # =====================================================

    def _build_llm_context(
        self,
        query: str,
        anchor_table: str,
        tables: tuple[
            ContextTable,
            ...
        ],
        joins: tuple[
            ContextJoinCondition,
            ...
        ],
        temporal_filter: (
            TemporalFilterContext
            | None
        ),
        aggregation: (
            AggregationContext
            | None
        ),
    ) -> str:

        lines: list[str] = []

        # =============================================
        # QUESTION
        # =============================================

        lines.append(
            f"User Question: {query}"
        )

        lines.append(
            f"Anchor Table: {anchor_table}"
        )

        lines.append(
            ""
        )

        # =============================================
        # RELEVANT SCHEMA
        # =============================================

        lines.append(
            "Relevant Schema:"
        )

        for table in tables:

            anchor_label = (
                " [ANCHOR]"
                if table.is_anchor
                else ""
            )

            lines.append(
                f"- Table: "
                f"{table.table_name}"
                f"{anchor_label}"
            )

            if (
                table.graph_distance
                is not None
            ):

                lines.append(
                    "  Graph Distance: "
                    f"{table.graph_distance}"
                )

            if table.columns:

                lines.append(
                    "  Relevant Columns:"
                )

                for column in table.columns:

                    matched_text = ""

                    if column.matched_terms:

                        matched_text = (
                            " | matched="
                            + ", ".join(
                                column.matched_terms
                            )
                        )

                    lines.append(
                        "    - "
                        f"{column.column_name}"
                        f"{matched_text}"
                    )

            else:

                lines.append(
                    "  Relevant Columns: None"
                )

        # -------------------------------------------------
        # Temporal filter
        # -------------------------------------------------

        lines.append("")
        lines.append("Temporal Filter:")

        if temporal_filter is None:

            lines.append(
                "  - No temporal filter required."
            )

        else:

            lines.append(
                "  - Intent: "
                f"{temporal_filter.intent}"
            )

            lines.append(
                "  - Column: "
                f"{temporal_filter.table_name}."
                f"{temporal_filter.column_name}"
            )

            lines.append(
                "  - Data Type: "
                f"{temporal_filter.data_type}"
            )

            lines.append(
                "  - Requires Conversion: "
                f"{temporal_filter.requires_conversion}"
            )

            if temporal_filter.stored_format is not None:

                lines.append(
                    "  - Stored Format: "
                    f"{temporal_filter.stored_format}"
                )

            if temporal_filter.mysql_format is not None:

                lines.append(
                    "  - MySQL Format: "
                    f"{temporal_filter.mysql_format}"
                )

            lines.append(
                "  - Start Date Inclusive: "
                f"{temporal_filter.start_date.isoformat()}"
            )

            lines.append(
                "  - End Date Exclusive: "
                f"{temporal_filter.end_date_exclusive.isoformat()}"
            )


        # -------------------------------------------------
        # Aggregation
        # -------------------------------------------------

        lines.append("")
        lines.append("Aggregation:")

        if aggregation is None:

            lines.append(
                "  - No aggregation required."
            )

        else:

            lines.append(
                "  - Type: "
                f"{aggregation.aggregation_type}"
            )

            lines.append(
                "  - Measure: "
                f"{aggregation.measure_table}."
                f"{aggregation.measure_column}"
            )

            if (
                aggregation.group_by_table
                is not None
                and aggregation.group_by_column
                is not None
            ):

                lines.append(
                    "  - Group By: "
                    f"{aggregation.group_by_table}."
                    f"{aggregation.group_by_column}"
                )

            else:

                lines.append(
                    "  - Group By: None"
                )


        # =============================================
        # TRUSTED JOINS
        # =============================================

        lines.append(
            ""
        )

        lines.append(
            "Trusted Joins:"
        )

        if joins:

            for join in joins:

                lines.append(
                    "  - "
                    f"{join.source_table}."
                    f"{join.source_column}"
                    " = "
                    f"{join.target_table}."
                    f"{join.target_column}"
                    f" | relationship="
                    f"{join.relationship_type}"
                    f" | cardinality="
                    f"{join.cardinality}"
                    f" | confidence="
                    f"{join.confidence:.4f}"
                )

        else:

            lines.append(
                "  - No join required."
            )

        return "\n".join(
            lines
        )

