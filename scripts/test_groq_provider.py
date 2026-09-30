import asyncio
import logging

from app.core.logging_config import configure_logging
from app.llm.providers.groq import GroqProvider


logger = logging.getLogger(__name__)


async def main() -> None:

    configure_logging()

    logger.info(
        "Starting Groq provider connectivity test..."
    )

    # -----------------------------------------
    # Create Groq provider
    # -----------------------------------------

    provider = (
        GroqProvider()
    )

    # -----------------------------------------
    # Simple connectivity test prompt
    # -----------------------------------------

    prompt = """
Reply with exactly this text:

GROQ_CONNECTION_SUCCESS
""".strip()

    # -----------------------------------------
    # Call Groq
    # -----------------------------------------

    response = await provider.generate(
        prompt=prompt,
        temperature=0.0,
    )

    # -----------------------------------------
    # Print result
    # -----------------------------------------

    logger.info(
        "Groq response received successfully."
    )

    print(
        "\n========== GROQ TEST RESPONSE =========="
    )

    print(
        response
    )

    print(
        "========================================"
    )


if __name__ == "__main__":

    asyncio.run(
        main()
    )