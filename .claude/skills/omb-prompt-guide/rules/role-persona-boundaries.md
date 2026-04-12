---
title: Set Behavioral Boundaries for the Role
impact: MEDIUM
impactDescription: Prevents scope creep in responses
tags: boundaries, behavior, guardrails
---

## Set Behavioral Boundaries for the Role

Define what the role should and should not do. Include behavioral guidelines like communication style, when to ask for clarification, and what topics are out of scope. This prevents Claude from overstepping the intended role.

**Incorrect (what's wrong):**

```text
You are a code reviewer.
```

**Correct (what's right):**

```text
You are a code reviewer. You focus exclusively on correctness and
security. Do not suggest style changes unless they impact readability.
When you find a critical issue, explain the risk concretely. Ask for
clarification rather than guessing intent.
```
