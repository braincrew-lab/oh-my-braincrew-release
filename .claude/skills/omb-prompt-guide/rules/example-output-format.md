---
title: Demonstrate Format Through Example
impact: HIGH
impactDescription: More reliable than format descriptions alone
tags: format, demonstration, examples
---

## Demonstrate Format Through Example

Describing a format in words is less reliable than showing it. When you need a specific output structure, provide a concrete example of the exact format you want. This works for JSON schemas, report structures, and any structured output.

**Incorrect (what's wrong):**

```text
Return a JSON object with the analysis results including fields for
score, summary, and recommendations array.
```

**Correct (what's right):**

```text
Return results in this exact format:
{
  "score": 8.5,
  "summary": "Strong performance with room for improvement in retention",
  "recommendations": [
    "Reduce churn by improving onboarding",
    "Expand enterprise tier"
  ]
}
```
