---
title: Provide Exact Schemas for Structured Output
impact: MEDIUM-HIGH
impactDescription: Ensures machine-parseable output
tags: json, schema, structured-output
---

## Provide Exact Schemas for Structured Output

When you need structured data (JSON, YAML, XML), provide the exact schema or a complete example. For API responses, use Claude's structured output feature or tool definitions. A schema prevents field name guessing and type mismatches.

**Incorrect (what's wrong):**

```text
Return the results as JSON.
```

**Correct (what's right):**

```text
Return results matching this schema:
{
  "verdict": "PASS" | "FAIL",
  "score": number (0-100),
  "findings": [{"severity": "HIGH"|"MEDIUM"|"LOW", "message": string, "file": string, "line": number}]
}
```
