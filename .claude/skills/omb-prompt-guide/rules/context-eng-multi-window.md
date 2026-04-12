---
title: Design for Multi-Context-Window Workflows
impact: HIGH
impactDescription: Enables indefinite autonomous work across sessions
tags: context-engineering, multi-window, state, persistence
---

## Design for Multi-Context-Window Workflows

Long tasks span multiple context windows. Design prompts that help Claude persist state, discover prior progress, and resume without losing work. Use the first window to set up frameworks (tests, scripts), then iterate with subsequent windows on a todo-list.

**Incorrect (no state management across windows):**

```text
Continue working on the migration.
```

**Correct (structured state recovery):**

```text
Your context window will be automatically compacted as it approaches
its limit. Do not stop tasks early due to token budget concerns.

When starting a new context window:
1. Review progress.md and tests.json for current state
2. Check git log for what was completed
3. Run the integration test suite before implementing new features
4. Update progress.md after each completed component

State files:
- tests.json: structured test status (JSON)
- progress.md: freeform progress notes
- init.sh: setup script for servers/linters
```

**First-window setup pattern:**

```text
This is the beginning of a long task. Before implementing:
1. Write tests in tests.json that define success
2. Create init.sh to set up the dev environment
3. Create progress.md for tracking state
4. Then start implementing from the task list
```

Reference: [Anthropic Prompting Best Practices — Multi-Window Workflows](https://platform.claude.com/docs/en/docs/build-with-claude/prompt-engineering/claude-prompting-best-practices)
