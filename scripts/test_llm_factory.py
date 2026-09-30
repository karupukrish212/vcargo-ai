import asyncio
import logging

from app.core.logging_config import configure_logging
from app.llm.factory import LLMProviderFactory


logger = logging.getLogger(__name__)


async def main() -> None:

    configure_logging()

    provider = (
        LLMProviderFactory.create()
    )

    logger.info(
        "Provider created: %s",
        provider.__class__.__name__,
    )

    response = await provider.generate(
        prompt=(
            "Reply with exactly: "
            "LLM_FACTORY_SUCCESS"
        ),
        temperature=0.0,
    )

    print(
        "\n========== LLM FACTORY TEST =========="
    )

    print(
        response
    )

    print(
        "======================================"
    )


if __name__ == "__main__":

    asyncio.run(
        main()
    )