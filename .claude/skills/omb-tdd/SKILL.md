---
name: omb-tdd
description: "Enforce test-driven development across all domains. Stack-specific RED-GREEN-IMPROVE cycles, mock discipline, and 85%+ coverage gates. Load in implement and verify agents."
---

# Test-Driven Development Enforcement

This skill enforces strict TDD methodology across all implementation domains. It provides the RED-GREEN-IMPROVE cycle, mock discipline rules, coverage gates, and stack-specific testing guidance.

**Why this exists**: Agents bypass test quality by using loose mocks (empty objects, untyped MagicMock, `vi.fn()` with no type constraints) that pass but do not validate real behavior. This skill closes that gap.

## TDD Cycle — Strict Phase Gates

<tdd_cycle>
Every implementation task MUST follow this cycle. Phase violations result in `<omb>RETRY</omb>`.

### Phase 1: RED — Write a Failing Test

1. Read the design specification to identify the target behavior.
2. Write a test that describes the expected behavior with realistic inputs and outputs.
3. Run the test. It MUST fail. If it passes, the test is not testing new behavior — rewrite it.
4. Do NOT write or modify production code in this phase.

### Phase 2: GREEN — Write Minimal Code to Pass

1. Write the simplest implementation that makes the failing test pass.
2. Do NOT modify tests in this phase.
3. Do NOT add functionality beyond what the test requires.
4. Run all tests. All MUST pass.

### Phase 3: IMPROVE — Refactor While Green

1. Clean up duplication, improve naming, simplify logic.
2. Run tests after each refactoring change. All MUST stay green.
3. Do NOT add new functionality or expand scope.
4. Do NOT write new tests in this phase — that starts a new RED cycle.

### Example: One RED-GREEN-IMPROVE Cycle

<example>
```
RED:    Write test_create_user_returns_201_with_valid_data → Run → FAILS (endpoint missing)
GREEN:  Add POST /users route with minimal logic → Run → PASSES
IMPROVE: Extract validation to Pydantic model, add type hints → Run → still PASSES
RED:    Write test_create_user_returns_409_for_duplicate_email → Run → FAILS (no uniqueness check)
GREEN:  Add duplicate email check → Run → PASSES
...continue until all behaviors from the design spec are covered
```
</example>

### Iteration

Repeat RED-GREEN-IMPROVE for each behavior unit until the design specification is fully implemented. One test at a time — not batch.

### Phase Violations (auto-RETRY)

- Writing production code before a failing test exists → RETRY
- Modifying tests during GREEN phase → RETRY
- Adding new features during IMPROVE phase → RETRY
- Skipping the test run after GREEN or IMPROVE → RETRY
</tdd_cycle>

## Mock Discipline

<mock_discipline>
Read `rules/mock-discipline.md` for the complete rule set. Summary below.

### Scope: Mock ONLY at System Boundaries

| Boundary | Mock tool | Example |
|----------|-----------|---------|
| External HTTP API | `responses` (Python), `msw` (TypeScript) | Payment provider, third-party auth |
| Database | Real DB with transaction rollback (integration), typed fixtures (unit) | PostgreSQL test instance |
| File system | `tmp_path` (pytest), `vi.mock('fs')` with typed returns | Config file reads |
| Clock/time | `freezegun` (Python), `vi.useFakeTimers()` (TypeScript) | Scheduled job tests |
| Random/UUID | Seed or mock the generator | ID generation |

### NEVER Mock

- The module, class, or function under test
- Internal utility functions in the same project
- Pydantic/Zod validation (test with real schemas)
- SQLAlchemy models (use real DB or in-memory SQLite)

### Mock Realism Rules

1. Mock return values MUST match the actual API/DB response shape — use typed models or interfaces.
2. Mock error scenarios MUST use realistic error types (not generic `Exception` or `Error`).
3. Every mock MUST have at least one assertion verifying it was called with expected arguments.
4. Mocks that return empty objects (`{}`, `[]`, `None` without justification) trigger auto-FAIL.

### Banned vs Correct — Quick Reference

<example_bad>
```python
# BANNED: untyped mock, empty return, no call assertion
service = MagicMock()
service.get_user.return_value = {}
result = create_order(service, order_data)
assert result.status == "created"  # never verified service.get_user was called correctly
```
</example_bad>

<example_good>
```python
# CORRECT: spec= constraint, typed return, call assertion
service = MagicMock(spec=UserService)
service.get_user.return_value = User(id=1, name="Alice", email="alice@test.com")
result = create_order(service, order_data)
assert result.status == "created"
service.get_user.assert_called_once_with(user_id=order_data.user_id)
```
</example_good>

### Banned Patterns

Read `rules/mock-discipline.md` for the complete list with correct alternatives.
</mock_discipline>

## Coverage Gates

<coverage_gates>
Read `rules/coverage-gates.md` for enforcement commands per stack. Thresholds below.

| Scope | Minimum Line Coverage | Branch Coverage |
|-------|----------------------|-----------------|
| New code (changed files) | 85% | 80% |
| Critical paths (auth, payments, data mutations) | 95% | 90% |
| Utility/helper modules | 90% | 85% |
| Overall project | 85% (aspirational for legacy) | — |

### Measuring Coverage

**Python:**
```bash
pytest --cov=src --cov-report=term-missing --cov-fail-under=85 tests/
```

**TypeScript:**
```bash
vitest run --coverage --coverage.thresholds.lines=85
```

### What Counts as Coverage

- Line coverage: every executable line reached by at least one test
- Branch coverage: every `if/else`, `try/catch`, `match/case` branch exercised
- Coverage of mocked paths does NOT count toward coverage — the mock bypasses the real code

### Coverage Exclusions (legitimate)

- Migration files
- Configuration/bootstrap files
- Type stubs and interfaces (no runtime code)
- Generated code (OpenAPI clients, protobuf)
</coverage_gates>

## Stack-Specific Rules

<stack_rules>
Read the relevant rule file before writing tests for that domain.

| Domain | Rule file | Key patterns |
|--------|-----------|-------------|
| Python/FastAPI | `rules/tdd-python-fastapi.md` | httpx AsyncClient, Pydantic model testing, async fixtures |
| Python/Database | `rules/tdd-python-db.md` | Transaction rollback, factory fixtures, migration testing |
| Python/AI | `rules/tdd-python-ai.md` | Graph state testing, tool unit tests, prompt regression |
| TypeScript/React | `rules/tdd-typescript-react.md` | RTL queries, hook testing, MSW for API mocking |
| TypeScript/Electron | `rules/tdd-typescript-electron.md` | IPC handler testing, preload mock, main process isolation |

### Decision Tree

1. Identify which stack your implementation targets.
2. Read the corresponding rule file BEFORE writing any test.
3. Follow the file's test structure template.
4. Use the file's recommended fixtures and mock patterns.
</stack_rules>

## Integration with Implement Agents

<implement_integration>
When this skill is loaded in an implement agent, the execution order MUST include these TDD steps:

### Mandatory Execution Order Changes

Insert these steps after reading the design spec and existing code:

```
Step N:   RED — Write failing tests for the target behavior.
          Place tests in the correct directory per stack conventions.
          Use typed mock returns and realistic test data.
          Run tests — they MUST fail.
Step N+1: GREEN — Write minimal implementation to pass tests.
          Do NOT modify tests. Run all tests — they MUST pass.
Step N+2: IMPROVE — Refactor implementation while tests stay green.
          Run tests after each change.
```

Repeat for each behavior unit in the design.

### Self-Check Before DONE

Before reporting `<omb>DONE</omb>`, verify:

- [ ] Every public function/endpoint has at least one test
- [ ] Tests include both happy path and at least one error scenario
- [ ] No banned mock patterns used (check `rules/mock-discipline.md`)
- [ ] Coverage meets threshold: run coverage command and report the number
- [ ] Tests pass independently (no test depends on another test's state)
- [ ] Test names follow convention: `test_{what}_{condition}_{expected}` (Python) or `it("should {behavior}")` (TypeScript)
</implement_integration>

## Integration with Verify Agents

<verify_integration>
When this skill is loaded in a verify agent, add these verification checks:

### Coverage Verification

1. Run the coverage command for the relevant stack.
2. If coverage < 85% on changed files → FAIL with exact percentage and uncovered lines.
3. If critical path coverage < 95% → FAIL with specific uncovered branches.

### Mock Quality Scan

1. Read each test file in the changed files list.
2. Check for banned mock patterns from `rules/mock-discipline.md`.
3. For each mock found, verify:
   - Return value matches the actual response type (not empty `{}` or untyped)
   - At least one assertion on mock call arguments exists
   - Mock scope is at a system boundary (not mocking internal functions)
4. Report violations as FAIL with `file:line — mock-discipline: {violation}`.

### TDD Structure Check

1. For each production file changed, verify a corresponding test file exists.
2. Test file MUST contain at least one test per public function/method.
3. Test MUST include at least one error/edge case scenario.
4. Report missing tests as FAIL with `file:line — missing test coverage for {function}`.

### FAIL Criteria Summary

Any of these triggers auto-FAIL:
- Coverage < 85% on changed files
- Banned mock pattern detected
- Public function without corresponding test
- Test file with zero error/edge case tests
- Mock without call argument assertion
</verify_integration>
