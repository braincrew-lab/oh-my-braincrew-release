---
title: System Prompt Defines WHO, User Prompt Defines WHAT
impact: HIGH
impactDescription: Foundation of prompt architecture
tags: system-prompt, user-prompt, role
---

## System Prompt Defines WHO, User Prompt Defines WHAT

The system prompt establishes Claude's identity, expertise, and behavioral baseline. The user prompt provides the specific task. Never put task instructions in the system prompt; never put identity in the user prompt.

**Incorrect (what's wrong):**

```text
System: "You are helpful. Analyze the following data and return JSON."
User: "Here is the data..."
```

**Correct (what's right):**

```text
System: "You are a senior data analyst specializing in SaaS metrics."
User: "Analyze the following quarterly revenue data. Return findings as JSON."
```
