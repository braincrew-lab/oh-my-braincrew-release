---
name: omb-orch-code
description: "Code quality domain orchestration. review → debug → test."
user-invocable: true
argument-hint: "[task description]"
---

# Code Quality Domain Workflow

You (main session) orchestrate by spawning sub-agents in sequence using the Agent() tool.

Sub-agents CANNOT spawn other sub-agents. Only you (the main session) can orchestrate.

## Tech Context

Linting, static analysis, testing frameworks, refactoring patterns, code coverage, type checking, formatting

## Steps

1. **Review** — Spawn @code-review with the task description
   - Wait for result envelope
   - Expect: `<omb>DONE</omb>`
   - On `<omb>BLOCKED</omb>`: surface to user
   - The reviewer will analyze code quality, patterns, maintainability, and correctness
   - Produces a findings list with categories (bug, style, performance, security)

2. **Debug** (conditional — only if review found issues) — Spawn @code-debug with the review findings
   - Wait for result envelope
   - Expect: `<omb>DONE</omb>`
   - The debugger will diagnose identified issues and provide fix recommendations
   - If no issues found in review, skip to step 3

3. **Test** — Spawn @code-test to validate the codebase or the applied fixes
   - On `<omb>DONE</omb>`: workflow complete
   - On `<omb>RETRY</omb>`: spawn @code-debug with test failure details, then retry step 3 (max 3 retries)
   - The tester will run existing tests, add missing coverage, and verify fixes

## Retry Policy

- Debug/Test retries: max 3 (after test `<omb>RETRY</omb>`, with code-debug between)
- After max retries exceeded: ask the user for guidance

## Context Passing

Pass the previous agent's result summary to the next agent. Include:
- The original task description
- Review findings with category and severity
- Specific file paths and line numbers with issues
- Changed files list from debug (for test)
- Test commands and expected behavior
