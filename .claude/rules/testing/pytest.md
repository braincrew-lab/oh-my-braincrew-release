---
paths: ["tests/**/*.py", "test_*.py", "*_test.py"]
---

# Pytest Conventions

## Structure
- Tests mirror source: `src/api/routes.py` → `tests/api/test_routes.py`
- Shared fixtures in `conftest.py` at each test directory level
- Name tests: `test_{what}_{condition}_{expected}` (e.g., `test_login_invalid_password_returns_401`)

## Fixtures
- Use `@pytest.fixture` for setup/teardown, not setUp/tearDown
- Scope fixtures appropriately: `function` (default), `module`, `session`
- Use `autouse=True` sparingly — only for truly universal setup
- Database fixtures: create and rollback per test (transaction isolation)

## Async Tests
- Use `pytest-asyncio` with `@pytest.mark.asyncio`
- Async fixtures: `@pytest_asyncio.fixture`
- Use `AsyncClient` (httpx) for FastAPI endpoint tests

## Patterns
- `parametrize` for testing multiple inputs: `@pytest.mark.parametrize("input,expected", [...])`
- `pytest.raises(ExceptionType)` for expected errors
- `monkeypatch` over `unittest.mock` for patching
- `tmp_path` fixture for temporary file operations

## Coverage
- Target: 80%+ for critical paths (auth, payments, data mutations)
- Run: `pytest --cov=src --cov-report=term-missing`
- Exclude: migrations, config files, type stubs
