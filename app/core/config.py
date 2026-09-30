from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict
from sqlalchemy import URL
from pydantic import model_validator


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


    # ------------------------------
    # LLM Provider
    # ------------------------------

    LLM_PROVIDER: str = "ollama"

    # ------------------------------
    # Ollama
    # ------------------------------

    OLLAMA_BASE_URL: str = (
        "http://localhost:11434"
    )

    OLLAMA_MODEL: str = "llama3.2"

    # ------------------------------
    # Groq
    # ------------------------------

    GROQ_API_KEY: str | None = None

    GROQ_MODEL: str | None = None

    # ------------------------------
    # Common LLM settings
    # ------------------------------

    LLM_TIMEOUT: int = 60

    LLM_ALLOW_FALLBACK: bool = False

    LLM_FALLBACK_PROVIDER: str | None = None


    # SCHEMA_CATALOG_PATH: str = "data/schema_catalog.json"
    SCHEMA_CATALOG_PATH: str = "data/schema_catalog.json"
    SCHEMA_METADATA_PATH: str = "data/schema_metadata.json"
    ENRICHED_SCHEMA_CATALOG_PATH: str = "data/enriched_schema_catalog.json"
    RELATIONSHIP_CANDIDATES_PATH: str = "data/relationship_candidates.json"
    VALIDATED_RELATIONSHIPS_PATH: str = "data/validated_relationships.json"
    RELATIONSHIP_REVIEW_PATH: str = "data/relationship_review.json"
    GRAPH_READY_RELATIONSHIPS_PATH: str = "data/graph_ready_relationships.json"

    EMBEDDING_MODEL_NAME: str = "BAAI/bge-small-en-v1.5"

    EMBEDDING_DEVICE: str = "cpu"

    EMBEDDING_BATCH_SIZE: int = 32

    EMBEDDING_NORMALIZE: bool = True


    @model_validator(mode="after")
    def validate_llm_configuration(self):
        provider = (
            self.LLM_PROVIDER
            .strip()
            .lower()
        )

        supported_providers = {
            "groq",
            "ollama",
        }

        if provider not in supported_providers:
            raise ValueError(
                "Unsupported LLM_PROVIDER: "
                f"{self.LLM_PROVIDER}. "
                "Supported providers are: "
                "groq, ollama."
            )

        # -----------------------------------------
        # GROQ VALIDATION
        # -----------------------------------------

        if provider == "groq":

            if not self.GROQ_API_KEY:
                raise ValueError(
                    "GROQ_API_KEY is required "
                    "when LLM_PROVIDER=groq."
                )

            if not self.GROQ_MODEL:
                raise ValueError(
                    "GROQ_MODEL is required "
                    "when LLM_PROVIDER=groq."
                )

        # -----------------------------------------
        # OLLAMA VALIDATION
        # -----------------------------------------

        if provider == "ollama":

            if not self.OLLAMA_BASE_URL:
                raise ValueError(
                    "OLLAMA_BASE_URL is required "
                    "when LLM_PROVIDER=ollama."
                )

            if not self.OLLAMA_MODEL:
                raise ValueError(
                    "OLLAMA_MODEL is required "
                    "when LLM_PROVIDER=ollama."
                )

        # -----------------------------------------
        # FALLBACK VALIDATION
        # -----------------------------------------

        if self.LLM_ALLOW_FALLBACK:

            if not self.LLM_FALLBACK_PROVIDER:
                raise ValueError(
                    "LLM_FALLBACK_PROVIDER is required "
                    "when LLM_ALLOW_FALLBACK=true."
                )

            fallback_provider = (
                self.LLM_FALLBACK_PROVIDER
                .strip()
                .lower()
            )

            if fallback_provider not in supported_providers:
                raise ValueError(
                    "Unsupported "
                    "LLM_FALLBACK_PROVIDER: "
                    f"{self.LLM_FALLBACK_PROVIDER}."
                )

            if fallback_provider == provider:
                raise ValueError(
                    "LLM_FALLBACK_PROVIDER cannot "
                    "be the same as LLM_PROVIDER."
                )

        return self




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