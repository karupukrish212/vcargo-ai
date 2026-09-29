from enum import Enum

from pydantic import (
    BaseModel,
    ConfigDict,
    Field,
)


class AgentType(str, Enum):
    """
    The specialized agent that should handle
    one incoming user request.

    Important:

    - SQL agents answer data / analytics questions.
    - PDF agents answer questions against uploaded documents.
    - BOOKING agents create or manage reservations.
    - UNKNOWN is used when no agent has enough confidence.
    """

    SQL = "sql"

    PDF = "pdf"

    BOOKING = "booking"

    UNKNOWN = "unknown"


class AgentRoutingRequest(BaseModel):
    """
    Input payload for the agent router.
    """

    model_config = ConfigDict(
        frozen=True
    )

    query: str

    metadata: dict[str, str] = Field(
        default_factory=dict
    )


class AgentRoutingDecision(BaseModel):
    """
    Which agent should handle the request
    and how confident the router is.
    """

    model_config = ConfigDict(
        frozen=True
    )

    agent_type: AgentType

    confidence: float = Field(
        ge=0.0,
        le=1.0,
    )

    matched_keywords: tuple[str, ...] = ()

    reasoning: str


class AgentRoutingResult(BaseModel):
    """
    Complete router output for one user query.
    """

    model_config = ConfigDict(
        frozen=True
    )

    query: str

    decision: AgentRoutingDecision

    metadata: dict[str, str] = Field(
        default_factory=dict
    )