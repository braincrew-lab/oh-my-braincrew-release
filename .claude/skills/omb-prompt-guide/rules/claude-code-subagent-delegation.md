---
title: Delegate to Subagents for Investigation
impact: MEDIUM-HIGH
impactDescription: Preserves main context; enables parallel work
tags: claude-code, subagents, delegation, context-efficiency
---

## Delegate to Subagents for Investigation

Subagents run in separate context windows and report back summaries. Use them for investigation, review, and parallel workstreams that would otherwise fill your main context with file reads. However, Claude Opus 4.6 may overuse subagents — add guidance for when direct action is faster.

**Incorrect (cluttering main context with research):**

```text
Read through all files in src/auth/, src/middleware/, and src/session/
to understand how authentication works, then implement OAuth.
```

**Correct (delegating investigation, keeping main context clean):**

```text
Use subagents to investigate how our authentication system handles
token refresh, and whether we have any existing OAuth utilities.
Then implement OAuth based on the findings.
```

**When to use subagents:**
- Tasks that can run in parallel
- Research that requires reading many files
- Independent code review after implementation
- Isolated workstreams that don't share state

**When NOT to use subagents:**
- Simple tasks (single grep, single file edit)
- Sequential operations where context must carry over
- Tasks where you need to maintain state across steps

```text
Use subagents when tasks can run in parallel, require isolated context,
or involve independent workstreams. For simple tasks, single-file edits,
or tasks where you need cross-step context, work directly.
```

Reference: [Claude Code Best Practices — Subagents](https://code.claude.com/docs/en/best-practices)
