import logging
from typing import Sequence

import numpy as np
from sentence_transformers import SentenceTransformer

from app.core.config import settings


logger = logging.getLogger(__name__)


class EmbeddingServiceError(Exception):
    """
    Base exception for embedding service.
    """

    pass


class EmbeddingService:
    """
    Local embedding service used for schema retrieval.

    Responsibilities:

    - Load embedding model once
    - Embed schema documents
    - Embed user queries
    - Return float32 normalized vectors

    Important:

    The model should NOT be loaded again
    for every user question.

    Later in FastAPI we will create one service
    instance during application startup.
    """

    def __init__(
        self,
        model_name: str | None = None,
        device: str | None = None,
        batch_size: int | None = None,
        normalize_embeddings: bool | None = None,
    ) -> None:

        self.model_name = (
            model_name
            or settings.EMBEDDING_MODEL_NAME
        )

        self.device = (
            device
            or settings.EMBEDDING_DEVICE
        )

        self.batch_size = (
            batch_size
            or settings.EMBEDDING_BATCH_SIZE
        )

        if normalize_embeddings is None:

            self.normalize_embeddings = (
                settings.EMBEDDING_NORMALIZE
            )

        else:

            self.normalize_embeddings = (
                normalize_embeddings
            )

        self._model: SentenceTransformer | None = None

        self._dimension: int | None = None

    # =====================================================
    # MODEL LOADING
    # =====================================================

    def load_model(
        self,
    ) -> None:
        """
        Load embedding model into memory.

        Safe to call multiple times.
        The model is loaded only once per service instance.
        """

        if self._model is not None:
            return

        logger.info(
            "Loading embedding model: %s | device=%s",
            self.model_name,
            self.device,
        )

        try:

            self._model = SentenceTransformer(
                self.model_name,
                device=self.device,
            )

            dimension = (
                self._model
                .get_embedding_dimension()
            )

            if dimension is None:

                raise EmbeddingServiceError(
                    "Unable to determine embedding dimension."
                )

            self._dimension = int(
                dimension
            )

        except Exception as exc:

            self._model = None
            self._dimension = None

            raise EmbeddingServiceError(
                f"Unable to load embedding model "
                f"{self.model_name!r}."
            ) from exc

        logger.info(
            "Embedding model loaded. "
            "Model=%s Dimension=%d",
            self.model_name,
            self._dimension,
        )

    # =====================================================
    # INTERNAL MODEL ACCESS
    # =====================================================

    def _get_model(
        self,
    ) -> SentenceTransformer:

        if self._model is None:
            self.load_model()

        if self._model is None:

            raise EmbeddingServiceError(
                "Embedding model is not available."
            )

        return self._model

    # =====================================================
    # DIMENSION
    # =====================================================

    @property
    def dimension(
        self,
    ) -> int:

        if self._dimension is None:
            self.load_model()

        if self._dimension is None:

            raise EmbeddingServiceError(
                "Embedding dimension is unavailable."
            )

        return self._dimension

    # =====================================================
    # EMBED DOCUMENTS
    # =====================================================

    def embed_documents(
        self,
        texts: Sequence[str],
    ) -> np.ndarray:
        """
        Embed multiple schema documents.

        Output shape:

            (number_of_documents, embedding_dimension)

        Example:

            474 documents
                ↓
            (474, 384)
        """

        if not texts:

            raise ValueError(
                "texts cannot be empty."
            )

        cleaned_texts: list[str] = []

        for index, text in enumerate(
            texts
        ):

            if not isinstance(
                text,
                str,
            ):

                raise TypeError(
                    f"Document at index {index} "
                    f"must be a string."
                )

            clean_text = (
                text.strip()
            )

            if not clean_text:

                raise ValueError(
                    f"Document at index {index} "
                    f"is empty."
                )

            cleaned_texts.append(
                clean_text
            )

        model = self._get_model()

        logger.info(
            "Embedding %d schema documents...",
            len(
                cleaned_texts
            ),
        )

        try:

            embeddings = model.encode(

                cleaned_texts,

                batch_size=(
                    self.batch_size
                ),

                show_progress_bar=(
                    len(cleaned_texts)
                    > self.batch_size
                ),

                convert_to_numpy=True,

                normalize_embeddings=(
                    self.normalize_embeddings
                ),
            )

        except Exception as exc:

            raise EmbeddingServiceError(
                "Failed to embed schema documents."
            ) from exc

        embeddings = np.asarray(
            embeddings,
            dtype=np.float32,
        )

        self._validate_embedding_matrix(
            embeddings=embeddings,
            expected_count=len(
                cleaned_texts
            ),
        )

        logger.info(
            "Schema document embeddings created. "
            "Shape=%s",
            embeddings.shape,
        )

        return embeddings

    # =====================================================
    # EMBED QUERY
    # =====================================================

    def embed_query(
        self,
        query: str,
    ) -> np.ndarray:
        """
        Embed one user question.

        BGE retrieval models work better when
        retrieval instruction is added to queries.

        Documents should NOT receive this instruction.
        """

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

        model = self._get_model()

        # ---------------------------------------------
        # BGE retrieval instruction
        # ---------------------------------------------

        query_instruction = (
            "Represent this sentence for searching "
            "relevant passages: "
        )

        query_for_embedding = (
            query_instruction
            + clean_query
        )

        try:

            embedding = model.encode(

                query_for_embedding,

                convert_to_numpy=True,

                normalize_embeddings=(
                    self.normalize_embeddings
                ),
            )

        except Exception as exc:

            raise EmbeddingServiceError(
                "Failed to embed user query."
            ) from exc

        embedding = np.asarray(
            embedding,
            dtype=np.float32,
        )

        if embedding.ndim != 1:

            raise EmbeddingServiceError(
                "Query embedding must be "
                "one-dimensional."
            )

        if (
            embedding.shape[0]
            != self.dimension
        ):

            raise EmbeddingServiceError(
                "Unexpected query embedding "
                "dimension."
            )

        return embedding
    # =====================================================
    # EMBEDDING MATRIX VALIDATION
    # =====================================================

    def _validate_embedding_matrix(
        self,
        embeddings: np.ndarray,
        expected_count: int,
    ) -> None:

        if embeddings.ndim != 2:

            raise EmbeddingServiceError(
                "Document embedding result "
                "must be a 2D matrix."
            )

        if (
            embeddings.shape[0]
            != expected_count
        ):

            raise EmbeddingServiceError(
                "Embedding document count mismatch."
            )

        if (
            embeddings.shape[1]
            != self.dimension
        ):

            raise EmbeddingServiceError(
                "Unexpected embedding dimension. "
                f"Expected={self.dimension}, "
                f"Received={embeddings.shape[1]}."
            )

        if not np.isfinite(
            embeddings
        ).all():

            raise EmbeddingServiceError(
                "Embedding matrix contains "
                "NaN or infinite values."
            )