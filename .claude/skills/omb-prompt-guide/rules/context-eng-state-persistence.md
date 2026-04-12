---
title: Use Structured State Files for Long Tasks
impact: MEDIUM-HIGH
impactDescription: Prevents work loss on context refresh
tags: context-engineering, state, persistence, git, json
---

## Use Structured State Files for Long Tasks

For tasks that outlive a single context window, persist progress in state files. Use structured formats (JSON) for data with schemas (test results, task status). Use unstructured text for progress notes. Use git for checkpointing and rollback.

**Incorrect (relying solely on context memory):**

```text
Keep track of which files you've migrated.
```

**Correct (structured state with file persistence):**

```text
Track progress using these state files:

tests.json — structured test status:
{
  "tests": [
    {"id": 1, "name": "auth_flow", "status": "passing"},
    {"id": 2, "name": "user_mgmt", "status": "failing"}
  ],
  "total": 50, "passing": 35, "failing": 10, "not_started": 5
}

progress.md — freeform notes:
Session 3 progress:
- Fixed auth token validation
- Next: investigate user_mgmt test failures (test #2)
- Note: Do not remove tests — could mask bugs

Use git commits as checkpoints after each completed component.
```

**State format guidance:**
- JSON for schemas and countable data (tests, tasks, configs)
- Markdown for freeform context (decisions, next steps, blockers)
- Git for versioned checkpoints (commit after each milestone)
- Never rely on context memory alone for multi-session work

Reference: [Anthropic Prompting Best Practices — State Management](https://platform.claude.com/docs/en/docs/build-with-claude/prompt-engineering/claude-prompting-best-practices)
