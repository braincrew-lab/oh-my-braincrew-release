---
paths: ["src/api/**/*.py", "api/**/*.py", "app/api/**/*.py"]
---

# FastAPI Conventions

## Endpoint Design
- Use `async def` for all endpoints
- Define `response_model` on every route for serialization safety
- Use appropriate HTTP status codes: 201 for creation, 204 for deletion, 422 for validation
- Group routes with `APIRouter` and meaningful prefixes/tags

## Pydantic v2 Models
- Use `model_validator` instead of `validator` (v1 deprecated)
- Use `ConfigDict` instead of inner `class Config`
- Define separate schemas: `Create`, `Update`, `Response` per resource
- Use `Field(...)` for required fields with descriptions

## Dependency Injection
- Use `Depends()` for shared logic (auth, db sessions, pagination)
- Keep dependencies composable and testable
- Never use global mutable state — inject via dependencies

## Error Handling
- Raise `HTTPException` with meaningful `detail` messages
- Use custom exception handlers for domain errors
- Never expose internal stack traces to clients
- Return consistent error response shape: `{"detail": "...", "code": "..."}`

## Background Work
- Use `BackgroundTasks` for non-blocking operations (emails, logging)
- For long-running jobs, use a task queue (Celery, ARQ) instead

## Security
- Validate path/query params with Pydantic types, not manual parsing
- Rate limit sensitive endpoints
- Use `Security()` with OAuth2 scopes for protected routes
