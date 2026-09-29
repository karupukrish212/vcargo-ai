from enum import Enum
from typing import Any

from pydantic import (
    BaseModel,
    ConfigDict,
    Field,
)

from app.schema.relationships.models import (
    RelationshipCardinality,
    RelationshipGovernance,
    RelationshipNormalization,
    RelationshipProvenance,
    RelationshipSource,
    RelationshipStatus,
    RelationshipTenantScope,
    RelationshipType,
    RelationshipValidation,
)


# =========================================================
# GRAPH ENUMS
# =========================================================


class GraphTraversalDirection(str, Enum):
    """
    Direction used when traversing the runtime graph.

    Important:
    The canonical relationship always remains:

        source -> target

    But graph traversal can happen in either direction.
    """

    SOURCE_TO_TARGET = "source_to_target"

    TARGET_TO_SOURCE = "target_to_source"


# =========================================================
# COLUMN MODEL
# =========================================================


class GraphColumn(BaseModel):
    """
    Runtime representation of one database column.

    This combines:

    - Physical schema information
    - AI/business metadata
    - SQL generation hints

    The model is frozen because the runtime graph
    should be treated as read-only after creation.
    """

    model_config = ConfigDict(
        frozen=True
    )

    name: str

    data_type: str

    nullable: bool | None = None

    business_name: str | None = None

    semantic_type: str | None = None

    description: str | None = None

    synonyms: tuple[str, ...] = ()

    is_primary_key: bool = False

    is_unique: bool = False

    requires_conversion: bool = False

    stored_format: str | None = None

    mysql_format: str | None = None

    comment: str | None = None


# =========================================================
# TABLE MODEL
# =========================================================


class GraphTable(BaseModel):
    """
    Runtime representation of a business table.
    """

    model_config = ConfigDict(
        frozen=True
    )

    name: str

    business_name: str | None = None

    domain: str | None = None

    description: str | None = None

    synonyms: tuple[str, ...] = ()

    retrieval_enabled: bool = True

    columns: tuple[
        GraphColumn,
        ...
    ] = ()

    def get_column(
        self,
        column_name: str,
    ) -> GraphColumn | None:
        """
        Return column by physical database name.
        """

        for column in self.columns:

            if column.name == column_name:
                return column

        return None

    def has_column(
        self,
        column_name: str,
    ) -> bool:
        """
        Check whether table contains a column.
        """

        return (
            self.get_column(
                column_name
            )
            is not None
        )

    def column_names(
        self,
    ) -> tuple[str, ...]:
        """
        Return physical column names.
        """

        return tuple(
            column.name
            for column in self.columns
        )


# =========================================================
# JOIN PAIR
# =========================================================


class GraphJoinPair(BaseModel):
    """
    Represents one join condition.

    Example:

        trip.customer
            =
        customer.customerid

    For tenant-aware relationships:

        trip.orgid
            =
        customer.orgid

    is_tenant_scope=True
    """

    model_config = ConfigDict(
        frozen=True
    )

    source_column: str

    target_column: str

    is_tenant_scope: bool = False


# =========================================================
# RELATIONSHIP MODEL
# =========================================================


class GraphRelationship(BaseModel):
    """
    Runtime graph representation of one
    trusted relationship.

    Only approved relationships should enter
    SchemaGraph.
    """

    model_config = ConfigDict(
        frozen=True
    )

    relationship_id: str

    source_table: str

    source_columns: tuple[
        str,
        ...
    ]

    target_table: str

    target_columns: tuple[
        str,
        ...
    ]

    relationship_type: RelationshipType

    relationship_source: RelationshipSource

    cardinality: RelationshipCardinality

    join_operator: str = "="

    confidence_score: float = Field(
        default=0.0,
        ge=0.0,
        le=1.0,
    )

    status: RelationshipStatus

    description: str | None = None

    normalization: RelationshipNormalization = Field(
        default_factory=RelationshipNormalization
    )

    tenant_scope: RelationshipTenantScope = Field(
        default_factory=RelationshipTenantScope
    )

    governance: RelationshipGovernance = Field(
        default_factory=RelationshipGovernance
    )

    provenance: RelationshipProvenance = Field(
        default_factory=RelationshipProvenance
    )

    validation: RelationshipValidation | None = None

    active: bool = True

    manual_review: dict[str, Any] | None = None

    # =====================================================
    # HELPERS
    # =====================================================

    def connects(
        self,
        table_name: str,
    ) -> bool:
        """
        Return True if relationship touches table.
        """

        return (
            table_name
            == self.source_table

            or table_name
            == self.target_table
        )

    def other_table(
        self,
        table_name: str,
    ) -> str:
        """
        Given one side of a relationship,
        return the other table.

        Example:

            relationship:
                trip -> customer

            input:
                trip

            output:
                customer
        """

        if (
            table_name
            == self.source_table
        ):

            return self.target_table

        if (
            table_name
            == self.target_table
        ):

            return self.source_table

        raise ValueError(
            f"Table {table_name!r} is not part "
            f"of relationship "
            f"{self.relationship_id!r}."
        )

    def traversal_direction(
        self,
        from_table: str,
    ) -> GraphTraversalDirection:
        """
        Tell the graph traversal direction.

        Canonical relationship:

            source -> target

        But graph search may enter from either side.
        """

        if (
            from_table
            == self.source_table
        ):

            return (
                GraphTraversalDirection
                .SOURCE_TO_TARGET
            )

        if (
            from_table
            == self.target_table
        ):

            return (
                GraphTraversalDirection
                .TARGET_TO_SOURCE
            )

        raise ValueError(
            f"Table {from_table!r} is not part "
            f"of relationship "
            f"{self.relationship_id!r}."
        )

    def join_pairs(
        self,
        include_tenant_scope: bool = True,
    ) -> tuple[
        GraphJoinPair,
        ...
    ]:
        """
        Return complete canonical join definition.

        Example:

        trip.branchcode = branch.branchcode

        and if tenant scope enabled:

        trip.orgid = branch.orgid
        """

        pairs: list[
            GraphJoinPair
        ] = []

        for (
            source_column,
            target_column,
        ) in zip(
            self.source_columns,
            self.target_columns,
            strict=True,
        ):

            pairs.append(
                GraphJoinPair(
                    source_column=(
                        source_column
                    ),
                    target_column=(
                        target_column
                    ),
                    is_tenant_scope=False,
                )
            )

        if (
            include_tenant_scope
            and self.tenant_scope.enabled
        ):

            for (
                source_column,
                target_column,
            ) in zip(
                self.tenant_scope.source_columns,
                self.tenant_scope.target_columns,
                strict=True,
            ):

                duplicate = any(
                    pair.source_column
                    == source_column

                    and pair.target_column
                    == target_column

                    for pair in pairs
                )

                if duplicate:
                    continue

                pairs.append(
                    GraphJoinPair(
                        source_column=(
                            source_column
                        ),
                        target_column=(
                            target_column
                        ),
                        is_tenant_scope=True,
                    )
                )

        return tuple(
            pairs
        )


# =========================================================
# NEIGHBOR MODEL
# =========================================================


class GraphNeighbor(BaseModel):
    """
    Represents one adjacent table in the graph.

    Example:

        trip -> customer

    If querying neighbors of trip:

        adjacent_table = customer
        direction = source_to_target
    """

    model_config = ConfigDict(
        frozen=True
    )

    adjacent_table: str

    relationship_id: str

    direction: GraphTraversalDirection


# =========================================================
# GRAPH SUMMARY
# =========================================================


class SchemaGraphSummary(BaseModel):
    """
    Lightweight runtime graph summary.
    """

    model_config = ConfigDict(
        frozen=True
    )

    schema_hash: str

    table_count: int = Field(
        ge=0
    )

    column_count: int = Field(
        ge=0
    )

    relationship_count: int = Field(
        ge=0
    )

    isolated_table_count: int = Field(
        ge=0
    )

# =========================================================
# PATH JOIN CONDITION
# =========================================================


class GraphPathJoinCondition(BaseModel):
    """
    One SQL join condition in traversal direction.

    Example:

        customer.customerid
            =
        trip.customer

    Even though canonical relationship may be:

        trip.customer
            ->
        customer.customerid

    Path traversal can move in either direction.
    """

    model_config = ConfigDict(
        frozen=True
    )

    from_table: str

    from_column: str

    to_table: str

    to_column: str

    operator: str = "="

    is_tenant_scope: bool = False


# =========================================================
# JOIN PATH STEP
# =========================================================


class GraphJoinPathStep(BaseModel):
    """
    One edge/step in a graph join path.

    Example:

        customer
            ↓
        trip
    """

    model_config = ConfigDict(
        frozen=True
    )

    from_table: str

    to_table: str

    relationship_id: str

    direction: GraphTraversalDirection

    canonical_cardinality: RelationshipCardinality

    traversal_cardinality: RelationshipCardinality

    relationship_source: RelationshipSource

    confidence_score: float = Field(
        ge=0.0,
        le=1.0,
    )

    join_conditions: tuple[
        GraphPathJoinCondition,
        ...
    ]


# =========================================================
# COMPLETE JOIN PATH
# =========================================================


class GraphJoinPath(BaseModel):
    """
    Complete trusted path between two tables.

    Example:

        customer
            ↓
        trip
            ↓
        tvehicle
    """

    model_config = ConfigDict(
        frozen=True
    )

    start_table: str

    end_table: str

    tables: tuple[
        str,
        ...
    ]

    steps: tuple[
        GraphJoinPathStep,
        ...
    ]

    hop_count: int = Field(
        ge=0
    )

    minimum_confidence: float = Field(
        default=1.0,
        ge=0.0,
        le=1.0,
    )

    average_confidence: float = Field(
        default=1.0,
        ge=0.0,
        le=1.0,
    )


# =========================================================
# PATH SEARCH RESULT
# =========================================================


class GraphJoinPathSearchResult(BaseModel):
    """
    Result of a shortest-path search.

    More than one path means graph ambiguity.
    """

    model_config = ConfigDict(
        frozen=True
    )

    start_table: str

    end_table: str

    shortest_hop_count: int | None = None

    paths: tuple[
        GraphJoinPath,
        ...
    ] = ()

    ambiguous: bool = False