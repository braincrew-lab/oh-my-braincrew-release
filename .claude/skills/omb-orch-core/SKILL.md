---
name: omb-orch-core
description: "Core orchestration — exploration and critique workflows. Use when you need codebase analysis or plan review."
user-invocable: true
argument-hint: "[task description]"
---

# Core Domain Workflow

You (main session) orchestrate by spawning sub-agents in sequence using the Agent() tool.

Sub-agents CANNOT spawn other sub-agents. Only you (the main session) can orchestrate.

## Steps

1. **Explore** — Spawn @core-explore with the task description
   - Wait for result envelope
   - Expect: `<omb>DONE</omb>`
   - On `<omb>BLOCKED</omb>`: surface to user
   - The explorer will analyze the codebase, gather context, and produce findings

2. **Critique** (when reviewing plans or designs) — Spawn @core-critique with the exploration output or a plan/design to review
   - On `<omb>DONE</omb>` (verdict: APPROVE): workflow complete, present results to user. If concerns are listed, include them.
   - On `<omb>RETRY</omb>` (verdict: REJECT): re-spawn @core-explore with critique feedback appended to the original task (max 2 retries)

## Retry Policy

- Explore retries: max 2 (after critique `<omb>RETRY</omb>`)
- After max retries exceeded: ask the user for guidance

## Context Passing

Pass the previous agent's result summary to the next agent. Include:
- The original task description
- Exploration findings and analysis
- Any concerns or questions raised
- Relevant file paths and code references discovered

## When to Use

- Codebase analysis and understanding
- Architecture review
- Plan or design critique
- Exploratory investigation before implementation
- Gathering context for other orchestration workflows
