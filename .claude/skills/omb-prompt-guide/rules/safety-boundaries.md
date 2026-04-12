---
title: Define Explicit MUST NOT Rules
impact: MEDIUM
impactDescription: Prevents unintended actions
tags: boundaries, must-not, guardrails, reversibility
---

## Define Explicit MUST NOT Rules

Clearly state what Claude must not do. Positive instructions ("do X") are generally better than negative ones, but safety boundaries require explicit prohibitions. Use MUST NOT for hard constraints. For agentic systems, use a **reversibility framework** that categorizes actions by blast radius.

**Incorrect (vague, no actionable constraint):**

```text
Be careful with the code.
```

**Correct (explicit prohibitions with clear scope):**

```text
MUST NOT:
- Delete files outside the /src directory
- Push directly to the main branch
- Modify .env files
- Run commands with sudo
```

**Reversibility framework (for autonomous agents):**

```text
Consider the reversibility and potential impact of your actions.

FREELY proceed with (local, reversible):
- Editing files, running tests, reading code, creating branches

ASK BEFORE (hard to reverse or shared):
- Destructive: deleting files/branches, rm -rf, dropping tables
- Irreversible: git push --force, git reset --hard
- Visible to others: pushing code, commenting on PRs, sending messages

When encountering obstacles, do not use destructive actions as a
shortcut. Don't bypass safety checks (--no-verify) or discard
unfamiliar files that may be in-progress work.
```

Reference: [Anthropic Prompting Best Practices — Autonomy and Safety](https://platform.claude.com/docs/en/docs/build-with-claude/prompt-engineering/claude-prompting-best-practices)
