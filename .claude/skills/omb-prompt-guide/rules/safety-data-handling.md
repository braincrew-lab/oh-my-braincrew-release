---
title: Set Rules for Sensitive Data Handling
impact: MEDIUM
impactDescription: Prevents data leaks
tags: sensitive-data, security, privacy
---

## Set Rules for Sensitive Data Handling

When prompts involve sensitive data (API keys, credentials, PII), include explicit handling rules. Tell Claude what not to log, echo, or include in output. This is especially important for agent systems that may write to files or external services.

**Incorrect (exposes secret directly in prompt):**

```text
Here is my API key: sk-... Use it to call the service.
```

**Correct (uses env var, sets output constraints):**

```text
The API key is available in the environment variable OPENAI_API_KEY.
Never log, print, or include API keys in output. Use the environment
variable directly in code.
```
