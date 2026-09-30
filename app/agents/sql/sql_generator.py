import logging

from app.agents.sql.prompt_builder import SQLPromptBuilder
from app.llm.base import LLMProvider
from app.llm.factory import LLMProviderFactory
from app.retrieval.models import GraphRAGContext


logger = logging.getLogger(__name__)


class SQLGenerator:
    """
    Generate SQL from trusted GraphRAG context.

    This class does NOT:
    - execute SQL
    - validate SQL
    - access MySQL directly
    """

    def __init__(
        self,
        llm_provider: LLMProvider | None = None,
    ) -> None:

        self.llm_provider = (
            llm_provider
            or LLMProviderFactory.create()
        )

        self.prompt_builder = (
            SQLPromptBuilder()
        )

    async def generate(
        self,
        context: GraphRAGContext,
    ) -> str:
        """
        Generate SQL using the configured
        LLM provider.
        """

        # -----------------------------------------
        # Build trusted SQL prompt
        # -----------------------------------------

        prompt = (
            self.prompt_builder.build(
                context=context
            )
        )

        logger.info(
            "Generating SQL. "
            "Provider=%s "
            "Query=%r",
            self.llm_provider
            .__class__
            .__name__,
            context.query,
        )

        # -----------------------------------------
        # Call LLM
        # -----------------------------------------

        generated_text = (
            await self.llm_provider.generate(
                prompt=prompt,
                temperature=0.0,
            )
        )

        # -----------------------------------------
        # Basic response cleanup
        # -----------------------------------------

        sql = self._clean_sql(
            generated_text
        )

        if not sql:

            raise RuntimeError(
                "LLM returned empty SQL."
            )

        logger.info(
            "SQL generated successfully. "
            "Query=%r",
            context.query,
        )

        return sql

    @staticmethod
    def _clean_sql(
        generated_text: str,
    ) -> str:
        """
        Remove accidental markdown formatting
        from the LLM response.

        Security validation is NOT done here.
        That belongs to SQLValidator.
        """

        sql = generated_text.strip()

        if sql.startswith("```sql"):
            sql = sql[6:]

        elif sql.startswith("```"):
            sql = sql[3:]

        if sql.endswith("```"):
            sql = sql[:-3]

        return sql.strip()