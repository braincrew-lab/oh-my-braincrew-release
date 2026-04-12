---
title: Define Sub-Agent Boundaries and Escalation
impact: MEDIUM
impactDescription: Prevents autonomous overreach
tags: agent, constraints, escalation, boundaries
---

## Define Sub-Agent Boundaries and Escalation

In multi-agent systems, each agent needs clear boundaries. Define what each agent can and cannot do. Specify when to escalate to the user vs proceed autonomously. Reversible local actions (file edits, test runs) can proceed; irreversible shared actions (push, deploy, delete) need confirmation.

**Incorrect (unbounded scope, no escalation path):**

```text
Fix whatever issues you find.
```

**Correct (scoped permissions with escalation rules):**

```text
You may edit files in /src and run tests. You must NOT:
- Modify files outside /src
- Install new dependencies
- Push to remote
If blocked, report the blocker and stop. Do not work around blockers
silently.
```
