---
title: Use Thinking Blocks for Complex Analysis
impact: HIGH
impactDescription: Deeper reasoning on multi-step problems
tags: extended-thinking, adaptive-thinking, reflection, effort
---

## Use Thinking Blocks for Complex Analysis

Claude 4.6 models use **adaptive thinking** (`thinking: {type: "adaptive"}`), which dynamically decides when and how much to think based on query complexity and the `effort` parameter. This supersedes the deprecated `budget_tokens` approach. Prefer general instructions ("think thoroughly") over prescriptive step-by-step plans — Claude's reasoning frequently exceeds what a human would prescribe.

**API configuration (adaptive thinking):**

```python
# Preferred: adaptive thinking with effort control
client.messages.create(
    model="claude-opus-4-6",
    max_tokens=64000,
    thinking={"type": "adaptive"},
    output_config={"effort": "high"},  # low, medium, high, max
    messages=[{"role": "user", "content": "..."}],
)
```

**Incorrect (prescriptive steps that constrain reasoning):**

```text
Step 1: Read the file
Step 2: List all functions
Step 3: Find the bug
Step 4: Fix the bug
```

**Correct (general instruction that lets Claude reason freely):**

```text
Read the file. After reading, reflect on the code structure and
identify the root cause before making changes. Use your thinking
to plan the fix, then implement it.
```

**Steering adaptive thinking frequency:**

If Claude thinks too often (inflating tokens on simple queries):
```text
Extended thinking adds latency and should only be used when it will
meaningfully improve answer quality — typically for problems requiring
multi-step reasoning. When in doubt, respond directly.
```

If Claude doesn't think enough on complex tasks:
```text
After receiving tool results, carefully reflect on their quality and
determine optimal next steps before proceeding.
```

**Multishot examples with thinking:** Use `<thinking>` tags inside few-shot examples to demonstrate the reasoning pattern. Claude generalizes the style to its own thinking blocks.

Reference: [Anthropic — Adaptive Thinking](https://platform.claude.com/docs/en/build-with-claude/adaptive-thinking)
