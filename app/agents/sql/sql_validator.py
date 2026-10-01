import logging
import re

import sqlglot
from sqlglot import exp
from sqlglot.errors import ParseError

from app.retrieval.models import GraphRAGContext


logger = logging.getLogger(__name__)


class SQLValidationError(ValueError):
    """
    Raised when generated SQL violates
    trusted SQL Agent rules.
    """


class SQLValidator:
    """
    Validate LLM-generated SQL before execution.

    Validation rules:
    - exactly one SQL statement
    - SELECT only
    - no subqueries / CTEs
    - no wildcard SELECT *
    - only trusted tables
    - only trusted columns
    - only trusted joins
    """

    def validate(
        self,
        sql: str,
        context: GraphRAGContext,
    ) -> str:

        if not sql or not sql.strip():

            raise SQLValidationError(
                "Generated SQL is empty."
            )

        sql = sql.strip()

        # -------------------------------------------------
        # Dangerous read-side operations
        # -------------------------------------------------

        self._validate_dangerous_patterns(
            sql
        )

        # -------------------------------------------------
        # Parse SQL
        # -------------------------------------------------

        try:

            statements = sqlglot.parse(
                sql,
                read="mysql",
            )

        except ParseError as exc:

            raise SQLValidationError(
                "Generated SQL is not valid MySQL."
            ) from exc

        # -------------------------------------------------
        # Exactly one statement
        # -------------------------------------------------

        if len(statements) != 1:

            raise SQLValidationError(
                "Only one SQL statement is allowed."
            )

        statement = statements[0]

        # -------------------------------------------------
        # SELECT only
        # -------------------------------------------------

        if not isinstance(
            statement,
            exp.Select,
        ):

            raise SQLValidationError(
                "Only SELECT queries are allowed."
            )

        # -------------------------------------------------
        # No CTE
        # -------------------------------------------------

        if any(
            statement.find_all(
                exp.CTE
            )
        ):

            raise SQLValidationError(
                "CTE queries are not allowed."
            )

        # -------------------------------------------------
        # No subqueries
        # -------------------------------------------------

        if any(
            statement.find_all(
                exp.Subquery
            )
        ):

            raise SQLValidationError(
                "Subqueries are not allowed."
            )

        # -------------------------------------------------
        # No SELECT *
        # -------------------------------------------------

        if any(
            statement.find_all(
                exp.Star
            )
        ):

            raise SQLValidationError(
                "Wildcard SELECT * is not allowed."
            )

        # -------------------------------------------------
        # Trusted schema
        # -------------------------------------------------

        allowed_columns = (
            self._build_allowed_columns(
                context
            )
        )

        alias_map = (
            self._validate_tables(
                statement=statement,
                context=context,
            )
        )

        self._validate_columns(
            statement=statement,
            allowed_columns=allowed_columns,
            alias_map=alias_map,
        )

        # -------------------------------------------------
        # Trusted relationships
        # -------------------------------------------------

        self._validate_joins(
            statement=statement,
            context=context,
            alias_map=alias_map,
        )

        # -------------------------------------------------
        # Trusted temporal filter
        # -------------------------------------------------

        self._validate_temporal_filter(
            statement=statement,
            context=context,
            alias_map=alias_map,
        )

        self._validate_where_clause(
            statement=statement,
            context=context,
            alias_map=alias_map,
        )

        # -------------------------------------------------
        # Trusted aggregation
        # -------------------------------------------------

        self._validate_aggregation(
            statement=statement,
            context=context,
            alias_map=alias_map,
        )

        # -------------------------------------------------
        # Normalize SQL
        # -------------------------------------------------

        normalized_sql = statement.sql(
            dialect="mysql"
        )

        logger.info(
            "SQL validation successful. "
            "Query=%r",
            context.query,
        )

        return normalized_sql

    # =====================================================
    # Dangerous pattern validation
    # =====================================================

    @staticmethod
    def _validate_dangerous_patterns(
        sql: str,
    ) -> None:

        forbidden_patterns = (
            r"\bINTO\s+OUTFILE\b",
            r"\bINTO\s+DUMPFILE\b",
            r"\bLOAD_FILE\s*\(",
            r"\bSLEEP\s*\(",
            r"\bBENCHMARK\s*\(",
            r"\bFOR\s+UPDATE\b",
            r"\bLOCK\s+IN\s+SHARE\s+MODE\b",
        )

        for pattern in forbidden_patterns:

            if re.search(
                pattern,
                sql,
                flags=re.IGNORECASE,
            ):

                raise SQLValidationError(
                    "Dangerous SQL operation "
                    "is not allowed."
                )

    # =====================================================
    # Allowed schema
    # =====================================================

    @staticmethod
    def _build_allowed_columns(
        context: GraphRAGContext,
    ) -> dict[str, set[str]]:

        allowed: dict[
            str,
            set[str],
        ] = {}

        for table in context.selected_tables:

            allowed[
                table.table_name.lower()
            ] = {
                column.column_name.lower()
                for column in table.columns
            }

        return allowed

    # =====================================================
    # Table validation
    # =====================================================

    @staticmethod
    def _validate_tables(
        statement: exp.Select,
        context: GraphRAGContext,
    ) -> dict[str, str]:

        allowed_tables = {
            table.table_name.lower()
            for table in context.selected_tables
        }

        alias_map: dict[
            str,
            str,
        ] = {}

        used_tables: set[str] = set()

        for table in statement.find_all(
            exp.Table
        ):

            table_name = (
                table.name.lower()
            )

            if table_name not in allowed_tables:

                raise SQLValidationError(
                    "Untrusted table used: "
                    f"{table.name}"
                )

            used_tables.add(
                table_name
            )

            alias = (
                table.alias_or_name.lower()
            )

            alias_map[
                alias
            ] = table_name

            # Also allow original table name.
            alias_map[
                table_name
            ] = table_name

        if not used_tables:

            raise SQLValidationError(
                "SELECT query must use at least "
                "one trusted table."
            )

        return alias_map

    # =====================================================
    # Column validation
    # =====================================================

    @staticmethod
    def _validate_columns(
        statement: exp.Select,
        allowed_columns: dict[
            str,
            set[str],
        ],
        alias_map: dict[
            str,
            str,
        ],
    ) -> None:

        # SELECT aliases such as:
        #
        # SUM(trip.revenue) AS total_revenue
        #
        # ORDER BY total_revenue
        #
        # should not be treated as physical columns.

        select_aliases = {
            expression.alias.lower()
            for expression
            in statement.expressions
            if expression.alias
        }

        for column in statement.find_all(
            exp.Column
        ):

            column_name = (
                column.name.lower()
            )

            table_reference = (
                column.table.lower()
                if column.table
                else None
            )

            # ---------------------------------------------
            # Qualified column
            # trip.revenue
            # ---------------------------------------------

            if table_reference:

                actual_table = (
                    alias_map.get(
                        table_reference
                    )
                )

                if actual_table is None:

                    raise SQLValidationError(
                        "Unknown table or alias "
                        f"used by column: "
                        f"{column.sql()}"
                    )

                if (
                    column_name
                    not in allowed_columns.get(
                        actual_table,
                        set(),
                    )
                ):

                    raise SQLValidationError(
                        "Untrusted column used: "
                        f"{actual_table}."
                        f"{column.name}"
                    )

                continue

            # ---------------------------------------------
            # SELECT alias
            # ---------------------------------------------

            if column_name in select_aliases:

                continue

            # ---------------------------------------------
            # Unqualified column
            # ---------------------------------------------

            matching_tables = [
                table_name
                for table_name, columns
                in allowed_columns.items()
                if column_name in columns
            ]

            if not matching_tables:

                raise SQLValidationError(
                    "Untrusted column used: "
                    f"{column.name}"
                )

            if len(
                matching_tables
            ) > 1:

                raise SQLValidationError(
                    "Ambiguous unqualified column: "
                    f"{column.name}"
                )

    # =====================================================
    # Join validation
    # =====================================================

    def _validate_joins(
        self,
        statement: exp.Select,
        context: GraphRAGContext,
        alias_map: dict[str, str],
    ) -> None:

        trusted_pairs: set[
            frozenset[str]
        ] = set()

        for join in context.joins:

            left = (
                f"{join.source_table.lower()}."
                f"{join.source_column.lower()}"
            )

            right = (
                f"{join.target_table.lower()}."
                f"{join.target_column.lower()}"
            )

            trusted_pairs.add(
                frozenset(
                    (
                        left,
                        right,
                    )
                )
            )

        for join_expression in (
            statement.find_all(
                exp.Join
            )
        ):

            on_expression = (
                join_expression.args.get(
                    "on"
                )
            )

            if on_expression is None:

                raise SQLValidationError(
                    "JOIN without trusted ON "
                    "condition is not allowed."
                )

            conditions = (
                self._flatten_and_conditions(
                    on_expression
                )
            )

            for condition in conditions:

                if not isinstance(
                    condition,
                    exp.EQ,
                ):

                    raise SQLValidationError(
                        "JOIN conditions must use "
                        "trusted equality relationships."
                    )

                left = condition.left
                right = condition.right

                if not isinstance(
                    left,
                    exp.Column,
                ) or not isinstance(
                    right,
                    exp.Column,
                ):

                    raise SQLValidationError(
                        "JOIN condition must compare "
                        "two trusted columns."
                    )

                left_reference = (
                    self._qualified_column_name(
                        column=left,
                        alias_map=alias_map,
                    )
                )

                right_reference = (
                    self._qualified_column_name(
                        column=right,
                        alias_map=alias_map,
                    )
                )

                relationship = frozenset(
                    (
                        left_reference,
                        right_reference,
                    )
                )

                if (
                    relationship
                    not in trusted_pairs
                ):

                    raise SQLValidationError(
                        "Untrusted JOIN relationship: "
                        f"{left_reference} = "
                        f"{right_reference}"
                    )

    # =====================================================
    # Temporal filter validation
    # =====================================================

    def _validate_temporal_filter(
        self,
        statement: exp.Select,
        context: GraphRAGContext,
        alias_map: dict[str, str],
    ) -> None:

        temporal = context.temporal_filter

        if temporal is None:
            return

        expected_column = (
            f"{temporal.table_name.lower()}."
            f"{temporal.column_name.lower()}"
        )

        start_value = (
            self._format_temporal_boundary(
                temporal.start_date,
                temporal.data_type,
            )
        )

        end_value = (
            self._format_temporal_boundary(
                temporal.end_date_exclusive,
                temporal.data_type,
            )
        )

        start_found = False
        end_found = False

        # ---------------------------------------------
        # >= start boundary
        # ---------------------------------------------

        for condition in statement.find_all(
            exp.GTE
        ):

            if not isinstance(
                condition.left,
                exp.Column,
            ):
                continue

            if not isinstance(
                condition.right,
                exp.Literal,
            ):
                continue

            column_name = (
                self._qualified_column_name(
                    condition.left,
                    alias_map,
                )
            )

            literal_value = (
                str(
                    condition.right.this
                )
            )

            if (
                column_name == expected_column
                and
                literal_value == start_value
            ):
                start_found = True

        # ---------------------------------------------
        # < end boundary
        # ---------------------------------------------

        for condition in statement.find_all(
            exp.LT
        ):

            if not isinstance(
                condition.left,
                exp.Column,
            ):
                continue

            if not isinstance(
                condition.right,
                exp.Literal,
            ):
                continue

            column_name = (
                self._qualified_column_name(
                    condition.left,
                    alias_map,
                )
            )

            literal_value = (
                str(
                    condition.right.this
                )
            )

            if (
                column_name == expected_column
                and
                literal_value == end_value
            ):
                end_found = True

        if not start_found:

            raise SQLValidationError(
                "Trusted temporal start boundary "
                "is missing or incorrect."
            )

        if not end_found:

            raise SQLValidationError(
                "Trusted temporal end boundary "
                "is missing or incorrect."
            )

    # =====================================================
    # WHERE clause validation
    # =====================================================

    def _validate_where_clause(
        self,
        statement: exp.Select,
        context: GraphRAGContext,
        alias_map: dict[str, str],
    ) -> None:

        where_expression = (
            statement.args.get(
                "where"
            )
        )

        temporal = context.temporal_filter

        # -------------------------------------------------
        # No trusted filters exist
        # -------------------------------------------------

        if temporal is None:

            if where_expression is not None:

                raise SQLValidationError(
                    "WHERE clause is not allowed "
                    "because no trusted filter "
                    "exists in GraphRAG context."
                )

            return

        # -------------------------------------------------
        # Temporal filter exists
        # WHERE clause is mandatory
        # -------------------------------------------------

        if where_expression is None:

            raise SQLValidationError(
                "Trusted temporal WHERE clause "
                "is missing."
            )

        conditions = (
            self._flatten_and_conditions(
                where_expression.this
            )
        )

        expected_column = (
            f"{temporal.table_name.lower()}."
            f"{temporal.column_name.lower()}"
        )

        start_value = (
            self._format_temporal_boundary(
                temporal.start_date,
                temporal.data_type,
            )
        )

        end_value = (
            self._format_temporal_boundary(
                temporal.end_date_exclusive,
                temporal.data_type,
            )
        )

        expected_conditions = {
            (
                "gte",
                expected_column,
                start_value,
            ),
            (
                "lt",
                expected_column,
                end_value,
            ),
        }

        actual_conditions: list[
            tuple[str, str, str]
        ] = []

        for condition in conditions:

            # ---------------------------------------------
            # >= condition
            # ---------------------------------------------

            if isinstance(
                condition,
                exp.GTE,
            ):

                operator = "gte"

            # ---------------------------------------------
            # < condition
            # ---------------------------------------------

            elif isinstance(
                condition,
                exp.LT,
            ):

                operator = "lt"

            else:

                raise SQLValidationError(
                    "Untrusted WHERE condition "
                    "detected: "
                    f"{condition.sql(dialect='mysql')}"
                )

            if not isinstance(
                condition.left,
                exp.Column,
            ):

                raise SQLValidationError(
                    "WHERE condition must use "
                    "a trusted column."
                )

            if not isinstance(
                condition.right,
                exp.Literal,
            ):

                raise SQLValidationError(
                    "WHERE condition must use "
                    "a trusted literal value."
                )

            column_name = (
                self._qualified_column_name(
                    condition.left,
                    alias_map,
                )
            )

            literal_value = str(
                condition.right.this
            )

            actual_conditions.append(
                (
                    operator,
                    column_name,
                    literal_value,
                )
            )

        # -------------------------------------------------
        # Exactly the trusted temporal predicates only
        # -------------------------------------------------

        if len(actual_conditions) != 2:

            raise SQLValidationError(
                "Unexpected WHERE conditions "
                "detected. Only trusted temporal "
                "conditions are allowed."
            )

        if set(actual_conditions) != expected_conditions:

            raise SQLValidationError(
                "WHERE clause does not exactly match "
                "the trusted GraphRAG temporal filter."
            )

    @staticmethod
    def _format_temporal_boundary(
        value,
        data_type: str,
    ) -> str:

        normalized_type = (
            data_type
            .strip()
            .upper()
        )

        if normalized_type in {
            "DATETIME",
            "TIMESTAMP",
        }:

            return (
                f"{value.isoformat()} "
                "00:00:00.000000"
            )

        return value.isoformat()

    # =====================================================
    # Aggregation validation
    # =====================================================

    def _validate_aggregation(
        self,
        statement: exp.Select,
        context: GraphRAGContext,
        alias_map: dict[str, str],
    ) -> None:

        aggregation = context.aggregation

        if aggregation is None:
            return

        expected_measure = (
            f"{aggregation.measure_table.lower()}."
            f"{aggregation.measure_column.lower()}"
        )

        aggregation_type = (
            aggregation
            .aggregation_type
            .lower()
        )

        aggregate_class = None

        if aggregation_type == "sum":
            aggregate_class = exp.Sum

        elif aggregation_type == "count":
            aggregate_class = exp.Count

        elif aggregation_type == "average":
            aggregate_class = exp.Avg

        else:

            raise SQLValidationError(
                "Unsupported trusted aggregation: "
                f"{aggregation_type}"
            )

        aggregate_found = False

        for aggregate_expression in (
            statement.find_all(
                aggregate_class
            )
        ):

            measure = (
                aggregate_expression.this
            )

            if not isinstance(
                measure,
                exp.Column,
            ):
                continue

            actual_measure = (
                self._qualified_column_name(
                    measure,
                    alias_map,
                )
            )

            if actual_measure == expected_measure:

                aggregate_found = True
                break

        if not aggregate_found:

            raise SQLValidationError(
                "Generated SQL does not use "
                "the trusted aggregation measure: "
                f"{aggregation_type.upper()}"
                f"({expected_measure})"
            )

        # ---------------------------------------------
        # GROUP BY validation
        # ---------------------------------------------

        if (
            aggregation.group_by_table is None
            or
            aggregation.group_by_column is None
        ):
            return

        expected_group_by = (
            f"{aggregation.group_by_table.lower()}."
            f"{aggregation.group_by_column.lower()}"
        )

        group_expression = (
            statement.args.get(
                "group"
            )
        )

        if group_expression is None:

            raise SQLValidationError(
                "Trusted GROUP BY column "
                "is missing."
            )

        group_by_found = False

        for expression in (
            group_expression.expressions
        ):

            if not isinstance(
                expression,
                exp.Column,
            ):
                continue

            actual_group_by = (
                self._qualified_column_name(
                    expression,
                    alias_map,
                )
            )

            if (
                actual_group_by
                == expected_group_by
            ):

                group_by_found = True
                break

        if not group_by_found:

            raise SQLValidationError(
                "Generated SQL does not use "
                "the trusted GROUP BY column: "
                f"{expected_group_by}"
            )

    # =====================================================
    # Flatten JOIN conditions
    # =====================================================

    @classmethod
    def _flatten_and_conditions(
        cls,
        expression: exp.Expression,
    ) -> list[exp.Expression]:

        if isinstance(
            expression,
            exp.And,
        ):

            return (
                cls._flatten_and_conditions(
                    expression.left
                )
                +
                cls._flatten_and_conditions(
                    expression.right
                )
            )

        return [
            expression
        ]

    # =====================================================
    # Resolve qualified column
    # =====================================================

    @staticmethod
    def _qualified_column_name(
        column: exp.Column,
        alias_map: dict[str, str],
    ) -> str:

        if not column.table:

            raise SQLValidationError(
                "JOIN columns must be "
                "fully qualified."
            )

        table_reference = (
            column.table.lower()
        )

        actual_table = (
            alias_map.get(
                table_reference
            )
        )

        if actual_table is None:

            raise SQLValidationError(
                "Unknown table alias in JOIN: "
                f"{column.table}"
            )

        return (
            f"{actual_table}."
            f"{column.name.lower()}"
        )