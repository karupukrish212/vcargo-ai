from app.retrieval.models import GraphRAGContext

class SQLPromptBuilder:
    """
    Trusted GraphRAG context-ஐ
    safe SQL generation prompt-ஆ convert செய்கிறது.
    """

    def build(
        self,
        context: GraphRAGContext,
    ) -> str:

        if not context.llm_context:

            raise ValueError(
                "GraphRAG context does not contain "
                "LLM context."
            )

        prompt = f"""
You are an enterprise MySQL SQL generator.

Your responsibility is to generate exactly one
safe, read-only MySQL SELECT query.

Use only the trusted GraphRAG context provided below.

STRICT RULES:

1. Generate only SELECT queries.

2. Never generate:
   INSERT,
   UPDATE,
   DELETE,
   DROP,
   ALTER,
   TRUNCATE,
   CREATE,
   REPLACE.

3. Use only the tables listed
   in the Relevant Schema section.

4. Use only the columns listed
   in the Relevant Schema section.

5. Use only relationships listed
   in the Trusted Joins section.

6. Never invent:
   - tables
   - columns
   - joins
   - relationships

7. If a Temporal Filter is provided,
   use exactly that trusted filter.

8. Start Date Inclusive means:

   column >= start_date

9. End Date Exclusive means:

   column < end_date

10. If requires_conversion is false,
    do not use STR_TO_DATE or any other
    unnecessary conversion.

11. Follow the Aggregation section exactly.

12. If Type is sum:
    use SUM(measure).

13. If Type is count:
    use COUNT(measure).

14. If Type is average:
    use AVG(measure).

15. If Group By is provided,
    use exactly that trusted column.

16. Do not use SELECT *
    unless full row data is explicitly required.

17. Do not add filters
    that the user did not request.

18. Do not add joins
    that are not listed in Trusted Joins.

19. Return SQL only.

20. Do not include:
    - explanation
    - markdown
    - code fences
    - comments


TRUSTED GRAPHRAG CONTEXT:

{context.llm_context}


Generate the MySQL SELECT query:
"""

        return prompt.strip()