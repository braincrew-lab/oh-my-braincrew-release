---
title: Provide Multiple Input-Output Examples
impact: HIGH
impactDescription: Most reliable way to steer output format and tone
tags: few-shot, multishot, examples, consistency
---

## Provide Multiple Input-Output Examples

Include 1-5 examples of desired input-output pairs. This is more reliable than describing the format. Wrap examples in `<example>` tags so Claude distinguishes them from instructions. Vary examples enough to prevent Claude from picking up unintended patterns.

**Incorrect (what's wrong):**

```text
Classify the sentiment of each review as positive, negative, or neutral.
```

**Correct (what's right):**

```text
<examples>
<example>
Input: "The product arrived on time and works great!"
Output: positive
</example>
<example>
Input: "Terrible quality, broke after one day."
Output: negative
</example>
<example>
Input: "It does what it says. Nothing special."
Output: neutral
</example>
</examples>

Classify the sentiment of the following review:
```
