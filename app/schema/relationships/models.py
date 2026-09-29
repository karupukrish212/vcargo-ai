import hashlib
from datetime import datetime, timezone
from enum import Enum

from pydantic import (
    BaseModel,
    Field,
    computed_field,
    model_validator,
)


# =========================================================
# ENUMS
# =========================================================


class RelationshipType(str, Enum):
    """
    Describes the logical type of relationship.
    """

    FOREIGN_KEY = "foreign_key"

    BUSINESS_KEY = "business_key"

    VALUE_MATCH = "value_match"

    INFERRED = "inferred"


class RelationshipSource(str, Enum):
    """
    Describes where the relationship came from.
    """

    DATABASE = "database"

    MANUAL = "manual"

    DISCOVERED = "discovered"

    VALIDATED_INFERENCE = "validated_inference"


class RelationshipStatus(str, Enum):
    """
    Lifecycle status of the relationship.
    """

    CANDIDATE = "candidate"

    APPROVED = "approved"

    REJECTED = "rejected"

    NEEDS_REVIEW = "needs_review"


class RelationshipCardinality(str, Enum):
    """
    Describes relationship cardinality.

    Examples:

    trip.customer
        -> customer.customerid

    Many trips can belong to one customer.

    Therefore:

    MANY_TO_ONE
    """

    UNKNOWN = "unknown"

    ONE_TO_ONE = "one_to_one"

    ONE_TO_MANY = "one_to_many"

    MANY_TO_ONE = "many_to_one"

    MANY_TO_MANY = "many_to_many"


# =========================================================
# EVIDENCE
# =========================================================


class RelationshipEvidence(BaseModel):
    """
    Evidence explaining why a relationship
    was discovered or approved.
    """

    rule: str

    score: float = Field(
        default=0.0,
        ge=0.0,
        le=1.0,
    )

    description: str | None = None


# =========================================================
# NORMALIZATION
# =========================================================


class RelationshipNormalization(BaseModel):
    """
    Describes normalization requirements
    when validating or joining values.

    Example:

    " KA01AB1234 "
    "ka01ab1234"

    may require:

    trim=True
    case_insensitive=True
    """

    trim: bool = False

    case_insensitive: bool = False

    empty_string_as_null: bool = False


# =========================================================
# TENANT / ORGANIZATION SCOPE
# =========================================================


class RelationshipTenantScope(BaseModel):
    """
    Enterprise SaaS databases often require
    tenant-aware joins.

    Example:

    trip.branchcode = branch.branchcode

    may also require:

    trip.orgid = branch.orgid
    """

    enabled: bool = False

    source_columns: list[str] = Field(
        default_factory=list
    )

    target_columns: list[str] = Field(
        default_factory=list
    )

    description: str | None = None

    @model_validator(
        mode="after"
    )
    def validate_column_count(
        self,
    ):
        """
        Source and target tenant columns
        should have the same number of fields.
        """

        if (
            self.enabled
            and len(self.source_columns)
            != len(self.target_columns)
        ):
            raise ValueError(
                "Tenant scope source_columns and "
                "target_columns must have the same length."
            )

        return self


# =========================================================
# GOVERNANCE
# =========================================================


class RelationshipGovernance(BaseModel):
    """
    Human / system governance information.

    Useful for enterprise auditability.
    """

    approved_by: str | None = None

    approved_at: datetime | None = None

    approval_reason: str | None = None

    reviewed_by: str | None = None

    review_notes: str | None = None


# =========================================================
# PROVENANCE / VERSION INFORMATION
# =========================================================


class RelationshipProvenance(BaseModel):
    """
    Tracks where and when this relationship
    was created and validated.
    """

    relationship_version: int = Field(
        default=1,
        ge=1,
    )

    schema_hash: str | None = None

    discovered_at: datetime | None = None

    validated_at: datetime | None = None


# =========================================================
# DATABASE VALIDATION RESULT
# =========================================================


class RelationshipValidation(BaseModel):
    """
    Stores actual database validation results
    for a relationship.
    """

    source_total_rows: int = Field(
        default=0,
        ge=0,
    )

    source_non_null_rows: int = Field(
        default=0,
        ge=0,
    )

    source_distinct_values: int = Field(
        default=0,
        ge=0,
    )

    target_distinct_values: int = Field(
        default=0,
        ge=0,
    )

    matched_distinct_values: int = Field(
        default=0,
        ge=0,
    )

    unmatched_distinct_values: int = Field(
        default=0,
        ge=0,
    )

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

    # NEW
    source_duplicate_groups: int = Field(
        default=0,
        ge=0,
    )

    target_duplicate_groups: int = Field(
        default=0,
        ge=0,
    )

    # None = insufficient target data
    target_unique: bool | None = None

    # NEW
    source_unique: bool | None = None

    # NEW
    observed_cardinality: (
        RelationshipCardinality
    ) = RelationshipCardinality.UNKNOWN

    # NEW
    cardinality_compatible: bool | None = None

    # NEW
    tenant_scope_applied: bool = False

    # NEW
    validated_at: datetime | None = None

    validation_note: str | None = None

# =========================================================
# MAIN RELATIONSHIP MODEL
# =========================================================


class Relationship(BaseModel):
    """
    Enterprise relationship representation.

    Supports:

    - Single-column relationships
    - Composite-column relationships
    - Cardinality
    - Tenant-aware joins
    - Governance
    - Versioning
    - Evidence
    - Backward compatibility
    """

    relationship_id: str | None = None

    # -----------------------------------------------------
    # SOURCE
    # -----------------------------------------------------

    source_table: str

    source_columns: list[str] = Field(
        min_length=1
    )

    # -----------------------------------------------------
    # TARGET
    # -----------------------------------------------------

    target_table: str

    target_columns: list[str] = Field(
        min_length=1
    )

    # -----------------------------------------------------
    # RELATIONSHIP DETAILS
    # -----------------------------------------------------

    relationship_type: RelationshipType

    relationship_source: RelationshipSource

    cardinality: RelationshipCardinality = (
        RelationshipCardinality.UNKNOWN
    )

    join_operator: str = "="

    confidence_score: float = Field(
        default=0.0,
        ge=0.0,
        le=1.0,
    )

    status: RelationshipStatus = (
        RelationshipStatus.CANDIDATE
    )

    # -----------------------------------------------------
    # DISCOVERY EVIDENCE
    # -----------------------------------------------------

    evidence: list[
        RelationshipEvidence
    ] = Field(
        default_factory=list
    )

    description: str | None = None

    # -----------------------------------------------------
    # ENTERPRISE CONTROLS
    # -----------------------------------------------------

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

    active: bool = True

    # =====================================================
    # BACKWARD COMPATIBILITY
    # =====================================================

    @model_validator(
        mode="before"
    )
    @classmethod
    def support_legacy_single_columns(
        cls,
        data,
    ):
        """
        Existing project code currently uses:

        source_column="customer"

        target_column="customerid"

        New enterprise model uses:

        source_columns=["customer"]

        target_columns=["customerid"]

        This converter allows both formats.
        """

        if not isinstance(
            data,
            dict,
        ):
            return data

        data = dict(data)

        if (
            "source_columns"
            not in data
            and data.get(
                "source_column"
            )
        ):
            data[
                "source_columns"
            ] = [
                data["source_column"]
            ]

        if (
            "target_columns"
            not in data
            and data.get(
                "target_column"
            )
        ):
            data[
                "target_columns"
            ] = [
                data["target_column"]
            ]

        return data

    # =====================================================
    # MODEL VALIDATION
    # =====================================================

    @model_validator(
        mode="after"
    )
    def validate_relationship(
        self,
    ):
        """
        Validate relationship consistency.
        """

        # -------------------------------------------------
        # Composite key validation
        # -------------------------------------------------

        if (
            len(self.source_columns)
            != len(self.target_columns)
        ):
            raise ValueError(
                "source_columns and target_columns "
                "must have the same length."
            )

        # -------------------------------------------------
        # Generate deterministic relationship ID
        # -------------------------------------------------

        if not self.relationship_id:

            self.relationship_id = (
                self._generate_relationship_id()
            )

        return self

    # =====================================================
    # LEGACY SINGLE COLUMN ACCESS
    # =====================================================

    @computed_field
    @property
    def source_column(
        self,
    ) -> str | None:
        """
        Compatibility field for existing code.

        For composite relationships,
        returns the first source column.
        """

        if not self.source_columns:
            return None

        return self.source_columns[0]

    @computed_field
    @property
    def target_column(
        self,
    ) -> str | None:
        """
        Compatibility field for existing code.

        For composite relationships,
        returns the first target column.
        """

        if not self.target_columns:
            return None

        return self.target_columns[0]

    # =====================================================
    # RELATIONSHIP ID
    # =====================================================

    def _generate_relationship_id(
        self,
    ) -> str:
        """
        Generate stable relationship ID.

        Example input:

        trip
        customer
        customer
        customerid

        produces:

        rel_<hash>
        """

        raw_value = "|".join(
            [
                self.source_table,
                ",".join(
                    self.source_columns
                ),
                self.target_table,
                ",".join(
                    self.target_columns
                ),
                self.join_operator,
            ]
        )

        digest = hashlib.sha256(
            raw_value.encode(
                "utf-8"
            )
        ).hexdigest()[:16]

        return f"rel_{digest}"


# =========================================================
# DISCOVERY CATALOG
# =========================================================


class RelationshipCatalog(BaseModel):
    """
    Relationship discovery output.
    """

    relationship_schema_version: str = "2.0"

    schema_hash: str

    generated_at: datetime = Field(
        default_factory=lambda: (
            datetime.now(
                timezone.utc
            )
        )
    )

    business_table_count: int = Field(
        default=0,
        ge=0,
    )

    declared_relationship_count: int = Field(
        default=0,
        ge=0,
    )

    candidate_relationship_count: int = Field(
        default=0,
        ge=0,
    )

    relationships: list[
        Relationship
    ] = Field(
        default_factory=list
    )


# =========================================================
# VALIDATED RELATIONSHIP
# =========================================================


class ValidatedRelationship(Relationship):
    """
    Relationship after actual MySQL
    data validation.
    """

    validation: (
        RelationshipValidation
        | None
    ) = None


# =========================================================
# VALIDATED CATALOG
# =========================================================


class ValidatedRelationshipCatalog(BaseModel):
    """
    Output after relationship validation.
    """

    relationship_schema_version: str = "2.0"

    schema_hash: str

    generated_at: datetime = Field(
        default_factory=lambda: (
            datetime.now(
                timezone.utc
            )
        )
    )

    approved_count: int = Field(
        default=0,
        ge=0,
    )

    needs_review_count: int = Field(
        default=0,
        ge=0,
    )

    rejected_count: int = Field(
        default=0,
        ge=0,
    )

    relationships: list[
        ValidatedRelationship
    ] = Field(
        default_factory=list
    )