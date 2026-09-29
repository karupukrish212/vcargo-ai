import logging

from app.agents.router.models import (
    AgentRoutingDecision,
    AgentRoutingRequest,
    AgentRoutingResult,
    AgentType,
)


logger = logging.getLogger(__name__)


class AgentRouterError(Exception):
    """
    Base exception for the agent router.
    """

    pass


class AgentRouter:
    """
    Rule-based agent router.

    Decides whether a user query should be handled by:

    1. SQL agent
        followed by the PDF agent for data questions

    2. PDF agent
        document / file / upload questions

    3. Booking agent
        reservation / schedule / slot questions

    Routing is deterministic and keyword scored:

    - booking_score
    - pdf_score

    The SQL agent is the default/fallback
    because the VCargo assistant is primarily
    a data assistant.

    Important:

    A future LLM-based router can replace these
    rules without changing the public interface.
    """

    DEFAULT_BOOKING_THRESHOLD = 0.40

    DEFAULT_PDF_THRESHOLD = 0.40

    DEFAULT_SQL_CONFIDENCE = 0.85

    # =====================================================
    # BOOKING SIGNALS
    #
    # Used when the user wants to reserve a vehicle,
    # driver, branch or a service slot.
    # =====================================================

    BOOKING_SIGNALS = (
        "book",
        "booked",
        "booking",
        "reservation",
        "reserve",
        "slot",
        "appointment",
        "schedule a",
        "set up a booking",
        "cancel my booking",
    )

    # =====================================================
    # PDF / DOCUMENT SIGNALS
    #
    # Used when the user asks about uploaded documents,
    # PDF content, licences, QR documents, images, etc.
    # =====================================================

    PDF_SIGNALS = (
        "pdf",
        "pd f",
        "upload",
        "uploaded",
        "attachment",
        "document",
        "documentation",
        "file",
        "licence",
        "license",
        "chauffeur",
        "qr code",
        "image",
        "photo",
    )

    def __init__(
        self,
        booking_threshold: float = DEFAULT_BOOKING_THRESHOLD,
        pdf_threshold: float = DEFAULT_PDF_THRESHOLD,
        sql_confidence: float = DEFAULT_SQL_CONFIDENCE,
    ) -> None:

        # -------------------------------------------------
        # Validate booking threshold
        # -------------------------------------------------

        if booking_threshold < 0 or booking_threshold > 1:

            raise ValueError(
                "booking_threshold must be "
                "between 0 and 1."
            )

        self.booking_threshold = (
            booking_threshold
        )

        # -------------------------------------------------
        # Validate pdf threshold
        # -------------------------------------------------

        if pdf_threshold < 0 or pdf_threshold > 1:

            raise ValueError(
                "pdf_threshold must be "
                "between 0 and 1."
            )

        self.pdf_threshold = (
            pdf_threshold
        )

        # -------------------------------------------------
        # Validate SQL confidence
        # -------------------------------------------------

        if (
            sql_confidence < 0
            or sql_confidence > 1
        ):

            raise ValueError(
                "sql_confidence must be "
                "between 0 and 1."
            )

        self.sql_confidence = (
            sql_confidence
        )

    # =====================================================
    # PUBLIC API
    # =====================================================

    def route(
        self,
        request: (
            AgentRoutingRequest
            | str
        ),
    ) -> AgentRoutingResult:
        """
        Route one user query to an agent.
        """

        if isinstance(
            request,
            str,
        ):

            request = AgentRoutingRequest(
                query=request
            )

        clean_query = (
            request.query.strip()
        )

        if not clean_query:

            raise AgentRouterError(
                "query cannot be empty."
            )

        normalized_query = (
            self._normalize(
                clean_query
            )
        )

        # -------------------------------------------------
        # Score each non-default agent
        # -------------------------------------------------

        (
            booking_score,
            booking_keywords,
        ) = self._keyword_score(
            normalized_query=(
                normalized_query
            ),
            signals=self.BOOKING_SIGNALS,
        )

        (
            pdf_score,
            pdf_keywords,
        ) = self._keyword_score(
            normalized_query=(
                normalized_query
            ),
            signals=self.PDF_SIGNALS,
        )

        # -------------------------------------------------
        # Decide the target agent
        # -------------------------------------------------

        decision = self._decide(
            clean_query=clean_query,
            booking_score=booking_score,
            booking_keywords=booking_keywords,
            pdf_score=pdf_score,
            pdf_keywords=pdf_keywords,
        )

        logger.info(
            "Agent routing decided. "
            "Query=%r Agent=%s Confidence=%.2f "
            "BookingScore=%.2f PdfScore=%.2f",
            clean_query,
            decision.agent_type.value,
            decision.confidence,
            booking_score,
            pdf_score,
        )

        return AgentRoutingResult(
            query=clean_query,
            decision=decision,
            metadata=(
                request.metadata
            ),
        )

    # =====================================================
    # DECISION LOGIC
    # =====================================================

    def _decide(
        self,
        clean_query: str,
        booking_score: float,
        booking_keywords: tuple[str, ...],
        pdf_score: float,
        pdf_keywords: tuple[str, ...],
    ) -> AgentRoutingDecision:
        """
        Apply routing thresholds.

        If both signals are weak,
        fall back to the SQL agent.
        """

        booking_wins = (
            booking_score
            >= self.booking_threshold

            and booking_score
            >= pdf_score
        )

        pdf_wins = (
            pdf_score
            >= self.pdf_threshold

            and not booking_wins
        )

        if booking_wins:

            confidence = round(
                0.50 + 0.50 * booking_score,
                2,
            )

            return AgentRoutingDecision(

                agent_type=AgentType.BOOKING,

                confidence=confidence,

                matched_keywords=(
                    booking_keywords
                ),

                reasoning=(
                    "Booking signals detected: "
                    f"{', '.join(booking_keywords) or 'none'}."
                ),
            )

        if pdf_wins:

            confidence = round(
                0.50 + 0.50 * pdf_score,
                2,
            )

            return AgentRoutingDecision(

                agent_type=AgentType.PDF,

                confidence=confidence,

                matched_keywords=(
                    pdf_keywords
                ),

                reasoning=(
                    "PDF/document signals detected: "
                    f"{', '.join(pdf_keywords) or 'none'}."
                ),
            )

        # -------------------------------------------------
        # Fallback: SQL data assistant
        # -------------------------------------------------

        if (
            booking_score > 0
            or pdf_score > 0
        ):

            noise = max(
                booking_score,
                pdf_score,
            )

            confidence = round(
                max(
                    0.35,
                    self.sql_confidence
                    - noise,
                ),
                2,
            )

        else:

            confidence = (
                self.sql_confidence
            )

        return AgentRoutingDecision(

            agent_type=AgentType.SQL,

            confidence=confidence,

            matched_keywords=(),

            reasoning=(
                "No strong booking or PDF signal. "
                "Routed to the default SQL data assistant."
            ),
        )

    # =====================================================
    # HELPERS
    # =====================================================

    @classmethod
    def _normalize(
        cls,
        query: str,
    ) -> str:
        """
        Normalize the query for signal matching.
        """

        normalized = (
            query
            .lower()
            .replace("  ", " ")
        )

        # Common typo guard: "pd f" -> "pdf"
        normalized = normalized.replace(
            "pd f",
            "pdf",
        )

        return normalized

    @classmethod
    def _keyword_score(
        cls,
        normalized_query: str,
        signals: tuple[str, ...],
    ) -> tuple[
        float,
        tuple[str, ...],
    ]:
        """
        Count signal keywords inside the query.

        Score saturates as more signals match:

        - 1 hit  -> 0.50
        - 2 hits -> 0.75
        - 3 hits -> 0.88

        Return:
            (score, matched_keywords)
        """

        matched_keywords: list[str] = []

        for keyword in signals:

            if (
                keyword
                in normalized_query
            ):

                matched_keywords.append(
                    keyword
                )

        match_count = len(
            matched_keywords
        )

        if match_count == 0:

            return (
                0.0,
                (),
            )

        score = (
            1.0
            - (0.5 ** match_count)
        )

        return (
            round(
                score,
                4,
            ),
            tuple(
                matched_keywords
            ),
        )

    @classmethod
    def has_booking_intent(
        cls,
        query: str,
    ) -> bool:
        """
        Quick inline check used by other modules.
        """

        normalized_query = (
            cls._normalize(
                query
            )
        )

        return any(
            keyword
            in normalized_query
            for keyword
            in cls.BOOKING_SIGNALS
        )

    @classmethod
    def has_pdf_intent(
        cls,
        query: str,
    ) -> bool:
        """
        Quick inline check used by other modules.
        """

        normalized_query = (
            cls._normalize(
                query
            )
        )

        return any(
            keyword
            in normalized_query
            for keyword
            in cls.PDF_SIGNALS
        )