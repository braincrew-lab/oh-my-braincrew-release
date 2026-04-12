---
title: Use XML Tags for Semantic Boundaries
impact: CRITICAL
impactDescription: Prevents misinterpretation in complex prompts
tags: xml, structure, boundaries, parsing
---

## Use XML Tags for Semantic Boundaries

XML tags help Claude clearly parse different sections of complex prompts. Wrap distinct content types (instructions, context, examples, input) in descriptive tags. Use consistent, descriptive tag names throughout.

**Incorrect (what's wrong):**

```text
Here is the context: The user database has 50K records.
Now here are the instructions: Find inactive users.
And here is an example: User ID 123 last active 2024-01-01.
```

**Correct (what's right):**

```text
<context>
The user database has 50K records.
</context>
<instructions>
Find inactive users who have not logged in for 90+ days.
</instructions>
<examples>
User ID 123, last active 2024-01-01 → inactive
</examples>
```
