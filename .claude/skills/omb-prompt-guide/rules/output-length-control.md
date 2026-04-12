---
title: Specify Concrete Length Constraints
impact: MEDIUM-HIGH
impactDescription: Prevents over-verbose or too-brief responses
tags: length, verbosity, conciseness
---

## Specify Concrete Length Constraints

Use specific numbers instead of vague words. "Brief" and "concise" are subjective. Specify word counts, sentence counts, or paragraph counts. For sub-agent prompts, add "Report in under N words" to control context consumption.

**Incorrect (what's wrong):**

```text
Give me a brief overview.
```

**Correct (what's right):**

```text
Provide a 2-3 sentence overview of the architecture. Then list the top 3 risks in one sentence each.
```
