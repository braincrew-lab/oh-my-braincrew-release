---
name: omb-orch-api
description: "API domain end-to-end orchestration. design → critique → implement → verify."
user-invocable: true
argument-hint: "[task description]"
---

# API Domain Workflow

You (main session) orchestrate by spawning sub-agents in sequence using the Agent() tool.

Sub-agents CANNOT spawn other sub-agents. Only you (the main session) can orchestrate.

## Tech Context

FastAPI, Express, Fastify, Pydantic, OpenAPI, REST, GraphQL

## Steps

1. **Design** — Spawn @api-design with the task description
   - Wait for result envelope
   - Expect: `<omb>DONE</omb>`
   - On `<omb>BLOCKED</omb>`: surface to user
   - The designer will produce endpoint specs, request/response schemas, and routing structure

2. **Critique** (optional but recommended) — Spawn @core-critique with the design output
   - On `<omb>DONE</omb>` (verdict: APPROVE): proceed to step 3. If concerns are listed, note them.
   - On `<omb>RETRY</omb>` (verdict: REJECT): re-spawn @api-design with critique feedback (max 2 retries)

3. **Implement** — Spawn @api-implement with the approved design
   - Wait for result envelope
   - Expect: `<omb>DONE</omb>`
   - The implementer will create routes, handlers, schemas, and middleware

4. **Verify** — Spawn @api-verify to validate the implementation
   - On `<omb>DONE</omb>` (verdict: PASS): workflow complete
   - On `<omb>RETRY</omb>` (verdict: FAIL): spawn @code-debug with failure details, then retry step 3 (max 3 retries)

## Retry Policy

- Design retries: max 2 (after critique `<omb>RETRY</omb>`)
- Implement retries: max 3 (after verify `<omb>RETRY</omb>`, with code-debug between)
- After max retries exceeded: ask the user for guidance

## Context Passing

Pass the previous agent's result summary to the next agent. Include:
- The original task description
- Design decisions and constraints (endpoint paths, schemas, auth requirements)
- Any concerns flagged by critique
- Changed files list from implement (for verify)
