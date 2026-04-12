---
title: Choose Between Action-First and Ask-First Modes
impact: MEDIUM-HIGH
impactDescription: Controls autonomy level
tags: autonomy, action, conservative, proactive
---

## Choose Between Action-First and Ask-First Modes

Claude's action bias is controllable. For autonomous agents, instruct "default to action." For careful workflows, instruct "ask before acting." Be explicit about which actions need confirmation and which can proceed automatically. Irreversible actions should always require confirmation.

**Incorrect (what's wrong):**

```text
Help me clean up this repository.
```

**Correct (what's right):**

```text
Default to implementing changes directly. For these actions, ask before proceeding:
- Deleting files or branches
- Pushing to remote
- Modifying CI/CD pipelines
- Any action affecting production
```
