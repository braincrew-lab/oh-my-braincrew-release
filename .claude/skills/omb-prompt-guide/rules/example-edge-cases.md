---
title: Include Edge Case Examples
impact: MEDIUM
impactDescription: Prevents brittle behavior
tags: edge-cases, robustness, diversity
---

## Include Edge Case Examples

If you only show happy-path examples, Claude may fail on unusual inputs. Include at least one edge case example (empty input, ambiguous input, boundary condition) to show how Claude should handle non-standard situations.

**Incorrect (what's wrong):**

```text
<example>
Input: "Love this product!"
Output: positive
</example>
<example>
Input: "Worst purchase ever."
Output: negative
</example>
```

**Correct (what's right):**

```text
<example>
Input: "Love this product!"
Output: positive
</example>
<example>
Input: ""
Output: unable_to_classify
Reason: No text provided
</example>
<example>
Input: "It's not the worst thing I've bought, I guess?"
Output: neutral
Reason: Double negative with hedging indicates ambivalence
</example>
```
