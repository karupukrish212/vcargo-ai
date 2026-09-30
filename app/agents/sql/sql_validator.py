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