import json
import logging
import os
from datetime import datetime, timezone
from pathlib import Path

import faiss
import numpy as np

from app.retrieval.models import (
    SchemaDocumentCatalog,
    VectorSearchHit,
    VectorStoreMetadata,
)


logger = logging.getLogger(__name__)


class VectorStoreError(Exception):
    """
    Base exception for schema vector store.
    """

    pass


class VectorStoreValidationError(
    VectorStoreError
):
    """
    Raised when the FAISS index and
    schema metadata do not match.
    """

    pass


class FaissSchemaVectorStore:
    """
    Persistent FAISS vector store for
    schema documents.

    Build time:

        Schema documents
            ↓
        Embeddings
            ↓
        FAISS IndexFlatIP
            ↓
        Save index + metadata

    Runtime:

        User query
            ↓
        Query embedding
            ↓
        FAISS search
            ↓
        Top schema candidates
    """

    def __init__(
        self,
        index_path: str | Path,
        metadata_path: str | Path,
    ) -> None:

        self.index_path = Path(
            index_path
        )

        self.metadata_path = Path(
            metadata_path
        )

        self.index = None

        self.metadata: (
            VectorStoreMetadata
            | None
        ) = None

    # =====================================================
    # BUILD
    # =====================================================

    def build(
        self,
        catalog: SchemaDocumentCatalog,
        embeddings: np.ndarray,
        embedding_model_name: str,
        normalize_embeddings: bool = True,
    ) -> None:
        """
        Build FAISS index from schema embeddings.
        """

        if not isinstance(
            embeddings,
            np.ndarray,
        ):
            raise TypeError(
                "embeddings must be a numpy array."
            )

        if embeddings.ndim != 2:
            raise VectorStoreValidationError(
                "embeddings must be a 2D matrix."
            )

        document_count = len(
            catalog.documents
        )

        if (
            embeddings.shape[0]
            != document_count
        ):
            raise VectorStoreValidationError(
                "Embedding count does not match "
                "schema document count. "
                f"Embeddings={embeddings.shape[0]} "
                f"Documents={document_count}"
            )

        if document_count == 0:
            raise VectorStoreValidationError(
                "Cannot build FAISS index "
                "with zero documents."
            )

        dimension = int(
            embeddings.shape[1]
        )

        if dimension <= 0:
            raise VectorStoreValidationError(
                "Invalid embedding dimension."
            )

        # ---------------------------------------------
        # FAISS requires float32
        # ---------------------------------------------

        vectors = np.asarray(
            embeddings,
            dtype=np.float32,
        ).copy()

        if not np.all(
            np.isfinite(vectors)
        ):
            raise VectorStoreValidationError(
                "Embeddings contain NaN "
                "or infinite values."
            )

        # ---------------------------------------------
        # Defensive normalization
        #
        # Our EmbeddingService already normalizes,
        # but doing it here guarantees that
        # IndexFlatIP behaves as cosine similarity.
        # ---------------------------------------------

        if normalize_embeddings:

            norms = np.linalg.norm(
                vectors,
                axis=1,
            )

            if np.any(
                norms <= 0
            ):
                raise VectorStoreValidationError(
                    "One or more embeddings "
                    "have zero magnitude."
                )

            faiss.normalize_L2(
                vectors
            )

        # ---------------------------------------------
        # Exact inner-product index
        # ---------------------------------------------

        index = faiss.IndexFlatIP(
            dimension
        )

        index.add(
            vectors
        )

        if (
            index.ntotal
            != document_count
        ):
            raise VectorStoreValidationError(
                "FAISS document count mismatch "
                "after index build."
            )

        document_ids = tuple(
            document.document_id
            for document
            in catalog.documents
        )

        metadata = VectorStoreMetadata(

            vector_store_version="1.0",

            schema_hash=(
                catalog.schema_hash
            ),

            embedding_model_name=(
                embedding_model_name
            ),

            embedding_dimension=(
                dimension
            ),

            normalize_embeddings=(
                normalize_embeddings
            ),

            document_count=(
                document_count
            ),

            document_ids=(
                document_ids
            ),

            generated_at=(
                datetime.now(
                    timezone.utc
                )
            ),
        )

        self.index = index

        self.metadata = metadata

        logger.info(
            "FAISS index built. "
            "Documents=%d Dimension=%d",
            document_count,
            dimension,
        )

    # =====================================================
    # SAVE
    # =====================================================

    def save(
        self,
    ) -> None:
        """
        Persist FAISS index and metadata safely.
        """

        if self.index is None:
            raise VectorStoreError(
                "FAISS index has not been built."
            )

        if self.metadata is None:
            raise VectorStoreError(
                "Vector-store metadata "
                "has not been created."
            )

        self.index_path.parent.mkdir(
            parents=True,
            exist_ok=True,
        )

        self.metadata_path.parent.mkdir(
            parents=True,
            exist_ok=True,
        )

        temp_index_path = (
            self.index_path.with_suffix(
                self.index_path.suffix
                + ".tmp"
            )
        )

        temp_metadata_path = (
            self.metadata_path.with_suffix(
                self.metadata_path.suffix
                + ".tmp"
            )
        )

        # ---------------------------------------------
        # Save FAISS
        # ---------------------------------------------

        faiss.write_index(
            self.index,
            str(
                temp_index_path
            ),
        )

        # ---------------------------------------------
        # Save metadata
        # ---------------------------------------------

        metadata_payload = (
            self.metadata.model_dump(
                mode="json"
            )
        )

        with temp_metadata_path.open(
            "w",
            encoding="utf-8",
        ) as file:

            json.dump(
                metadata_payload,
                file,
                indent=2,
                ensure_ascii=False,
            )

        # ---------------------------------------------
        # Atomic replacement
        # ---------------------------------------------

        os.replace(
            temp_index_path,
            self.index_path,
        )

        os.replace(
            temp_metadata_path,
            self.metadata_path,
        )

        logger.info(
            "FAISS index saved: %s",
            self.index_path,
        )

        logger.info(
            "FAISS metadata saved: %s",
            self.metadata_path,
        )

    # =====================================================
    # LOAD
    # =====================================================

    def load(
        self,
        expected_catalog: (
            SchemaDocumentCatalog
            | None
        ) = None,
    ) -> None:
        """
        Load persisted FAISS index.

        Optionally validate against the
        current schema document catalog.
        """

        if not self.index_path.exists():

            raise FileNotFoundError(
                f"FAISS index not found: "
                f"{self.index_path}"
            )

        if not self.metadata_path.exists():

            raise FileNotFoundError(
                f"FAISS metadata not found: "
                f"{self.metadata_path}"
            )

        index = faiss.read_index(
            str(
                self.index_path
            )
        )

        with self.metadata_path.open(
            "r",
            encoding="utf-8",
        ) as file:

            metadata_payload = json.load(
                file
            )

        metadata = (
            VectorStoreMetadata
            .model_validate(
                metadata_payload
            )
        )

        # ---------------------------------------------
        # Validate stored index
        # ---------------------------------------------

        if (
            index.ntotal
            != metadata.document_count
        ):

            raise VectorStoreValidationError(
                "FAISS index count does not "
                "match metadata document count."
            )

        if (
            index.d
            != metadata.embedding_dimension
        ):

            raise VectorStoreValidationError(
                "FAISS embedding dimension "
                "does not match metadata."
            )

        if (
            len(
                metadata.document_ids
            )
            != metadata.document_count
        ):

            raise VectorStoreValidationError(
                "Document ID mapping count "
                "does not match metadata."
            )

        # ---------------------------------------------
        # Validate against CURRENT catalog
        # ---------------------------------------------

        if expected_catalog is not None:

            if (
                expected_catalog.schema_hash
                != metadata.schema_hash
            ):

                raise VectorStoreValidationError(
                    "Schema hash mismatch. "
                    "FAISS index must be rebuilt."
                )

            current_document_ids = tuple(
                document.document_id
                for document
                in expected_catalog.documents
            )

            if (
                current_document_ids
                != metadata.document_ids
            ):

                raise VectorStoreValidationError(
                    "Schema document IDs changed. "
                    "FAISS index must be rebuilt."
                )

        self.index = index

        self.metadata = metadata

        logger.info(
            "FAISS index loaded. "
            "Documents=%d Dimension=%d "
            "SchemaHash=%s",
            metadata.document_count,
            metadata.embedding_dimension,
            metadata.schema_hash,
        )

    # =====================================================
    # SEARCH
    # =====================================================

    def search(
        self,
        query_embedding: np.ndarray,
        top_k: int = 20,
    ) -> tuple[
        VectorSearchHit,
        ...
    ]:
        """
        Search the persisted FAISS index.
        """

        if self.index is None:
            raise VectorStoreError(
                "FAISS index is not loaded."
            )

        if self.metadata is None:
            raise VectorStoreError(
                "FAISS metadata is not loaded."
            )

        if top_k < 1:
            raise ValueError(
                "top_k must be at least 1."
            )

        query_vector = np.asarray(
            query_embedding,
            dtype=np.float32,
        )

        if query_vector.ndim == 1:

            query_vector = (
                query_vector.reshape(
                    1,
                    -1,
                )
            )

        if (
            query_vector.ndim != 2
            or query_vector.shape[0] != 1
        ):

            raise VectorStoreValidationError(
                "Query embedding must represent "
                "exactly one query."
            )

        if (
            query_vector.shape[1]
            != self.metadata.embedding_dimension
        ):

            raise VectorStoreValidationError(
                "Query embedding dimension "
                "does not match FAISS index."
            )

        query_vector = (
            query_vector.copy()
        )

        if (
            self.metadata
            .normalize_embeddings
        ):

            query_norm = float(
                np.linalg.norm(
                    query_vector
                )
            )

            if query_norm <= 0:

                raise VectorStoreValidationError(
                    "Query embedding has "
                    "zero magnitude."
                )

            faiss.normalize_L2(
                query_vector
            )

        actual_k = min(
            top_k,
            self.metadata.document_count,
        )

        scores, positions = (
            self.index.search(
                query_vector,
                actual_k,
            )
        )

        hits: list[
            VectorSearchHit
        ] = []

        for (
            rank,
            (
                score,
                position,
            ),
        ) in enumerate(
            zip(
                scores[0],
                positions[0],
            ),
            start=1,
        ):

            position = int(
                position
            )

            # FAISS may return -1 when
            # no result exists.
            if position < 0:
                continue

            document_id = (
                self.metadata
                .document_ids[
                    position
                ]
            )

            hits.append(
                VectorSearchHit(

                    rank=rank,

                    document_position=(
                        position
                    ),

                    document_id=(
                        document_id
                    ),

                    score=float(
                        score
                    ),
                )
            )

        return tuple(
            hits
        )

    def score_document_ids(
        self,
        query_embedding: np.ndarray,
        document_ids: set[str],
    ) -> dict[str, float]:
        """
        Calculate semantic similarity scores for
        specific documents already stored in FAISS.

        Important:
        This does NOT re-embed schema documents.

        It reconstructs the existing stored vectors
        from FAISS and compares them with the
        query embedding.
        """

        if self.index is None:
            raise VectorStoreError(
                "FAISS index is not loaded."
            )

        if self.metadata is None:
            raise VectorStoreError(
                "FAISS metadata is not loaded."
            )

        if not document_ids:
            return {}

        # -------------------------------------------------
        # Prepare query vector
        # -------------------------------------------------

        query_vector = np.asarray(
            query_embedding,
            dtype=np.float32,
        )

        if query_vector.ndim == 1:
            query_vector = (
                query_vector.reshape(
                    1,
                    -1,
                )
            )

        if (
            query_vector.ndim != 2
            or query_vector.shape[0] != 1
        ):
            raise VectorStoreValidationError(
                "Query embedding must represent "
                "exactly one query."
            )

        if (
            query_vector.shape[1]
            != self.metadata.embedding_dimension
        ):
            raise VectorStoreValidationError(
                "Query embedding dimension "
                "does not match FAISS index."
            )

        query_vector = (
            query_vector.copy()
        )

        # -------------------------------------------------
        # Normalize query
        # -------------------------------------------------

        if self.metadata.normalize_embeddings:

            query_norm = float(
                np.linalg.norm(
                    query_vector
                )
            )

            if query_norm <= 0:
                raise VectorStoreValidationError(
                    "Query embedding has "
                    "zero magnitude."
                )

            faiss.normalize_L2(
                query_vector
            )

        # -------------------------------------------------
        # document_id -> FAISS position
        # -------------------------------------------------

        position_by_document_id = {
            document_id: position
            for position, document_id
            in enumerate(
                self.metadata.document_ids
            )
        }

        scores: dict[
            str,
            float,
        ] = {}

        # -------------------------------------------------
        # Score only requested documents
        # -------------------------------------------------

        for document_id in document_ids:

            position = (
                position_by_document_id.get(
                    document_id
                )
            )

            if position is None:
                continue

            stored_vector = (
                self.index.reconstruct(
                    position
                )
            )

            stored_vector = np.asarray(
                stored_vector,
                dtype=np.float32,
            )

            semantic_score = float(
                np.dot(
                    query_vector[0],
                    stored_vector,
                )
            )

            scores[
                document_id
            ] = semantic_score

        return scores        