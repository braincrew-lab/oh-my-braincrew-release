# TDD for Python / Database (PostgreSQL + SQLAlchemy)

## Test File Structure

```
tests/
├── conftest.py              # Database engine, session fixture, rollback strategy
├── db/
│   ├── conftest.py          # DB-specific fixtures: factories, seed data
│   ├── test_models.py       # ORM model constraint tests
│   ├── test_repositories.py # Repository CRUD tests
│   └── test_migrations.py   # Alembic migration up/down tests
└── factories/
    └── db_factories.py      # factory_boy or manual factory functions
```

## Database Fixture Strategy

### Transaction Rollback per Test

Every test runs inside a transaction that rolls back after the test. No data leaks between tests.

```python
import pytest
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker

@pytest.fixture(scope="session")
async def engine():
    engine = create_async_engine(TEST_DATABASE_URL, echo=False)
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield engine
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)
    await engine.dispose()

@pytest.fixture
async def db_session(engine):
    async with engine.connect() as conn:
        transaction = await conn.begin()
        session = AsyncSession(bind=conn, expire_on_commit=False)
        yield session
        await session.close()
        await transaction.rollback()
```

### Factory Functions (NOT MagicMock)

```python
# tests/factories/db_factories.py
from src.models import User, Project

async def create_test_user(session: AsyncSession, **overrides) -> User:
    defaults = {
        "name": "Test User",
        "email": f"user-{uuid4().hex[:8]}@test.com",
        "hashed_password": "hashed_test_password",
        "is_active": True,
    }
    defaults.update(overrides)
    user = User(**defaults)
    session.add(user)
    await session.flush()
    return user

async def create_test_project(session: AsyncSession, owner: User, **overrides) -> Project:
    defaults = {
        "name": "Test Project",
        "owner_id": owner.id,
        "status": "active",
    }
    defaults.update(overrides)
    project = Project(**defaults)
    session.add(project)
    await session.flush()
    return project
```

## RED-GREEN-IMPROVE Example

### RED — Test repository method before it exists

```python
@pytest.mark.asyncio
async def test_user_repo_get_by_email_returns_user(db_session: AsyncSession):
    user = await create_test_user(db_session, email="alice@test.com")
    repo = UserRepository(db_session)

    result = await repo.get_by_email("alice@test.com")

    assert result is not None
    assert result.id == user.id
    assert result.email == "alice@test.com"

@pytest.mark.asyncio
async def test_user_repo_get_by_email_returns_none_for_missing(db_session: AsyncSession):
    repo = UserRepository(db_session)
    result = await repo.get_by_email("nonexistent@test.com")
    assert result is None
```

### GREEN — Implement the repository method

```python
class UserRepository:
    def __init__(self, session: AsyncSession):
        self._session = session

    async def get_by_email(self, email: str) -> User | None:
        stmt = select(User).where(User.email == email)
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()
```

## Model Constraint Testing

Test database constraints directly — do not rely on application-level validation alone.

```python
@pytest.mark.asyncio
async def test_user_email_unique_constraint(db_session: AsyncSession):
    await create_test_user(db_session, email="duplicate@test.com")
    with pytest.raises(IntegrityError):
        await create_test_user(db_session, email="duplicate@test.com")
        await db_session.flush()

@pytest.mark.asyncio
async def test_user_name_not_nullable(db_session: AsyncSession):
    with pytest.raises(IntegrityError):
        user = User(name=None, email="test@test.com", hashed_password="hash")
        db_session.add(user)
        await db_session.flush()

@pytest.mark.asyncio
async def test_project_cascade_delete_removes_tasks(db_session: AsyncSession):
    user = await create_test_user(db_session)
    project = await create_test_project(db_session, owner=user)
    task = Task(title="Do thing", project_id=project.id)
    db_session.add(task)
    await db_session.flush()

    await db_session.delete(project)
    await db_session.flush()

    result = await db_session.execute(select(Task).where(Task.project_id == project.id))
    assert result.scalars().all() == []
```

## Migration Testing

```python
from alembic import command
from alembic.config import Config

def test_migration_upgrade_downgrade():
    """Verify migrations can run forward and backward without errors."""
    alembic_cfg = Config("alembic.ini")
    alembic_cfg.set_main_option("sqlalchemy.url", TEST_DATABASE_URL_SYNC)

    # Forward
    command.upgrade(alembic_cfg, "head")

    # Backward
    command.downgrade(alembic_cfg, "base")

    # Forward again (idempotent)
    command.upgrade(alembic_cfg, "head")
```

## Query Performance Testing

```python
@pytest.mark.asyncio
async def test_list_users_uses_single_query(db_session: AsyncSession):
    """Verify no N+1 query pattern when listing users with projects."""
    for i in range(10):
        user = await create_test_user(db_session, email=f"user{i}@test.com")
        await create_test_project(db_session, owner=user)

    repo = UserRepository(db_session)

    # Count queries executed
    query_count = 0
    original_execute = db_session.execute
    async def counting_execute(*args, **kwargs):
        nonlocal query_count
        query_count += 1
        return await original_execute(*args, **kwargs)
    db_session.execute = counting_execute

    await repo.list_with_projects()
    assert query_count == 1, f"Expected 1 query, got {query_count} (N+1 detected)"
```

## Rules

1. ALWAYS use a real test database — never mock SQLAlchemy sessions or models.
2. Use transaction rollback fixtures — every test gets a clean slate.
3. Use factory functions with unique values (UUID in email) — tests must not depend on execution order.
4. Test constraints at the DB level — unique, not null, foreign key, check constraints.
5. Test cascade behavior — delete parent, verify children are handled correctly.
6. Test migrations forward AND backward — every migration must have a working downgrade.
7. Test query patterns — verify joinedload/selectinload prevents N+1.
