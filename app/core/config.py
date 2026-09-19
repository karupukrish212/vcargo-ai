from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict
from sqlalchemy import URL


class Settings(BaseSettings):

    APP_NAME: str = "VCargo AI Assistant"
    APP_ENV: str = "development"
    DEBUG: bool = False

    DB_HOST: str
    DB_PORT: int = 3306
    DB_USER: str
    DB_PASSWORD: str
    DB_NAME: str

    DB_CHARSET: str = "utf8mb4"
    DB_CONNECT_TIMEOUT: int = 10

    # SCHEMA_CATALOG_PATH: str = "data/schema_catalog.json"
    SCHEMA_CATALOG_PATH: str = "data/schema_catalog.json"
    SCHEMA_METADATA_PATH: str = "data/schema_metadata.json"
    ENRICHED_SCHEMA_CATALOG_PATH: str = "data/enriched_schema_catalog.json"
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )

    @property
    def database_url(self) -> URL:

        return URL.create(
            drivername="mysql+pymysql",
            username=self.DB_USER,
            password=self.DB_PASSWORD,
            host=self.DB_HOST,
            port=self.DB_PORT,
            database=self.DB_NAME,
            query={
                "charset": self.DB_CHARSET,
            },
        )


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()