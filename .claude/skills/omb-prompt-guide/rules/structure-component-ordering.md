---
title: Follow the 10-Component Framework Order
impact: CRITICAL
impactDescription: Optimal information processing order
tags: ordering, framework, components
---

## Follow the 10-Component Framework Order

Anthropic's recommended prompt structure places components in this order for optimal processing: (1) system_prompt/role, (2) tone, (3) background/documents, (4) task with objective+constraints, (5) rules (MUST/MUST NOT), (6) examples, (7) conversation history, (8) immediate task, (9) thinking instructions, (10) output format. Not all components are required for every prompt.

**Incorrect (what's wrong):**

```text
<format>JSON output</format>
<task>Analyze the data</task>
<system_prompt>You are an analyst</system_prompt>
```

**Correct (what's right):**

```text
<system_prompt>You are a data analyst</system_prompt>
<task>Analyze the quarterly revenue data</task>
<format>Return results as JSON with keys: trend, insight, recommendation</format>
```
