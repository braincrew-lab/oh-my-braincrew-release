---
title: Use Nested Tags for Complex Structures
impact: HIGH
impactDescription: Clarifies relationships in multi-part prompts
tags: nesting, hierarchy, complex-prompts
---

## Use Nested Tags for Complex Structures

When a prompt has natural parent-child relationships, use nested XML tags. For example, a task contains an objective and constraints; a documents section contains multiple individual documents. Nesting makes the hierarchy explicit.

**Incorrect (what's wrong):**

```text
<objective>Design an API</objective>
<constraints>Must handle 10K RPS</constraints>
<constraints>Must use REST</constraints>
```

**Correct (what's right):**

```text
<task>
  <objective>Design an API for user management</objective>
  <constraints>
    - Must handle 10K requests per second
    - Must follow REST conventions
    - Must support pagination
  </constraints>
</task>
```
