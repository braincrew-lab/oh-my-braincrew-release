---
title: Maintain Structured State for Multi-Step Tasks
impact: MEDIUM
impactDescription: Enables reliable long-running agent tasks
tags: state, tracking, agent, multi-step
---

## Maintain Structured State for Multi-Step Tasks

For tasks spanning many steps or context windows, instruct Claude to maintain state in structured files. Use JSON for machine-readable state and markdown for human-readable progress. Git commits serve as checkpoints. This prevents state loss during context compression.

**Incorrect (what's wrong):**

```text
Work through the TODO list until everything is done.
```

**Correct (what's right):**

```text
Track progress in progress.md and status.json. After completing each task:
1. Update status.json with the task status
2. Commit the changes with a descriptive message
3. Update progress.md with what was done and what's next
4. Continue to the next task
```
