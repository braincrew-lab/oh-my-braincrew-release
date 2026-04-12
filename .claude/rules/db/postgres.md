---
paths: ["src/db/**", "alembic/**", "migrations/**", "models/**"]
---

# PostgreSQL Conventions

## SQLAlchemy 2.0 Async
- Use `AsyncSession` with `async_sessionmaker`
- Use `select()` statements, not legacy `query()` API
- Always use `async with session.begin():` for transaction scope
- Yield sessions from dependency injection, never create globally

## Naming Conventions
- Tables: plural snake_case (`user_accounts`, `order_items`)
- Columns: snake_case (`created_at`, `is_active`)
- Foreign keys: `<table_singular>_id` (e.g. `user_id`)
- Indexes: `ix_<table>_<column>` (e.g. `ix_users_email`)
- Constraints: `uq_<table>_<column>`, `ck_<table>_<condition>`

## Index Strategy
- Primary key index is automatic — do not duplicate
- Add indexes for columns used in WHERE, JOIN, ORDER BY
- Use partial indexes for filtered queries (e.g. `WHERE is_active = true`)
- Composite indexes: put high-cardinality columns first

## Migration Safety
- Never drop columns directly — deprecate first, remove in a later release
- Use `op.execute()` for data migrations, not ORM models
- Always test migrations forward AND backward (downgrade)
- One logical change per migration file

## Connection Pooling
- Use `pool_size` and `max_overflow` appropriate to deployment
- Set `pool_pre_ping=True` to detect stale connections
- Set `pool_recycle` to avoid connection timeout from the server side

## PostgreSQL Types
- **JSONB**: use for semi-structured data (preferences, metadata). Always create GIN index for containment queries (`@>`, `?`, `?|`). Import from `sqlalchemy.dialects.postgresql`.
- **ARRAY**: use for small bounded collections (tags, roles). Create GIN index for `@>` queries. Use join tables for large/unbounded collections.
- **ENUM**: use for fixed-set columns (status, category). Create via `CREATE TYPE` in migration. Add new values with `ALTER TYPE ... ADD VALUE` (non-reversible — plan accordingly).
- **Generated columns**: use `GENERATED ALWAYS AS ... STORED` for derived values. Cannot reference other tables.

## Alembic Naming Convention
Configure in `env.py` to auto-generate consistent constraint names:
```python
convention = {
    "ix": "ix_%(table_name)s_%(column_0_N_name)s",
    "uq": "uq_%(table_name)s_%(column_0_N_name)s",
    "ck": "ck_%(table_name)s_%(constraint_name)s",
    "fk": "fk_%(table_name)s_%(column_0_N_name)s_%(referred_table_name)s",
    "pk": "pk_%(table_name)s",
}
metadata = MetaData(naming_convention=convention)
```
