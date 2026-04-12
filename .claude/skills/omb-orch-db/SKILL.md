---
name: omb-orch-db
description: "Database domain end-to-end orchestration. design → critique → implement → verify."
user-invocable: true
argument-hint: "[task description]"
---

# Database Domain Workflow

You (main session) orchestrate by spawning sub-agents in sequence using the Agent() tool.

Sub-agents CANNOT spawn other sub-agents. Only you (the main session) can orchestrate.

## Tech Context

- PostgreSQL (primary), SQLAlchemy 2.0 async (DeclarativeBase, Mapped types, typed relationships), Alembic with naming conventions
- Repository pattern for typed data access layer (async CRUD with explicit return types)
- Redis for caching/queuing (redis.asyncio)
- Project rules: `.claude/rules/db/postgres.md` (naming, indexing, migration safety), `.claude/rules/db/redis.md` (key patterns, TTL)
- TDD workflow: RED-GREEN-IMPROVE per `workflow/05-test.md`

## Steps

1. **Design** — Spawn @db-design with the task description
   - Wait for result envelope
   - Expect: `<omb>DONE</omb>`
   - On `<omb>BLOCKED</omb>`: surface to user
   - The designer will produce ORM model class definitions (Mapped types, relationships), migration plans, index strategies, repository interfaces, and Redis patterns

2. **Critique** (optional but recommended) — Spawn @core-critique with the design output
   - On `<omb>DONE</omb>` (verdict: APPROVE): proceed to step 3. If concerns are listed, note them.
   - On `<omb>RETRY</omb>` (verdict: REJECT): re-spawn @db-design with critique feedback (max 2 retries)

3. **Implement** — Spawn @db-implement with the approved design
   - Wait for result envelope
   - Expect: `<omb>DONE</omb>`
   - The implementer will create models, migrations, repositories, tests, and queries following TDD cycle

4. **Verify** — Spawn @db-verify to validate the implementation
   - On `<omb>DONE</omb>` (verdict: PASS): workflow complete
   - On `<omb>RETRY</omb>` (verdict: FAIL): spawn @code-debug with failure details, then retry step 3 (max 3 retries)

## Retry Policy

- Design retries: max 2 (after critique `<omb>RETRY</omb>`)
- Implement retries: max 3 (after verify `<omb>RETRY</omb>`, with code-debug between)
- After max retries exceeded: ask the user for guidance

## Context Passing

Pass the previous agent's result summary to the next agent. Include:
- The original task description
- ORM model class definitions with Mapped types and relationship configurations
- Repository interface signatures (method names, parameters, return types)
- PostgreSQL-specific features used (JSONB, arrays, partial indexes, enums)
- Migration strategy and ordering
- Any concerns flagged by critique
- Changed files list from implement (for verify)
- Test file locations (for verify to run)
