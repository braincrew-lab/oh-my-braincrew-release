---
description: Verification rules for validating implementation correctness
---

# Verification Rules

## Verification Order
1. **Automated checks FIRST** — type checker, linter, tests, build
2. **Manual inspection SECOND** — code review, architecture alignment

Never skip automated checks. If they fail, fix before proceeding.

## Automated Checks (must all pass)
- Type check: `mypy` (Python), `tsc --noEmit` (TypeScript)
- Lint: `ruff` (Python), `eslint` (TypeScript)
- Tests: full test suite for affected modules
- Build: project must compile/build without errors

## Evidence-Based Reporting
Every finding MUST include:
- **File path and line number**: `src/api/routes.py:42`
- **What was found**: concrete description
- **Severity**: PASS, FAIL, or WARNING
- **How to reproduce**: command or steps

## PASS/FAIL Criteria

### PASS requires ALL of:
- All automated checks pass
- Deliverable matches plan specification
- No unhandled error paths
- Boundary validation present

### FAIL if ANY of:
- Type checker or linter errors
- Test failures
- Missing deliverable
- Security vulnerability detected
- Unvalidated boundary input

## Verification Report Format
```
RESULT: PASS | FAIL
Automated: [pass/fail counts]
Findings:
  - [severity] file:line — description
```
