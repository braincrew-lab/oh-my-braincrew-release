---
paths: ["tests/integration/**", "tests/e2e/**"]
---

# Integration Test Conventions

## Database Tests
- Use a real test database, not mocks, for integration tests
- Transaction isolation: wrap each test in a transaction, rollback after
- Seed data via fixtures, not manual INSERT in each test
- Clean state: tests must not depend on execution order

## API Tests
- Test full request → response cycle through the actual app
- Use test client (httpx AsyncClient for FastAPI, supertest for Express)
- Validate response status, headers, and body structure
- Test auth flows end-to-end (login → token → protected endpoint)

## Test Database Setup
- Separate database instance or schema for tests
- Apply migrations before test suite runs
- Use factory functions for test data creation (not raw SQL)

## Parallel Safety
- Tests must not share mutable state
- Use unique identifiers per test (UUIDs, prefixed names)
- Avoid global fixtures that accumulate data across tests

## External Services
- Mock external APIs at the HTTP boundary (not at the client level)
- Use `responses` (Python) or `msw` (TypeScript) for HTTP mocking
- Test timeout and error scenarios, not just happy paths

## CI Integration
- Integration tests run in CI with a real database service
- Use Docker Compose or GitHub Actions service containers
- Set reasonable timeouts (60s per test, 10min total)
