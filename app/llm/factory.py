from app.core.config import get_settings
from app.llm.base import LLMProvider
from app.llm.providers.groq import GroqProvider


class LLMProviderFactory:
    """
    Create the configured LLM provider.

    The agent layer should not know
    which provider is active.
    """

    @staticmethod
    def create() -> LLMProvider:

        settings = get_settings()

        provider = (
            settings.LLM_PROVIDER
            .strip()
            .lower()
        )

        if provider == "groq":

            return GroqProvider()

        if provider == "ollama":

            # OllamaProvider இன்னும் implement
            # பண்ணவில்லை.
            raise NotImplementedError(
                "OllamaProvider is not implemented yet."
            )

        raise ValueError(
            "Unsupported LLM provider: "
            f"{settings.LLM_PROVIDER}"
        )