from datetime import datetime
from typing import Any

from pydantic import BaseModel, Field


class ColumnSchema(BaseModel):

    name: str

    data_type: str

    nullable: bool | None = None

    default: Any = None

    autoincrement: Any = None

    comment: str | None = None


class PrimaryKeySchema(BaseModel):

    name: str | None = None

    columns: list[str] = Field(
        default_factory=list
    )


class ForeignKeySchema(BaseModel):

    name: str | None = None

    columns: list[str] = Field(
        default_factory=list
    )

    referenced_schema: str | None = None

    referenced_table: str | None = None

    referenced_columns: list[str] = Field(
        default_factory=list
    )


class IndexSchema(BaseModel):

    name: str | None = None

    columns: list[str | None] = Field(
        default_factory=list
    )

    unique: bool = False


class TableSchema(BaseModel):

    table_name: str

    comment: str | None = None

    columns: list[ColumnSchema] = Field(
        default_factory=list
    )

    primary_key: PrimaryKeySchema

    foreign_keys: list[ForeignKeySchema] = Field(
        default_factory=list
    )

    indexes: list[IndexSchema] = Field(
        default_factory=list
    )


class SchemaCatalog(BaseModel):

    schema_version: str = "1.0"

    database: str

    generated_at: datetime

    schema_hash: str

    table_count: int

    tables: list[TableSchema] = Field(
        default_factory=list
    )