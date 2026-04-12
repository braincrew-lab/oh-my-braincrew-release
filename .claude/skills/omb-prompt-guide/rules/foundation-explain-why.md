---
title: Explain the Reason Behind Rules
impact: HIGH
impactDescription: Enables intelligent generalization
tags: motivation, reasoning, context
---

## Explain the Reason Behind Rules

When giving constraints, explain WHY. Claude can generalize from reasoning, so understanding the motivation produces better adherence than blind rules. This is especially important for non-obvious constraints.

**Incorrect (what's wrong):**

```text
Never use ellipses in the output.
```

**Correct (what's right):**

```text
Never use ellipses in the output because it will be read by a text-to-speech engine that cannot pronounce them.
```
