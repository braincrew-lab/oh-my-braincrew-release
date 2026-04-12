---
title: Require Investigation Before Answering
impact: MEDIUM-HIGH
impactDescription: Eliminates speculative answers
tags: hallucination, grounding, investigation
---

## Require Investigation Before Answering

Claude may confidently describe code, files, or APIs it hasn't actually read. Instruct Claude to read and investigate before making claims. This is critical for code-related tasks where a wrong assumption can lead to broken implementations.

**Incorrect (invites speculation):**

```text
What does the authenticate() function do?
```

**Correct (requires grounding before answering):**

```text
Read the authenticate() function in src/auth.py first, then explain
what it does. Do not speculate about code you have not read.
```
