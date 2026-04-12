---
name: omb-postgres
description: "PostgreSQL expertise hub — table design, indexing, extensions (pgvector, PostGIS, TimescaleDB), search, best practices, and ORM patterns. Targets PostgreSQL 17."
---

# PostgreSQL Expert Skills

Unified PostgreSQL expertise hub integrating specialized design references, performance best practices, and ORM conventions (SQLAlchemy 2.0 async).

## PostgreSQL Version

| Item | Value |
|------|-------|
| **Target version** | PostgreSQL 17 |
| **Minimum supported** | PostgreSQL 16 |
| **Version-specific features** | `NULLS NOT DISTINCT` (PG15+), incremental backup (PG17+), `uuidv7()` (PG18+, use `gen_random_uuid()` on PG17) |

When writing SQL, target PG17 syntax. Note version requirements in comments when using PG15+ or PG18+ features.

## Specialized References

Load the appropriate reference based on the task. Each is independently invocable as a skill.

### Table Design
- **[omb-postgres-tables](references/omb-postgres-tables.md)** — Data types, constraints, indexes, JSONB patterns, partitioning, and PostgreSQL best practices. **Use for any general table/schema design task.**
- **[omb-postgis-tables](references/omb-postgis-tables.md)** — PostGIS spatial table design: geometry vs geography types, SRIDs, spatial indexing, and location-based query patterns. **Use when the task involves geographic or spatial data.**

### Search
- **[omb-pgvector-search](references/omb-pgvector-search.md)** — Vector similarity search with pgvector: HNSW/IVFFlat indexes, halfvec storage, quantization, filtered search, and tuning. **Use for embeddings, RAG, or semantic search.**
- **[omb-hybrid-text-search](references/omb-hybrid-text-search.md)** — Hybrid search combining BM25 keyword search with pgvector semantic search using RRF. **Use when combining keyword and meaning-based search.**

### TimescaleDB
- **[omb-timescaledb-hypertables](references/omb-timescaledb-hypertables.md)** — Hypertable creation, compression, retention policies, continuous aggregates, and indexes. **Use when setting up TimescaleDB from scratch.**
- **[omb-hypertable-candidates](references/omb-hypertable-candidates.md)** — SQL queries to analyze existing tables and score them for hypertable conversion. **Use when evaluating which tables to migrate.**
- **[omb-hypertable-migration](references/omb-hypertable-migration.md)** — Step-by-step migration: partition column selection, in-place vs blue-green, validation. **Use when executing a migration.**

## Best Practice Rules

Performance optimization rules across 8 categories, prioritized by impact. Each rule file contains incorrect/correct SQL examples, EXPLAIN analysis, and metrics.

| Priority | Category | Impact | Prefix | Rules |
|----------|----------|--------|--------|-------|
| 1 | Query Performance | CRITICAL | `query-` | missing-indexes, partial-indexes, composite-indexes, covering-indexes, index-types |
| 2 | Connection Management | CRITICAL | `conn-` | pooling, prepared-statements, idle-timeout, limits |
| 3 | Security & RLS | CRITICAL | `security-` | rls-basics, rls-performance, privileges |
| 4 | Schema Design | HIGH | `schema-` | primary-keys, data-types, constraints, lowercase-identifiers, foreign-key-indexes, partitioning |
| 5 | Concurrency & Locking | MEDIUM-HIGH | `lock-` | short-transactions, deadlock-prevention, advisory, skip-locked |
| 6 | Data Access Patterns | MEDIUM | `data-` | batch-inserts, upsert, n-plus-one, pagination |
| 7 | Monitoring & Diagnostics | LOW-MEDIUM | `monitor-` | explain-analyze, pg-stat-statements, vacuum-analyze |
| 8 | Advanced Features | LOW | `advanced-` | full-text-search, jsonb-indexing |

Read individual rule files in `rules/` for detailed explanations:

```
rules/query-missing-indexes.md
rules/schema-primary-keys.md
rules/conn-pooling.md
rules/_sections.md          # category overview
```

## ORM & Migrations

This project uses **SQLAlchemy 2.0 async** with **Alembic**. ORM conventions are defined in `.claude/rules/db/postgres.md`:

- `AsyncSession` with `async_sessionmaker`
- `select()` API (not legacy `query()`)
- Transaction scope via `async with session.begin()`
- Naming conventions for tables (plural snake_case), columns (snake_case), indexes (`ix_<table>_<column>`), constraints (`uq_`, `ck_`, `fk_`, `pk_`)
- Migration safety: deprecate before drop, test forward AND backward, one logical change per migration
- Connection pooling: `pool_pre_ping=True`, appropriate `pool_size`/`max_overflow`

Load `.claude/rules/db/postgres.md` for the full reference when implementing ORM code.

## How to Use

1. **Table/schema design** — Load the appropriate specialized reference from the list above.
2. **Query optimization or code review** — Read the relevant best practice rule files by priority category.
3. **ORM implementation** — Follow `.claude/rules/db/postgres.md` conventions.
4. **Multi-area tasks** (e.g., "design a table with vector search") — Load multiple references as needed.

## Sources

- Table design & extensions: [pg-aiguide](https://github.com/timescale/pg-aiguide) (TigerData, Apache-2.0)
- Best practice rules: PostgreSQL community best practices (MIT)
