---
title: Save Progress Across Context Windows
impact: MEDIUM
impactDescription: Enables reliable long-running tasks
tags: multi-window, state, persistence
---

## Save Progress Across Context Windows

For tasks that span multiple context windows, instruct Claude to save progress to files before context runs out. Use structured files (progress.md, status.json) and git commits as checkpoints. Tell Claude not to stop early due to token budget concerns.

**Incorrect (no guidance on persistence):**

```text
Complete all the tasks in the TODO list.
```

**Correct (explicit persistence and continuation strategy):**

```text
Work through the TODO list. Save progress to progress.md after
each completed item. Commit working code frequently. Do not stop
early due to context limits — your context will be refreshed
automatically.
```
