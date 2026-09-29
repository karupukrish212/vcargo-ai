from datetime import datetime
from enum import Enum

from pydantic import BaseModel, ConfigDict, Field

from datetime import date

from pydantic import BaseModel, ConfigDict


class SchemaDocumentType(str, Enum):
    TABLE = "table"
    COLUMN = "column"


class SchemaDocument(BaseModel):
    """
    One searchable schema document.

    This is what we will later convert into an embedding.
    """

    model_config = ConfigDict(frozen=True)

    document_id: str

    document_type: SchemaDocumentType

    schema_hash: str

    table_name: str

    column_name: str | None = None

    business_name: str | None = None

    domain: str | None = None

    semantic_type: str | None = None

    keywords: tuple[str, ...] = ()

    text: str


class SchemaDocumentCatalog(BaseModel):
    """
    Complete document collection for one schema version.
    """

    model_config = ConfigDict(frozen=True)

    document_version: str = "1.0"

    schema_hash: str

    generated_at: datetime

    table_document_count: int = Field(ge=0)

    column_document_count: int = Field(ge=0)

    total_document_count: int = Field(ge=0)

    documents: tuple[SchemaDocument, ...]

class SchemaRetrievalResult(BaseModel):
    """
    One ranked schema retrieval result.
    """

    model_config = ConfigDict(frozen=True)

    rank: int = Field(ge=1)

    document_id: str

    document_type: SchemaDocumentType

    table_name: str

    column_name: str | None = None

    business_name: str | None = None

    semantic_score: float

    lexical_score: float

    final_score: float

    matched_terms: tuple[str, ...] = ()


class SchemaRetrievalResponse(BaseModel):
    """
    Complete retrieval response for one user query.
    """

    model_config = ConfigDict(frozen=True)

    query: str

    normalized_terms: tuple[str, ...]

    results: tuple[
        SchemaRetrievalResult,
        ...
    ]

class GraphAwareRetrievalResult(BaseModel):
    """
    Final schema result after:

    semantic retrieval
        +
    lexical retrieval
        +
    table coherence
        +
    graph proximity
    """

    model_config = ConfigDict(frozen=True)

    rank: int = Field(ge=1)

    document_id: str

    document_type: SchemaDocumentType

    table_name: str

    column_name: str | None = None

    business_name: str | None = None

    semantic_score: float

    lexical_score: float

    hybrid_score: float

    table_coherence_score: float

    graph_score: float

    final_score: float

    graph_distance: int | None = None

    matched_terms: tuple[str, ...] = ()


class GraphAwareRetrievalResponse(BaseModel):
    """
    Final graph-aware retrieval response.
    """

    model_config = ConfigDict(frozen=True)

    query: str

    normalized_terms: tuple[str, ...]

    anchor_table: str

    results: tuple[
        GraphAwareRetrievalResult,
        ...
    ]



class VectorStoreMetadata(BaseModel):
    """
    Metadata stored beside the FAISS index.

    Important because FAISS itself stores vectors,
    but it does not know our schema document IDs.
    """

    model_config = ConfigDict(
        frozen=True
    )

    vector_store_version: str = "1.0"

    schema_hash: str

    embedding_model_name: str

    embedding_dimension: int = Field(
        gt=0
    )

    normalize_embeddings: bool

    document_count: int = Field(
        ge=0
    )

    document_ids: tuple[str, ...] = ()

    generated_at: datetime


class VectorSearchHit(BaseModel):
    """
    One semantic search result returned by FAISS.
    """

    model_config = ConfigDict(
        frozen=True
    )

    rank: int = Field(
        ge=1
    )

    document_position: int = Field(
        ge=0
    )

    document_id: str

    score: float


class ContextColumn(BaseModel):
    """
    Column selected for the final GraphRAG context.
    """

    model_config = ConfigDict(
        frozen=True
    )

    table_name: str

    column_name: str

    business_name: str | None = None

    semantic_type: str | None = None

    retrieval_score: float = 0.0

    matched_terms: tuple[str, ...] = ()


class ContextTable(BaseModel):
    """
    Table selected for the final GraphRAG context.
    """

    model_config = ConfigDict(
        frozen=True
    )

    table_name: str

    business_name: str | None = None

    domain: str | None = None

    is_anchor: bool = False

    graph_distance: int | None = None

    retrieval_score: float = 0.0

    columns: tuple[
        ContextColumn,
        ...
    ] = ()


class ContextJoinCondition(BaseModel):
    """
    Trusted JOIN condition coming from the schema graph.
    """

    model_config = ConfigDict(
        frozen=True
    )

    relationship_id: str

    source_table: str

    source_column: str

    target_table: str

    target_column: str

    relationship_type: str

    cardinality: str | None = None

    confidence: float = 1.0

class TemporalFilterContext(BaseModel):
    model_config = ConfigDict(
        frozen=True
    )

    intent: str

    table_name: str

    column_name: str

    data_type: str

    requires_conversion: bool = False

    stored_format: str | None = None

    mysql_format: str | None = None

    start_date: date

    end_date_exclusive: date


class AggregationContext(BaseModel):
    model_config = ConfigDict(
        frozen=True
    )

    aggregation_type: str

    measure_table: str

    measure_column: str

    group_by_table: str | None = None

    group_by_column: str | None = None


class GraphRAGContext(BaseModel):
    """
    Final structured context that will later be
    passed to the SQL generation LLM.
    """

    model_config = ConfigDict(
        frozen=True
    )

    query: str

    anchor_table: str

    selected_tables: tuple[
        ContextTable,
        ...
    ]

    joins: tuple[
        ContextJoinCondition,
        ...
    ] = ()

    temporal_filter: (
    TemporalFilterContext
    | None
) = None

    aggregation: (
    AggregationContext
    | None
) = None

    llm_context: str

    