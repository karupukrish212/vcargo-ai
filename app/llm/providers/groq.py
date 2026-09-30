import logging

import groq
from groq import AsyncGroq

from app.core.config import get_settings
from app.llm.base import LLMProvider


logger = logging.getLogger(__name__)


class GroqProvider(LLMProvider):
    """
    Groq cloud LLM provider.

    Uses the official Groq Python SDK.
    """

    def __init__(self) -> None:

        settings = get_settings()

        if not settings.GROQ_API_KEY:

            raise ValueError(
                "GROQ_API_KEY is required "
                "for GroqProvider."
            )

        if not settings.GROQ_MODEL:

            raise ValueError(
                "GROQ_MODEL is required "
                "for GroqProvider."
            )

        self.model = (
            settings.GROQ_MODEL
        )

        self.client = AsyncGroq(
            api_key=(
                settings.GROQ_API_KEY
            ),
            timeout=float(
                settings.LLM_TIMEOUT
            ),
            max_retries=2,
        )

        logger.info(
            "GroqProvider initialized. "
            "Model=%s",
            self.model,
        )

    async def generate(
        self,
        prompt: str,
        *,
        temperature: float = 0.0,
    ) -> str:

        if not prompt.strip():

            raise ValueError(
                "LLM prompt cannot be empty."
            )

        try:

            response = await (
                self.client
                .chat
                .completions
                .create(
                    model=self.model,

                    messages=[
                        {
                            "role": "user",
                            "content": prompt,
                        }
                    ],

                    temperature=(
                        temperature
                    ),

                    stream=False,
                )
            )

        except groq.RateLimitError as exc:

            logger.exception(
                "Groq rate limit exceeded."
            )

            raise RuntimeError(
                "Groq rate limit exceeded."
            ) from exc

        except groq.APIConnectionError as exc:

            logger.exception(
                "Unable to connect to Groq."
            )

            raise RuntimeError(
                "Unable to connect to Groq API."
            ) from exc

        except groq.APIStatusError as exc:

            logger.exception(
                "Groq API returned an error. "
                "Status=%s",
                exc.status_code,
            )

            raise RuntimeError(
                "Groq API request failed."
            ) from exc

        content = (
            response
            .choices[0]
            .message
            .content
        )

        if not content:

            raise RuntimeError(
                "Groq returned an empty response."
            )

        return content.strip()