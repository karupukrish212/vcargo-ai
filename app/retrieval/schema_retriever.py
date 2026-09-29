import logging
import re
from typing import Sequence

import numpy as np

from app.retrieval.vector_store import (
    FaissSchemaVectorStore,
)

from app.retrieval.embedding_service import (
    EmbeddingService,
)

from app.retrieval.models import (
    SchemaDocument,
    SchemaDocumentType,
    SchemaRetrievalResponse,
    SchemaRetrievalResult,
)


logger = logging.getLogger(__name__)


class SchemaRetrieverError(Exception):
    """
    Base exception for schema retrieval.
    """

    pass


class HybridSchemaRetriever:
    """
    Hybrid schema retriever.

    Combines:

    1. Semantic embedding similarity
    2. Exact table name matching
    3. Exact column name matching
    4. Business name matching
    5. Synonym / keyword matching


    Why hybrid?

    Semantic models understand meaning well,
    but exact business terms such as:

        revenue
        vehicle
        customer

    should receive additional deterministic weight.
    """

    DEFAULT_SEMANTIC_WEIGHT = 0.75
    DEFAULT_LEXICAL_WEIGHT = 0.25

    DEFAULT_SEMANTIC_CANDIDATES = 50
    DEFAULT_LEXICAL_CANDIDATES = 30

    # -----------------------------------------------------
    # Words that normally describe filters / request style,
    # not database entities.
    # -----------------------------------------------------

    QUERY_STOP_WORDS = {
        "a",
        "an",
        "the",
        "show",
        "give",
        "get",
        "find",
        "display",
        "list",
        "please",

        "wise",
        "by",

        "last",
        "this",
        "previous",
        "current",

        "today",
        "yesterday",
        "tomorrow",

        "day",
        "days",
        "week",
        "weeks",
        "month",
        "months",
        "year",
        "years",

        "count",
        "counts",
        "detail",
        "details",
    }

    def __init__(
    self,
    documents: Sequence[SchemaDocument],
    vector_store: FaissSchemaVectorStore,
    embedding_service: EmbeddingService,
    semantic_weight: float = DEFAULT_SEMANTIC_WEIGHT,
    lexical_weight: float = DEFAULT_LEXICAL_WEIGHT,
) -> None:

        # -------------------------------------------------
        # Validate documents
        # -------------------------------------------------

        if not documents:

            raise ValueError(
                "documents cannot be empty."
            )

        # -------------------------------------------------
        # Validate FAISS vector store
        # -------------------------------------------------

        if vector_store.index is None:

            raise ValueError(
                "FAISS vector store index "
                "is not loaded."
            )

        if vector_store.metadata is None:

            raise ValueError(
                "FAISS vector store metadata "
                "is not loaded."
            )

        # -------------------------------------------------
        # Validate document count
        # -------------------------------------------------

        if (
            len(documents)
            != vector_store.metadata.document_count
        ):

            raise ValueError(
                "Document count does not match "
                "FAISS vector store document count."
            )

        # -------------------------------------------------
        # Validate embedding dimension
        # -------------------------------------------------

        if (
            vector_store.metadata.embedding_dimension
            != embedding_service.dimension
        ):

            raise ValueError(
                "Embedding dimension mismatch "
                "between FAISS index and "
                "embedding model."
            )

        # -------------------------------------------------
        # Validate document ID mapping
        # -------------------------------------------------

        document_ids = tuple(
            document.document_id
            for document in documents
        )

        if (
            document_ids
            != vector_store.metadata.document_ids
        ):

            raise ValueError(
                "Schema document IDs do not match "
                "FAISS vector store metadata."
            )

        # -------------------------------------------------
        # Validate retrieval weights
        # -------------------------------------------------

        if semantic_weight < 0:

            raise ValueError(
                "semantic_weight cannot be negative."
            )

        if lexical_weight < 0:

            raise ValueError(
                "lexical_weight cannot be negative."
            )

        total_weight = (
            semantic_weight
            + lexical_weight
        )

        if total_weight <= 0:

            raise ValueError(
                "At least one retrieval weight "
                "must be greater than zero."
            )

        # -------------------------------------------------
        # Normalize weights
        # -------------------------------------------------

        self.semantic_weight = (
            semantic_weight
            / total_weight
        )

        self.lexical_weight = (
            lexical_weight
            / total_weight
        )

        # -------------------------------------------------
        # Store documents
        # -------------------------------------------------

        self.documents = tuple(
            documents
        )

        # -------------------------------------------------
        # Store FAISS vector store
        # -------------------------------------------------

        self.vector_store = (
            vector_store
        )

        # -------------------------------------------------
        # Store embedding service
        # -------------------------------------------------

        self.embedding_service = (
            embedding_service
        )

        # -------------------------------------------------
        # Fast document lookup
        #
        # document_id -> SchemaDocument
        # -------------------------------------------------

        self.document_by_id = {
            document.document_id: document
            for document in self.documents
        }
    # =====================================================
    # SEARCH
    # =====================================================

    def search(
        self,
        query: str,
        top_k: int = 10,
        semantic_candidates: int | None = None,
        lexical_candidates: int | None = None,
    ) -> SchemaRetrievalResponse:
        """
        Perform hybrid schema retrieval using:

        1. FAISS semantic search
        2. Lexical exact/business-term search
        3. Hybrid reranking
        """

        # =====================================================
        # BASIC VALIDATION
        # =====================================================

        if not isinstance(
            query,
            str,
        ):
            raise TypeError(
                "query must be a string."
            )

        clean_query = query.strip()

        if not clean_query:
            raise ValueError(
                "query cannot be empty."
            )

        if top_k < 1:
            raise ValueError(
                "top_k must be at least 1."
            )

        semantic_candidate_count = (
            semantic_candidates
            or self.DEFAULT_SEMANTIC_CANDIDATES
        )

        lexical_candidate_count = (
            lexical_candidates
            or self.DEFAULT_LEXICAL_CANDIDATES
        )

        # =====================================================
        # STEP 1
        # QUERY TERMS
        # =====================================================

        query_terms = (
            self._extract_query_terms(
                clean_query
            )
        )

        # =====================================================
        # STEP 2
        # QUERY EMBEDDING
        #
        # IMPORTANT:
        # Only the USER QUERY is embedded here.
        #
        # Schema documents are already embedded
        # inside the FAISS index.
        # =====================================================

        query_embedding = (
            self.embedding_service
            .embed_query(
                clean_query
            )
        )

        # =====================================================
        # STEP 3
        # FAISS SEMANTIC SEARCH
        # =====================================================

        semantic_candidate_count = min(
            semantic_candidate_count,
            len(
                self.documents
            ),
        )

        semantic_hits = (
            self.vector_store.search(
                query_embedding=(
                    query_embedding
                ),
                top_k=(
                    semantic_candidate_count
                ),
            )
        )

        # -----------------------------------------------------
        # document_id -> semantic score
        # -----------------------------------------------------

        semantic_scores_by_id: dict[
            str,
            float,
        ] = {
            hit.document_id: float(
                hit.score
            )
            for hit in semantic_hits
        }

        semantic_candidate_ids = set(
            semantic_scores_by_id.keys()
        )

        # =====================================================
        # STEP 4
        # LEXICAL SEARCH
        #
        # This is lightweight text matching.
        #
        # Example:
        #
        # query = "trip invoice tax amount"
        #
        # exact terms:
        # trip
        # invoice
        # tax
        # amount
        # =====================================================

        lexical_results: list[
            tuple[
                str,
                float,
                tuple[str, ...],
            ]
        ] = []

        for document in self.documents:

            (
                lexical_score,
                matched_terms,
            ) = self._calculate_lexical_score(
                document=document,
                query_terms=query_terms,
            )

            # Only keep actual lexical matches
            if lexical_score > 0:

                lexical_results.append(
                    (
                        document.document_id,
                        float(
                            lexical_score
                        ),
                        matched_terms,
                    )
                )

        # =====================================================
        # STEP 5
        # SORT LEXICAL CANDIDATES
        # =====================================================

        lexical_results.sort(
            key=lambda item: (
                item[1]
            ),
            reverse=True,
        )

        lexical_candidate_count = min(
            lexical_candidate_count,
            len(
                lexical_results
            ),
        )

        lexical_results = (
            lexical_results[
                :lexical_candidate_count
            ]
        )

        # -----------------------------------------------------
        # document_id -> lexical score
        # -----------------------------------------------------

        lexical_scores_by_id: dict[
            str,
            float,
        ] = {
            document_id: lexical_score
            for (
                document_id,
                lexical_score,
                _,
            ) in lexical_results
        }

        # -----------------------------------------------------
        # document_id -> matched query terms
        # -----------------------------------------------------

        matched_terms_by_id: dict[
            str,
            tuple[str, ...],
        ] = {
            document_id: matched_terms
            for (
                document_id,
                _,
                matched_terms,
            ) in lexical_results
        }

        lexical_candidate_ids = set(
            lexical_scores_by_id.keys()
        )

        # =====================================================
        # STEP 6
        # SCORE LEXICAL-ONLY CANDIDATES SEMANTICALLY
        #
        # FAISS Top-K may not contain every important
        # exact lexical match.
        #
        # Example:
        #
        # trip.vehicle may be found lexically,
        # even if it is outside FAISS semantic Top-50.
        #
        # We calculate its semantic score using the
        # vector already stored in FAISS.
        #
        # No document re-embedding happens here.
        # =====================================================

        lexical_only_ids = (
            lexical_candidate_ids
            - semantic_candidate_ids
        )

        if lexical_only_ids:

            additional_semantic_scores = (
                self.vector_store
                .score_document_ids(
                    query_embedding=(
                        query_embedding
                    ),
                    document_ids=(
                        lexical_only_ids
                    ),
                )
            )

            semantic_scores_by_id.update(
                additional_semantic_scores
            )

        # =====================================================
        # STEP 6
        # COMBINE CANDIDATES
        #
        # FAISS semantic candidates
        #       +
        # lexical candidates
        #
        # Example:
        #
        # FAISS:
        #   trip.revenue
        #   trip
        #
        # Lexical:
        #   trip.vehicle
        #   tvehicle
        #
        # Final candidates:
        #   all four
        # =====================================================

        candidate_ids = (
            semantic_candidate_ids
            |
            lexical_candidate_ids
        )

        # =====================================================
        # STEP 7
        # HYBRID RERANKING
        # =====================================================

        ranked: list[
            tuple[
                str,
                float,
                float,
                float,
            ]
        ] = []

        for document_id in candidate_ids:

            semantic_score = float(
                semantic_scores_by_id.get(
                    document_id,
                    0.0,
                )
            )

            lexical_score = float(
                lexical_scores_by_id.get(
                    document_id,
                    0.0,
                )
            )

            final_score = (
                self.semantic_weight
                * semantic_score

                +

                self.lexical_weight
                * lexical_score
            )

            ranked.append(
                (
                    document_id,
                    semantic_score,
                    lexical_score,
                    final_score,
                )
            )

        # =====================================================
        # STEP 8
        # SORT FINAL RESULTS
        # =====================================================

        ranked.sort(
            key=lambda item: (
                item[3],  # final score
                item[2],  # lexical score
                item[1],  # semantic score
            ),
            reverse=True,
        )

        ranked = ranked[
            :top_k
        ]

        # =====================================================
        # STEP 9
        # BUILD RESPONSE
        # =====================================================

        results: list[
            SchemaRetrievalResult
        ] = []

        for rank, (
            document_id,
            semantic_score,
            lexical_score,
            final_score,
        ) in enumerate(
            ranked,
            start=1,
        ):

            document = (
                self.document_by_id[
                    document_id
                ]
            )

            results.append(
                SchemaRetrievalResult(

                    rank=rank,

                    document_id=(
                        document.document_id
                    ),

                    document_type=(
                        document.document_type
                    ),

                    table_name=(
                        document.table_name
                    ),

                    column_name=(
                        document.column_name
                    ),

                    business_name=(
                        document.business_name
                    ),

                    semantic_score=round(
                        semantic_score,
                        4,
                    ),

                    lexical_score=round(
                        lexical_score,
                        4,
                    ),

                    final_score=round(
                        final_score,
                        4,
                    ),

                    matched_terms=(
                        matched_terms_by_id.get(
                            document_id,
                            (),
                        )
                    ),
                )
            )

        # =====================================================
        # LOGGING
        # =====================================================

        logger.info(
            "Hybrid retrieval completed. "
            "Query=%r Terms=%s "
            "SemanticCandidates=%d "
            "LexicalCandidates=%d "
            "Results=%d",
            clean_query,
            query_terms,
            len(
                semantic_candidate_ids
            ),
            len(
                lexical_candidate_ids
            ),
            len(
                results
            ),
        )

        # =====================================================
        # FINAL RESPONSE
        # =====================================================

        return SchemaRetrievalResponse(

            query=clean_query,

            normalized_terms=(
                query_terms
            ),

            results=tuple(
                results
            ),
        )
    # =====================================================
    # QUERY TERM EXTRACTION
    # =====================================================

    @classmethod
    def _extract_query_terms(
        cls,
        query: str,
    ) -> tuple[str, ...]:
        """
        Convert query into meaningful schema terms.

        Example:

            "last week vehicle wise revenue"

        becomes:

            ("vehicle", "revenue")
        """

        tokens = re.findall(
            r"[a-zA-Z0-9_]+",
            query.lower(),
        )

        output: list[str] = []

        seen: set[str] = set()

        for token in tokens:

            token = token.strip()

            if not token:

                continue

            if (
                token
                in cls.QUERY_STOP_WORDS
            ):

                continue

            if token in seen:

                continue

            seen.add(
                token
            )

            output.append(
                token
            )

        return tuple(
            output
        )

    # =====================================================
    # LEXICAL SCORE
    # =====================================================

    @classmethod
    def _calculate_lexical_score(
        cls,
        document: SchemaDocument,
        query_terms: tuple[str, ...],
    ) -> tuple[
        float,
        tuple[str, ...],
    ]:
        """
        Calculate deterministic business/schema
        term matching score.

        Highest priority:
            exact physical column match

        Then:
            exact table match
            business name match
            keywords / synonyms
        """

        if not query_terms:

            return (
                0.0,
                (),
            )

        table_name = (
            document.table_name
            .lower()
            .strip()
        )

        column_name = (
            document.column_name
            .lower()
            .strip()
            if document.column_name
            else None
        )

        business_name = (
            document.business_name
            .lower()
            .strip()
            if document.business_name
            else ""
        )

        semantic_type = (
            document.semantic_type
            .lower()
            .strip()
            if document.semantic_type
            else ""
        )

        keyword_values = {
            keyword.lower().strip()
            for keyword
            in document.keywords
            if keyword.strip()
        }

        business_tokens = set(
            re.findall(
                r"[a-zA-Z0-9_]+",
                business_name,
            )
        )

        matched_terms: list[str] = []

        term_scores: list[float] = []

        # for term in query_terms:

        #     score = 0.0

        #     # ---------------------------------------------
        #     # Exact physical column match
        #     # ---------------------------------------------

        #     if (
        #         column_name
        #         and term == column_name
        #     ):

        #         score = max(
        #             score,
        #             1.0,
        #         )

        #     # Compound column-name matching
        #     #
        #     # Examples:
        #     # tax -> taxamount
        #     # amount -> taxamount

        #     if (
        #         column_name
        #         and len(term) >= 3
        #         and (
        #             column_name.startswith(term)
        #             or column_name.endswith(term)
        #         )
        #     ):
        #         score = max(
        #             score,
        #             0.80,
        #         )

        #     # ---------------------------------------------
        #     # Exact table name match
        #     # ---------------------------------------------

        #     if term == table_name:

        #         if (
        #             document.document_type
        #             == SchemaDocumentType.TABLE
        #         ):

        #             score = max(
        #                 score,
        #                 0.95,
        #             )

        #         else:

        #             # Column belongs to this table,
        #             # but the query did not necessarily
        #             # ask for this particular column.
        #             score = max(
        #                 score,
        #                 0.30,
        #             )

        #     # ---------------------------------------------
        #     # Useful table-name containment
        #     #
        #     # Example:
        #     #
        #     # tvehicle
        #     # contains vehicle
        #     # ---------------------------------------------

        #         if (
        #             len(term) >= 4
        #             and term in table_name
        #         ):

        #             if (
        #                 document.document_type
        #                 == SchemaDocumentType.TABLE
        #             ):

        #                 score = max(
        #                     score,
        #                     0.85,
        #                 )

        #             else:

        #                 score = max(
        #                     score,
        #                     0.25,
        #                 )

        #     # ---------------------------------------------
        #     # Business name token
        #     # ---------------------------------------------

        #     if term in business_tokens:

        #         score = max(
        #             score,
        #             0.90,
        #         )

        #      # 8. Safe token-level keyword match
        #     if any(
        #         term in tokens
        #         for tokens in keyword_token_sets
        #     ):
        #         score = max(
        #             score,
        #             0.75,
        #         )

        #     if score > 0:
        #         matched_terms.append(
        #             term
        #         )

        #         term_scores.append(
        #             score
        #         )

        keyword_values = {
            keyword.lower().strip()
            for keyword in document.keywords
            if keyword.strip()
        }

        business_tokens = set(
            re.findall(
                r"[a-zA-Z0-9_]+",
                business_name,
            )
        )

        # IMPORTANT:
        # This must be outside any if-block
        # and before:
        # for term in query_terms:

        keyword_token_sets = [
            set(
                re.findall(
                    r"[a-zA-Z0-9]+",
                    keyword.lower(),
                )
            )
            for keyword in keyword_values
        ]

        for term in query_terms:

            score = 0.0

            # 1. Exact physical column match
            if (
                column_name
                and term == column_name
            ):
                score = max(
                    score,
                    1.0,
                )

            # 2. Compound column-name match
            if (
                column_name
                and len(term) >= 3
                and (
                    column_name.startswith(term)
                    or column_name.endswith(term)
                )
            ):
                score = max(
                    score,
                    0.80,
                )

            # 3. Semantic type weak support
            if (
                semantic_type
                and term == semantic_type
            ):
                score = max(
                    score,
                    0.45,
                )

            # 4. Exact table-name match
            if term == table_name:

                if (
                    document.document_type
                    == SchemaDocumentType.TABLE
                ):
                    score = max(
                        score,
                        0.95,
                    )

                else:
                    score = max(
                        score,
                        0.30,
                    )

            # 5. Table-name containment
            if (
                len(term) >= 4
                and term in table_name
            ):

                if (
                    document.document_type
                    == SchemaDocumentType.TABLE
                ):
                    score = max(
                        score,
                        0.85,
                    )

                else:
                    score = max(
                        score,
                        0.25,
                    )

            # 6. Business-name token match
            if term in business_tokens:
                score = max(
                    score,
                    0.90,
                )

            # 7. Exact keyword/synonym match
            if term in keyword_values:
                score = max(
                    score,
                    0.90,
                )

            # 8. Safe token-level keyword match
            if any(
                term in tokens
                for tokens in keyword_token_sets
            ):
                score = max(
                    score,
                    0.75,
                )

            if score > 0:
                matched_terms.append(
                    term
                )

                term_scores.append(
                    score
                )

            # ---------------------------------------------
            # Exact keyword / synonym
            # ---------------------------------------------

            if term in keyword_values:

                score = max(
                    score,
                    0.90,
                )

            # ---------------------------------------------
            # Keyword phrase contains query term
            # ---------------------------------------------

            keyword_token_sets = [
                set(
                    re.findall(
                        r"[a-zA-Z0-9]+",
                        keyword.lower(),
                    )
                )
                for keyword in keyword_values
            ]

            if any(
                term in tokens
                for tokens in keyword_token_sets
            ):
                score = max(
                    score,
                    0.75,
                )

            if score > 0:

                matched_terms.append(
                    term
                )

                term_scores.append(
                    score
                )

        if not term_scores:

            return (
                0.0,
                (),
            )

        # -------------------------------------------------
        # Reward both:
        #
        # 1. Match strength
        # 2. Query term coverage
        #
        # vehicle + revenue matched is better
        # than revenue alone.
        # -------------------------------------------------

        average_strength = (
            sum(
                term_scores
            )
            / len(
                term_scores
            )
        )

        coverage = (
            len(
                set(
                    matched_terms
                )
            )
            / len(
                query_terms
            )
        )

        lexical_score = (
            0.65
            * average_strength
            +
            0.35
            * coverage
        )

        lexical_score = min(
            lexical_score,
            1.0,
        )

        return (
            lexical_score,
            tuple(
                dict.fromkeys(
                    matched_terms
                )
            ),
        )