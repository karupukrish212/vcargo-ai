from enum import Enum

from pydantic import BaseModel, Field


class RelationshipType(str, Enum):
    """
    Describes what kind of relationship exists
    between two database columns.
    """

    FOREIGN_KEY = "foreign_key"
    BUSINESS_KEY = "business_key"
    VALUE_MATCH = "value_match"
    INFERRED = "inferred"


class RelationshipSource(str, Enum):
    """
    Describes where the relationship information
    came from.
    """

    DATABASE = "database"
    MANUAL = "manual"
    DISCOVERED = "discovered"
    VALIDATED_INFERENCE = "validated_inference"


class RelationshipStatus(str, Enum):
    """
    Current validation status of a relationship.
    """

    CANDIDATE = "candidate"
    APPROVED = "approved"
    REJECTED = "rejected"
    NEEDS_REVIEW = "needs_review"


class RelationshipEvidence(BaseModel):
    """
    One reason/evidence supporting a discovered
    relationship.
    """

    rule: str

    score: float = Field(
        default=0.0,
        ge=0.0,
        le=1.0,
    )

    description: str | None = None


class Relationship(BaseModel):
    """
    Represents a relationship between
    two database columns.
    """

    source_table: str
    source_column: str

    target_table: str
    target_column: str

    relationship_type: RelationshipType

    relationship_source: RelationshipSource

    join_operator: str = "="

    confidence_score: float = Field(
        default=0.0,
        ge=0.0,
        le=1.0,
    )

    status: RelationshipStatus = (
        RelationshipStatus.CANDIDATE
    )

    evidence: list[RelationshipEvidence] = Field(
        default_factory=list
    )

    description: str | None = None


class RelationshipCatalog(BaseModel):
    """
    Complete relationship discovery output.
    """

    schema_hash: str

    business_table_count: int

    declared_relationship_count: int = 0

    candidate_relationship_count: int = 0

    relationships: list[Relationship] = Field(
        default_factory=list
    )

class RelationshipValidation(BaseModel):
    """
    Stores actual database validation results
    for a discovered relationship.
    """

    source_total_rows: int = 0
    source_non_null_rows: int = 0

    source_distinct_values: int = 0
    target_distinct_values: int = 0

    matched_distinct_values: int = 0
    unmatched_distinct_values: int = 0

    value_overlap_ratio: float = Field(
        default=0.0,
        ge=0.0,
        le=1.0,
    )

    source_null_ratio: float = Field(
        default=0.0,
        ge=0.0,
        le=1.0,
    )

    target_duplicate_groups: int = 0

    target_unique: bool | None = None

    validation_note: str | None = None


class ValidatedRelationship(Relationship):
    """
    Relationship with database validation details.
    """

    validation: RelationshipValidation | None = None


class ValidatedRelationshipCatalog(BaseModel):
    """
    Final output after candidate validation.
    """

    schema_hash: str

    approved_count: int = 0
    needs_review_count: int = 0
    rejected_count: int = 0

    relationships: list[ValidatedRelationship] = Field(
        default_factory=list
    )