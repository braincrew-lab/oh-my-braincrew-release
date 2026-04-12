---
description: Implementation rules for coding tasks
---

# Implementation Rules

## Scope Guard
- Implement ONLY what the design document specifies
- If a change seems needed but is not in the plan, flag it — do not implement
- No gold-plating: no extra features, no premature optimization
- If blocked, report the blocker rather than working around it silently

## Code Conventions
- Match existing project conventions (naming, structure, patterns)
- Follow the language style already established in the codebase
- Use the same import style, error handling, and logging patterns
- If no convention exists, follow the relevant language rule file

## Boundary Validation
- Validate all inputs at system boundaries (API endpoints, CLI args, file I/O)
- Never trust data crossing a boundary — parse, validate, then use
- Use typed schemas (Pydantic, Zod) at boundaries, not raw dicts/objects

## Implementation Checklist (TDD)
1. Read the relevant design/plan section first
2. Check for existing utilities before writing new ones
3. **Write a failing test for the target behavior (RED)**
4. **Write minimal implementation to make the test pass (GREEN)**
5. **Refactor while tests stay green (IMPROVE)**
6. Add error handling for all failure modes
7. Run type checker and linter — code MUST pass before marking done
8. Verify the deliverable matches what the plan specifies

## Self-Check Before Done
Before reporting completion, verify:
- [ ] Type checker passes (`mypy`/`tsc --noEmit`)
- [ ] Linter passes (`ruff`/`eslint`)
- [ ] All tests pass
- [ ] No TODO/FIXME without a linked issue
- [ ] No debug statements (`console.log`, `print()`)
- [ ] No commented-out code blocks
- [ ] Deliverable matches the plan specification

## What NOT to Do
- Do not refactor unrelated code
- Do not update dependencies unless the plan requires it
- Do not add TODO comments without a linked task
- Do not commit dead code or commented-out blocks
