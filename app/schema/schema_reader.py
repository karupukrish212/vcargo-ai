import hashlib
import json
import logging
from datetime import datetime, timezone
from typing import Any

from sqlalchemy import inspect
from sqlalchemy.engine import Engine
from sqlalchemy.exc import SQLAlchemyError

from app.schema.exceptions import SchemaExtractionError
from app.schema.models import (
    ColumnSchema,
    ForeignKeySchema,
    IndexSchema,
    PrimaryKeySchema,
    SchemaCatalog,
    TableSchema,
)


logger = logging.getLogger(__name__)


class MySQLSchemaReader:

    def __init__(
        self,
        engine: Engine,
        database_name: str,
    ) -> None:

        self.engine = engine
        self.database_name = database_name

    def build_catalog(self) -> SchemaCatalog:

        logger.info(
            "Starting schema extraction for database: %s",
            self.database_name,
        )

        try:

            inspector = inspect(self.engine)

            table_names = sorted(
                #take the table names from the database using the inspector
                inspector.get_table_names(
                    schema=self.database_name
                )
            )

            logger.info(
                "Found %d tables",
                len(table_names),
            )

            if not table_names:

                logger.warning(
                    "No tables found in database %s",
                    self.database_name,
                )

            # ----------------------------------------
            # Bulk metadata loading
            # ----------------------------------------
            # take multiple column names from the db
            columns_map = inspector.get_multi_columns(
                schema=self.database_name,
                filter_names=table_names,
            )

            pk_map = inspector.get_multi_pk_constraint(
                schema=self.database_name,
                filter_names=table_names,
            )

            fk_map = inspector.get_multi_foreign_keys(
                schema=self.database_name,
                filter_names=table_names,
            )

            index_map = inspector.get_multi_indexes(
                schema=self.database_name,
                filter_names=table_names,
            )

            comments_map = self._load_comments(
                inspector,
                table_names,
            )

            # ----------------------------------------
            # Convert DB metadata into our models
            # ----------------------------------------

            tables: list[TableSchema] = []

            for table_name in table_names:

                key = self._get_table_key(
                    table_name
                )

                raw_columns = columns_map.get(
                    key,
                    [],
                )

                raw_pk = pk_map.get(
                    key,
                    {},
                )

                raw_fks = fk_map.get(
                    key,
                    [],
                )

                raw_indexes = index_map.get(
                    key,
                    [],
                )

                raw_comment = comments_map.get(
                    key,
                    {},
                )

                table = TableSchema(

                    table_name=table_name,

                    comment=raw_comment.get(
                        "text"
                    )
                    if isinstance(
                        raw_comment,
                        dict,
                    )
                    else None,

                    columns=[
                        self._build_column(column)
                        for column in raw_columns
                    ],

                    primary_key=(
                        self._build_primary_key(
                            raw_pk
                        )
                    ),

                    foreign_keys=[
                        self._build_foreign_key(fk)
                        for fk in raw_fks
                    ],

                    indexes=[
                        self._build_index(index)
                        for index in raw_indexes
                    ],
                )

                tables.append(table)

            schema_hash = self._create_schema_hash(
                tables
            )

            catalog = SchemaCatalog(

                database=self.database_name,

                generated_at=datetime.now(
                    timezone.utc
                ),

                schema_hash=schema_hash,

                table_count=len(tables),

                tables=tables,
            )

            logger.info(
                "Schema extraction completed. "
                "Tables=%d Hash=%s",
                catalog.table_count,
                catalog.schema_hash,
            )

            return catalog

        except SQLAlchemyError as exc:

            logger.exception(
                "Database schema extraction failed"
            )

            raise SchemaExtractionError(
                "Unable to read database schema."
            ) from exc

        except Exception as exc:

            logger.exception(
                "Unexpected schema extraction error"
            )

            raise SchemaExtractionError(
                "Unexpected error while reading schema."
            ) from exc

    # --------------------------------------------------
    # Column Builder
    # --------------------------------------------------

    def _build_column(
        self,
        column: dict[str, Any],
    ) -> ColumnSchema:

        return ColumnSchema(

            name=column["name"],

            data_type=str(
                column["type"]
            ),

            nullable=column.get(
                "nullable"
            ),

            default=self._json_safe(
                column.get("default")
            ),

            autoincrement=self._json_safe(
                column.get("autoincrement")
            ),

            comment=column.get(
                "comment"
            ),
        )

    # --------------------------------------------------
    # Primary Key Builder
    # --------------------------------------------------

    def _build_primary_key(
        self,
        pk: dict[str, Any],
    ) -> PrimaryKeySchema:

        return PrimaryKeySchema(

            name=pk.get("name"),

            columns=pk.get(
                "constrained_columns",
                [],
            ),
        )

    # --------------------------------------------------
    # Foreign Key Builder
    # --------------------------------------------------

    def _build_foreign_key(
        self,
        fk: dict[str, Any],
    ) -> ForeignKeySchema:

        return ForeignKeySchema(

            name=fk.get("name"),

            columns=fk.get(
                "constrained_columns",
                [],
            ),

            referenced_schema=fk.get(
                "referred_schema"
            ),

            referenced_table=fk.get(
                "referred_table"
            ),

            referenced_columns=fk.get(
                "referred_columns",
                [],
            ),
        )

    # --------------------------------------------------
    # Index Builder
    # --------------------------------------------------

    def _build_index(
        self,
        index: dict[str, Any],
    ) -> IndexSchema:

        return IndexSchema(

            name=index.get("name"),

            columns=index.get(
                "column_names",
                [],
            ),

            unique=index.get(
                "unique",
                False,
            ),
        )

    # --------------------------------------------------
    # Table comments
    # --------------------------------------------------

    def _load_comments(
        self,
        inspector,
        table_names: list[str],
    ) -> dict:

        try:

            return inspector.get_multi_table_comment(
                schema=self.database_name,
                filter_names=table_names,
            )

        except (
            SQLAlchemyError,
            NotImplementedError,
        ):

            logger.warning(
                "Table comments could not be loaded"
            )

            return {}

    # --------------------------------------------------
    # SQLAlchemy multi API key
    # --------------------------------------------------

    def _get_table_key(
        self,
        table_name: str,
    ) -> tuple[str, str]:

        return (
            self.database_name,
            table_name,
        )

    # --------------------------------------------------
    # Schema Hash
    # --------------------------------------------------

    def _create_schema_hash(
        self,
        tables: list[TableSchema],
    ) -> str:

        normalized = [
            table.model_dump(
                mode="json"
            )
            for table in tables
        ]

        schema_json = json.dumps(
            normalized,
            sort_keys=True,
            ensure_ascii=False,
        )

        return hashlib.sha256(
            schema_json.encode("utf-8")
        ).hexdigest()

    # --------------------------------------------------
    # JSON-safe converter
    # --------------------------------------------------

    @staticmethod
    def _json_safe(
        value: Any,
    ) -> Any:

        if value is None:

            return None

        if isinstance(
            value,
            (
                str,
                int,
                float,
                bool,
            ),
        ):

            return value

        return str(value)