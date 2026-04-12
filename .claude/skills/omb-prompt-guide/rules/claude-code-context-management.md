---
title: Manage Context Window Aggressively
impact: HIGH
impactDescription: Context fill is the primary cause of Claude Code degradation
tags: claude-code, context, compaction, clear, performance
---

## Manage Context Window Aggressively

Claude's context window holds your entire conversation — every message, file read, and command output. Performance degrades as it fills. This is the most important resource to manage. Use /clear between unrelated tasks, scope investigations narrowly, and delegate research to subagents.

**Incorrect (kitchen-sink session):**

```text
[Start with auth task]
Fix the login bug
[Then switch to unrelated task without clearing]
Now add a calendar widget to the dashboard
[Then switch again]
What's the test coverage for the API?
```

**Correct (clean context per task):**

```text
[Session 1: Auth fix]
Fix the login bug in src/auth/. Check token refresh logic.
Write a failing test, then fix.

[/clear]

[Session 2: New feature]
Add a calendar widget. See HotDogWidget.php for the pattern.

[/clear]

[Session 3: Investigation]
Use subagents to investigate test coverage for the API module.
```

**Key practices:**
- `/clear` between unrelated tasks
- `/compact <focus>` to preserve specific context during compaction
- Use subagents for investigation to keep main context clean
- Scope file reads narrowly — don't read entire directories
- After 2+ failed corrections, `/clear` and write a better initial prompt
- For long tasks: "Save progress to a state file before context refreshes"

Reference: [Claude Code Best Practices — Context Management](https://code.claude.com/docs/en/best-practices)
