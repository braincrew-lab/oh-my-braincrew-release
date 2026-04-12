# TDD for Python / FastAPI

## Test File Structure

```
tests/
├── conftest.py          # Shared fixtures: app, client, db_session
├── api/
│   ├── conftest.py      # API-specific fixtures
│   ├── test_users.py    # Tests for /api/users endpoints
│   └── test_auth.py     # Tests for /api/auth endpoints
├── services/
│   └── test_user_service.py
└── factories/
    └── user_factory.py  # Factory functions for test data
```

## Fixture Patterns

### App and Client Fixtures

```python
import pytest
from httpx import ASGITransport, AsyncClient
from src.main import app

@pytest.fixture
async def client():
    async with AsyncClient(
        transport=ASGITransport(app=app),
        base_url="http://test",
    ) as ac:
        yield ac
```

### Authenticated Client

```python
@pytest.fixture
async def auth_client(client: AsyncClient, test_user: User):
    token = create_access_token(data={"sub": str(test_user.id)})
    client.headers["Authorization"] = f"Bearer {token}"
    yield client
```

### Test Data Factories

```python
# tests/factories/user_factory.py
from src.models.user import User

def make_user(**overrides) -> User:
    defaults = {
        "name": "Test User",
        "email": "test@example.com",
        "hashed_password": "hashed_value",
        "is_active": True,
    }
    defaults.update(overrides)
    return User(**defaults)
```

## RED-GREEN-IMPROVE Example

### RED — Failing test for a new endpoint

```python
@pytest.mark.asyncio
async def test_create_user_returns_201_with_valid_data(client: AsyncClient):
    response = await client.post("/api/users", json={
        "name": "Alice",
        "email": "alice@example.com",
        "password": "SecurePass123!",
    })
    assert response.status_code == 201
    data = response.json()
    assert data["name"] == "Alice"
    assert data["email"] == "alice@example.com"
    assert "password" not in data  # Never expose password in response
    assert "id" in data
```

Run: `pytest tests/api/test_users.py::test_create_user_returns_201_with_valid_data` — MUST fail (endpoint does not exist yet).

### GREEN — Minimal implementation

```python
@router.post("/users", status_code=201, response_model=UserResponse)
async def create_user(data: CreateUserRequest, db: AsyncSession = Depends(get_db)):
    user = User(name=data.name, email=data.email, hashed_password=hash_password(data.password))
    db.add(user)
    await db.commit()
    await db.refresh(user)
    return user
```

Run: `pytest tests/api/test_users.py` — MUST pass.

### Error Path Tests (additional RED cycles)

```python
@pytest.mark.asyncio
async def test_create_user_returns_422_with_invalid_email(client: AsyncClient):
    response = await client.post("/api/users", json={
        "name": "Alice",
        "email": "not-an-email",
        "password": "SecurePass123!",
    })
    assert response.status_code == 422

@pytest.mark.asyncio
async def test_create_user_returns_409_with_duplicate_email(client: AsyncClient, test_user: User):
    response = await client.post("/api/users", json={
        "name": "Another Alice",
        "email": test_user.email,  # Already exists
        "password": "SecurePass123!",
    })
    assert response.status_code == 409
```

## Async Testing Rules

1. All FastAPI tests MUST use `@pytest.mark.asyncio` and `async def`.
2. Use `httpx.AsyncClient` with `ASGITransport` — not `TestClient` (which is sync).
3. Database fixtures MUST use async sessions with transaction rollback.
4. Never use `asyncio.run()` inside tests — let pytest-asyncio manage the event loop.

## Pydantic Model Testing

Test Pydantic request/response models directly — do not rely solely on endpoint tests.

```python
def test_create_user_request_rejects_weak_password():
    with pytest.raises(ValidationError) as exc_info:
        CreateUserRequest(name="Alice", email="alice@test.com", password="123")
    assert "password" in str(exc_info.value)

def test_user_response_excludes_password():
    user = User(id=1, name="Alice", email="alice@test.com", hashed_password="secret")
    response = UserResponse.model_validate(user)
    assert not hasattr(response, "hashed_password")
```

## Parametrized Tests for Validation

```python
@pytest.mark.parametrize("field,value,expected_status", [
    ("name", "", 422),
    ("name", "a" * 256, 422),
    ("email", "", 422),
    ("email", "invalid", 422),
    ("password", "", 422),
    ("password", "short", 422),
])
async def test_create_user_validation(client, field, value, expected_status):
    payload = {"name": "Valid", "email": "valid@test.com", "password": "ValidPass123!"}
    payload[field] = value
    response = await client.post("/api/users", json=payload)
    assert response.status_code == expected_status
```

## Middleware and Dependency Testing

```python
@pytest.mark.asyncio
async def test_rate_limit_returns_429_after_threshold(client: AsyncClient):
    for _ in range(100):
        await client.get("/api/health")
    response = await client.get("/api/health")
    assert response.status_code == 429

@pytest.mark.asyncio
async def test_auth_dependency_returns_401_without_token(client: AsyncClient):
    response = await client.get("/api/users/me")
    assert response.status_code == 401
```
