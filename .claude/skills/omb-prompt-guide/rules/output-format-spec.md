---
title: Explicitly Define Output Structure
impact: MEDIUM-HIGH
impactDescription: Eliminates format guessing
tags: format, structure, specification, structured-outputs, prefill-migration
---

## Explicitly Define Output Structure

Never leave output structure to chance. Specify exact sections, headings, or data structures. For JSON/YAML output, use the **Structured Outputs** API feature instead of prefilled responses (deprecated in Claude 4.6). For classification, use tools with enum fields or structured outputs.

**Incorrect (unstructured request):**

```text
Analyze this code and tell me what you find.
```

**Correct (explicit format specification):**

```text
Analyze this code. Structure your response as:
1. **Summary** (1-2 sentences)
2. **Critical Issues** (bulleted list with file:line references)
3. **Recommendations** (numbered, prioritized)
4. **Overall Rating** (1-10 with justification)
```

**For JSON output (use Structured Outputs API):**

```python
# Preferred: Structured Outputs constrains schema
response = client.messages.create(
    model="claude-opus-4-6",
    max_tokens=1024,
    messages=[{"role": "user", "content": "Classify this email"}],
    response_format={"type": "json_schema", "schema": {...}}
)
```

**Migrating from prefilled responses (deprecated in Claude 4.6):**

| Old pattern | Migration |
|-------------|-----------|
| Prefill for JSON format | Use Structured Outputs API |
| Prefill to skip preamble | "Respond directly without preamble" |
| Prefill for classification | Use tools with enum field |
| Prefill for continuations | "Continue from where you left off: [last text]" |

**Format via XML indicator:**

```text
Write the analysis in <analysis> tags with <summary>, <issues>,
and <recommendations> sub-tags.
```

Reference: [Anthropic Prompting Best Practices — Output Formatting](https://platform.claude.com/docs/en/docs/build-with-claude/prompt-engineering/claude-prompting-best-practices)
