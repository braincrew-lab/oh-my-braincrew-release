---
title: Optimize Token Utility
impact: MEDIUM
impactDescription: More useful work per context window
tags: context-engineering, tokens, efficiency, budget
---

## Optimize Token Utility

Every token in the context window competes for Claude's attention. Maximize the ratio of useful information to total tokens. Scope file reads narrowly, avoid reading entire directories, and use compaction strategically.

**Incorrect (wasting context on broad reads):**

```text
Read every file in the src/ directory so you understand the project.
```

**Correct (targeted, efficient context usage):**

```text
Read only the files relevant to the auth flow:
- src/auth/login.ts (the login handler)
- src/auth/types.ts (auth type definitions)
- src/middleware/session.ts (session management)

Do not read unrelated files. If you need more context during
implementation, read specific files as needed.
```

**Compaction guidance:**

```text
When compacting, preserve:
- The full list of modified files
- All test commands and their results
- Key architectural decisions made
- Current task status and next steps
```

**Token-efficient investigation:**

```text
Use subagents for broad investigation. They explore in separate
context windows and return only summaries — keeping your main
context focused on implementation.
```

Reference: [Claude Code Best Practices — Context Management](https://code.claude.com/docs/en/best-practices)
