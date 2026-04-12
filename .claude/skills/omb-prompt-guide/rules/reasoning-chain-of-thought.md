---
title: Ask Claude to Think Step-by-Step
impact: HIGH
impactDescription: Up to 39% quality improvement
tags: chain-of-thought, reasoning, step-by-step
---

## Ask Claude to Think Step-by-Step

For complex problems, asking Claude to think through the problem before answering significantly improves accuracy. Use thinking tags or explicit instructions to reason through problems. This is especially effective for math, logic, and multi-step analysis.

**Incorrect (no guidance on reasoning process):**

```text
What is the optimal database indexing strategy for this schema?
```

**Correct (explicit reasoning steps before answering):**

```text
What is the optimal database indexing strategy for this schema?

Before answering, think through:
1. Which queries are most frequent?
2. What are the read/write patterns?
3. What trade-offs exist between index count and write performance?
```
