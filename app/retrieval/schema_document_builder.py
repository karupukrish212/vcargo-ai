import hashlib
import json
import logging
from datetime import datetime, timezone
from pathlib import Path

from app.graph.models import (
    GraphColumn,
    GraphRelationship,
    GraphTable,
)
from app.graph.schema_graph import SchemaGraph
from app.retrieval.models import (
    SchemaDocument,
    SchemaDocumentCatalog,
    SchemaDocumentType,
)


logger = logging.getLogger(__name__)


class SchemaDocumentBuilderError(Exception):
    """Base exception for schema document builder."""

    pass


class SchemaDocumentBuilder:
    """
    Converts the trusted runtime SchemaGraph into
    semantic-search-friendly documents.

    Document types:

    1. Table documents
    2. Column documents

    These documents will later be embedded and
    stored inside FAISS.

    Important:
    This builder does NOT create embeddings.
    """

    DOCUMENT_VERSION = "1.0"

    def __init__(
        self,
        graph: SchemaGraph,
    ) -> None:
        self.graph = graph

    # =====================================================
    # MAIN BUILD
    # =====================================================

    def build_catalog(
        self,
    ) -> SchemaDocumentCatalog:
        """
        Build complete table + column document catalog.
        """

        table_documents: list[SchemaDocument] = []
        column_documents: list[SchemaDocument] = []

        for table in self.graph.get_tables():

            table_document = (
                self._build_table_document(
                    table
                )
            )

            table_documents.append(
                table_document
            )

            for column in table.columns:

                column_document = (
                    self._build_column_document(
                        table=table,
                        column=column,
                    )
                )

                column_documents.append(
                    column_document
                )

        all_documents = (
            table_documents
            + column_documents
        )

        # Deterministic ordering
        all_documents.sort(
            key=lambda document: (
                document.table_name,
                document.column_name or "",
                document.document_type.value,
            )
        )

        catalog = SchemaDocumentCatalog(

            document_version=(
                self.DOCUMENT_VERSION
            ),

            schema_hash=(
                self.graph.schema_hash
            ),

            generated_at=datetime.now(
                timezone.utc
            ),

            table_document_count=len(
                table_documents
            ),

            column_document_count=len(
                column_documents
            ),

            total_document_count=len(
                all_documents
            ),

            documents=tuple(
                all_documents
            ),
        )

        logger.info(
            "Schema documents built. "
            "Tables=%d Columns=%d Total=%d",
            catalog.table_document_count,
            catalog.column_document_count,
            catalog.total_document_count,
        )

        return catalog

    # =====================================================
    # TABLE DOCUMENT
    # =====================================================

    def _build_table_document(
        self,
        table: GraphTable,
    ) -> SchemaDocument:
        """
        Build semantic document for one table.
        """

        lines: list[str] = []

        lines.append(
            f"Table: {table.name}"
        )

        if table.business_name:
            lines.append(
                f"Business Name: "
                f"{table.business_name}"
            )

        if table.domain:
            lines.append(
                f"Business Domain: "
                f"{table.domain}"
            )

        if table.description:
            lines.append(
                f"Description: "
                f"{table.description}"
            )

        if table.synonyms:

            lines.append(
                "Table Synonyms: "
                + ", ".join(
                    table.synonyms
                )
            )

        # -------------------------------------------------
        # COLUMN INFORMATION
        # -------------------------------------------------

        if table.columns:

            lines.append("")
            lines.append(
                "Columns:"
            )

            for column in table.columns:

                column_parts: list[str] = [
                    column.name
                ]

                if column.business_name:

                    column_parts.append(
                        column.business_name
                    )

                if column.semantic_type:

                    column_parts.append(
                        f"type={column.semantic_type}"
                    )

                if column.is_primary_key:

                    column_parts.append(
                        "primary key"
                    )

                if column.is_unique:

                    column_parts.append(
                        "unique"
                    )

                lines.append(
                    "- "
                    + " | ".join(
                        column_parts
                    )
                )

        # -------------------------------------------------
        # RELATIONSHIP INFORMATION
        # -------------------------------------------------

        relationships = (
            self.graph
            .relationships_for_table(
                table.name
            )
        )

        if relationships:

            lines.append("")
            lines.append(
                "Trusted Relationships:"
            )

            for relationship in relationships:

                lines.append(
                    self._relationship_to_text(
                        relationship
                    )
                )

        keywords = self._merge_keywords(
            table.name,
            table.business_name,
            table.domain,
            *table.synonyms,
        )

        text = "\n".join(
            lines
        ).strip()

        document_id = (
            self._create_document_id(
                document_type=(
                    SchemaDocumentType.TABLE
                ),
                table_name=table.name,
            )
        )

        return SchemaDocument(

            document_id=document_id,

            document_type=(
                SchemaDocumentType.TABLE
            ),

            schema_hash=(
                self.graph.schema_hash
            ),

            table_name=(
                table.name
            ),

            business_name=(
                table.business_name
            ),

            domain=(
                table.domain
            ),

            keywords=(
                keywords
            ),

            text=text,
        )

    # =====================================================
    # COLUMN DOCUMENT
    # =====================================================

    def _build_column_document(
        self,
        table: GraphTable,
        column: GraphColumn,
    ) -> SchemaDocument:
        """
        Build semantic document for one specific column.

        Example:

        Table: trip
        Column: revenue
        Business Name: Trip Revenue
        Semantic Type: amount
        """

        lines: list[str] = []

        lines.append(
            f"Table: {table.name}"
        )

        if table.business_name:
            lines.append(
                f"Table Business Name: "
                f"{table.business_name}"
            )

        if table.domain:
            lines.append(
                f"Business Domain: "
                f"{table.domain}"
            )

        lines.append(
            f"Column: {column.name}"
        )

        if column.business_name:
            lines.append(
                f"Column Business Name: "
                f"{column.business_name}"
            )

        if column.description:
            lines.append(
                f"Description: "
                f"{column.description}"
            )

        if column.semantic_type:
            lines.append(
                f"Semantic Type: "
                f"{column.semantic_type}"
            )

        if column.data_type:
            lines.append(
                f"Database Type: "
                f"{column.data_type}"
            )

        if column.synonyms:
            lines.append(
                "Column Synonyms: "
                + ", ".join(
                    column.synonyms
                )
            )

        if column.is_primary_key:
            lines.append(
                "Key Type: Primary Key"
            )

        elif column.is_unique:
            lines.append(
                "Key Type: Unique Key"
            )

        if column.requires_conversion:
            lines.append(
                "Requires SQL Conversion: yes"
            )

            if column.stored_format:
                lines.append(
                    f"Stored Format: "
                    f"{column.stored_format}"
                )

            if column.mysql_format:
                lines.append(
                    f"MySQL Format: "
                    f"{column.mysql_format}"
                )

        # -------------------------------------------------
        # Relationships involving this column
        # -------------------------------------------------

        column_relationships = (
            self._relationships_for_column(
                table_name=table.name,
                column_name=column.name,
            )
        )

        if column_relationships:

            lines.append("")
            lines.append(
                "Trusted Relationship Context:"
            )

            for relationship in column_relationships:

                lines.append(
                    self._relationship_to_text(
                        relationship
                    )
                )

        # -------------------------------------------------
        # COLUMN KEYWORDS
        #
        # IMPORTANT:
        # Keep only column-specific metadata here.
        #
        # Do NOT add:
        # table.name
        # table.business_name
        # table.domain
        # table.synonyms
        #
        # Otherwise every column inside the same table
        # may receive unrelated lexical matches.
        # -------------------------------------------------

        keywords = self._merge_keywords(
            column.name,
            column.business_name,
            *column.synonyms,
        )

        # -------------------------------------------------
        # DOCUMENT TEXT
        # -------------------------------------------------

        text = "\n".join(
            lines
        ).strip()

        # -------------------------------------------------
        # DOCUMENT ID
        # -------------------------------------------------

        document_id = (
            self._create_document_id(
                document_type=(
                    SchemaDocumentType.COLUMN
                ),
                table_name=(
                    table.name
                ),
                column_name=(
                    column.name
                ),
            )
        )

        # -------------------------------------------------
        # FINAL DOCUMENT
        # -------------------------------------------------

        return SchemaDocument(

            document_id=document_id,

            document_type=(
                SchemaDocumentType.COLUMN
            ),

            schema_hash=(
                self.graph.schema_hash
            ),

            table_name=(
                table.name
            ),

            column_name=(
                column.name
            ),

            business_name=(
                column.business_name
            ),

            domain=(
                table.domain
            ),

            semantic_type=(
                column.semantic_type
            ),

            keywords=(
                keywords
            ),

            text=text,
        )
    # =====================================================
    # RELATIONSHIPS FOR COLUMN
    # =====================================================

    def _relationships_for_column(
        self,
        table_name: str,
        column_name: str,
    ) -> tuple[
        GraphRelationship,
        ...
    ]:
        """
        Return relationships where the given
        physical column participates.
        """

        matches: list[
            GraphRelationship
        ] = []

        relationships = (
            self.graph
            .relationships_for_table(
                table_name
            )
        )

        for relationship in relationships:

            if (
                table_name
                == relationship.source_table
                and column_name
                in relationship.source_columns
            ):

                matches.append(
                    relationship
                )

                continue

            if (
                table_name
                == relationship.target_table
                and column_name
                in relationship.target_columns
            ):

                matches.append(
                    relationship
                )

                continue

            # Tenant-scope columns

            if (
                relationship.tenant_scope.enabled
            ):

                if (
                    table_name
                    == relationship.source_table
                    and column_name
                    in relationship
                    .tenant_scope
                    .source_columns
                ):

                    matches.append(
                        relationship
                    )

                    continue

                if (
                    table_name
                    == relationship.target_table
                    and column_name
                    in relationship
                    .tenant_scope
                    .target_columns
                ):

                    matches.append(
                        relationship
                    )

        matches.sort(
            key=lambda relationship: (
                relationship.relationship_id
            )
        )

        return tuple(
            matches
        )

    # =====================================================
    # RELATIONSHIP -> TEXT
    # =====================================================

    @staticmethod
    def _relationship_to_text(
        relationship: GraphRelationship,
    ) -> str:
        """
        Convert trusted relationship into text
        useful for embeddings.
        """

        join_parts: list[str] = []

        for pair in relationship.join_pairs(
            include_tenant_scope=True
        ):

            join_text = (
                f"{relationship.source_table}."
                f"{pair.source_column} "
                f"{relationship.join_operator} "
                f"{relationship.target_table}."
                f"{pair.target_column}"
            )

            if pair.is_tenant_scope:

                join_text += (
                    " [tenant scope]"
                )

            join_parts.append(
                join_text
            )

        join_expression = (
            " AND ".join(
                join_parts
            )
        )

        return (
            f"- {join_expression}"
            f" | cardinality="
            f"{relationship.cardinality.value}"
            f" | relationship_type="
            f"{relationship.relationship_type.value}"
        )

    # =====================================================
    # STABLE DOCUMENT ID
    # =====================================================

    def _create_document_id(
        self,
        document_type: SchemaDocumentType,
        table_name: str,
        column_name: str | None = None,
    ) -> str:
        """
        Generate deterministic document ID.

        Same schema + same table/column =
        same document ID.
        """

        raw_value = "|".join(
            [
                self.graph.schema_hash,
                document_type.value,
                table_name,
                column_name or "",
            ]
        )

        digest = hashlib.sha256(
            raw_value.encode(
                "utf-8"
            )
        ).hexdigest()

        prefix = (
            "tbl"
            if document_type
            == SchemaDocumentType.TABLE
            else "col"
        )

        return (
            f"{prefix}_"
            f"{digest[:16]}"
        )

    # =====================================================
    # KEYWORD NORMALIZATION
    # =====================================================

    @staticmethod
    def _merge_keywords(
        *values: str | None,
    ) -> tuple[str, ...]:
        """
        Merge and deduplicate keywords while
        preserving their original order.
        """

        seen: set[str] = set()

        output: list[str] = []

        for value in values:

            if not value:
                continue

            clean_value = (
                str(value)
                .strip()
            )

            if not clean_value:
                continue

            normalized = (
                clean_value.lower()
            )

            if normalized in seen:
                continue

            seen.add(
                normalized
            )

            output.append(
                clean_value
            )

        return tuple(
            output
        )

    # =====================================================
    # EXPORT
    # =====================================================

    @staticmethod
    def export_catalog(
        catalog: SchemaDocumentCatalog,
        output_path: Path,
    ) -> None:
        """
        Safely write schema documents to disk.

        Uses temporary file + replace to reduce
        risk of leaving a partially written file.
        """

        output_path.parent.mkdir(
            parents=True,
            exist_ok=True,
        )

        temporary_path = (
            output_path.with_suffix(
                output_path.suffix
                + ".tmp"
            )
        )

        payload = (
            catalog.model_dump(
                mode="json"
            )
        )

        try:

            with temporary_path.open(
                "w",
                encoding="utf-8",
            ) as file:

                json.dump(
                    payload,
                    file,
                    indent=2,
                    ensure_ascii=False,
                )

            temporary_path.replace(
                output_path
            )

        except OSError as exc:

            raise (
                SchemaDocumentBuilderError(
                    "Unable to export schema "
                    f"documents to {output_path}"
                )
            ) from exc

        logger.info(
            "Schema document catalog exported: %s",
            output_path,
        )