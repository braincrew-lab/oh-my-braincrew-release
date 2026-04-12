---
title: Instruct Independent Tool Calls to Run in Parallel
impact: MEDIUM-HIGH
impactDescription: 2-5x speed improvement for multi-tool tasks
tags: parallel, performance, tools
---

## Instruct Independent Tool Calls to Run in Parallel

Claude 4.6 models excel at parallel tool execution natively, but explicit instruction boosts success to ~100%. Use the `<use_parallel_tool_calls>` XML wrapper for maximum reliability. Only parallelize truly independent calls; sequential calls that depend on prior results must wait.

**Incorrect (sequential when parallel is possible):**

```text
Read each of these 5 files one at a time.
```

**Correct (explicit parallel instruction):**

```text
Read all 5 files in parallel since they are independent:
- src/auth.py
- src/models.py
- src/routes.py
- src/middleware.py
- src/config.py
```

**XML wrapper pattern (for system prompts):**

```xml
<use_parallel_tool_calls>
If you intend to call multiple tools and there are no dependencies
between the tool calls, make all of the independent tool calls in
parallel. Maximize use of parallel tool calls where possible to
increase speed and efficiency. However, if some tool calls depend
on previous calls to inform dependent values, do NOT call these
tools in parallel and instead call them sequentially. Never use
placeholders or guess missing parameters in tool calls.
</use_parallel_tool_calls>
```

**To reduce parallel execution** (for rate-limited APIs or stability):

```text
Execute operations sequentially with brief pauses between each
step to ensure stability.
```

Reference: [Anthropic Prompting Best Practices — Parallel Tool Calling](https://platform.claude.com/docs/en/docs/build-with-claude/prompt-engineering/claude-prompting-best-practices)
