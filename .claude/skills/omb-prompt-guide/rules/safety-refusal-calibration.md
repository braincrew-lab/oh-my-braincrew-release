---
title: Avoid Making Claude Overcautious
impact: MEDIUM
impactDescription: Prevents unnecessary refusals
tags: refusal, calibration, overcaution
---

## Avoid Making Claude Overcautious

Overly aggressive safety prompting can make Claude refuse valid requests or add excessive disclaimers. Claude 4.6 models are well-calibrated; reduce legacy safety language. Provide context for why an action is safe rather than demanding compliance.

**Incorrect (aggressive directives trigger overcaution):**

```text
CRITICAL: You MUST use this tool when needed. ALWAYS do this.
NEVER refuse.
```

**Correct (calm context reduces false refusals):**

```text
Use this tool when it would help answer the question. This is a
development environment, so file edits are safe and reversible.
```
