---
name: omb-orch-ai
description: "AI/ML domain end-to-end orchestration. design → critique → implement → verify."
user-invocable: true
argument-hint: "[task description]"
---

# AI/ML Domain Workflow

You (main session) orchestrate by spawning sub-agents in sequence using the Agent() tool.

Sub-agents CANNOT spawn other sub-agents. Only you (the main session) can orchestrate.

## Tech Context

LangGraph, LangChain, prompt engineering, embeddings, vector stores, RAG, agent architectures, model selection, token optimization

## Steps

0. **Architecture** (optional, for complex or greenfield tasks) — Spawn @ai-architect with the task description
   - Wait for result envelope
   - Expect: `<omb>DONE</omb>`
   - On `<omb>BLOCKED</omb>`: surface to user
   - The architect will produce framework selection, system topology, component boundaries, and integration points
   - Pass architecture output as context to step 1 (Design)
   - Skip this step for small additions to existing AI code where the framework is already established

1. **Design** — Spawn @ai-design with the task description (and architecture output if step 0 was run)
   - Wait for result envelope
   - Expect: `<omb>DONE</omb>`
   - On `<omb>BLOCKED</omb>`: surface to user
   - The designer will produce graph topology, node definitions, prompt templates, tool schemas, and model selection rationale

2. **Critique** (optional but recommended) — Spawn @core-critique with the design output
   - On `<omb>DONE</omb>` (verdict: APPROVE): proceed to step 3. If concerns are listed, note them.
   - On `<omb>RETRY</omb>` (verdict: REJECT): re-spawn @ai-design with critique feedback (max 2 retries)

3. **Implement** — Spawn @ai-implement with the approved design
   - Wait for result envelope
   - Expect: `<omb>DONE</omb>`
   - The implementer will create graph definitions, nodes, prompt templates, tool integrations, and chains

4. **Verify** — Spawn @ai-verify to validate the implementation
   - On `<omb>DONE</omb>` (verdict: PASS): workflow complete
   - On `<omb>RETRY</omb>` (verdict: FAIL): spawn @code-debug with failure details, then retry step 3 (max 3 retries)

## Retry Policy

- Design retries: max 2 (after critique `<omb>RETRY</omb>`)
- Implement retries: max 3 (after verify `<omb>RETRY</omb>`, with code-debug between)
- After max retries exceeded: ask the user for guidance

## Context Passing

Pass the previous agent's result summary to the next agent. Include:
- The original task description
- Graph topology and node responsibilities
- Prompt templates and model configuration
- Any concerns flagged by critique
- Changed files list from implement (for verify)
