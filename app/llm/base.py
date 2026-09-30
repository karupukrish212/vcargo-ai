from abc import ABC, abstractmethod


class LLMProvider(ABC):
    """
    Common contract for all LLM providers.

    Examples:
        Groq
        Ollama
        Gemini
        OpenAI
    """

    @abstractmethod
    async def generate(
        self,
        prompt: str,
        *,
        temperature: float = 0.0,
    ) -> str:
        """
        Send a prompt to the LLM provider
        and return generated text.
        """

        raise NotImplementedError