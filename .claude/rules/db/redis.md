---
paths: ["src/cache/**", "src/redis/**", "src/**/redis*"]
---

# Redis Conventions

## Key Naming
- Format: `service:entity:id` (e.g. `auth:session:abc123`)
- Use colons as separators — they enable Redis namespace browsing
- Prefix all keys with the service name to avoid collisions
- Keep keys short but descriptive — avoid long serialized values in keys

## TTL Strategy
- ALWAYS set a TTL — never store keys indefinitely without justification
- Session tokens: 24h
- Cache entries: 5m to 1h depending on staleness tolerance
- Rate limit counters: match the rate limit window
- Use `EXPIREAT` for time-of-day expiration, `EXPIRE` for duration

## Data Patterns
- Cache-aside: check cache, miss -> fetch from DB, set cache
- Write-through: update DB and cache atomically
- Use `SETNX` or `SET ... NX` for distributed locks
- Use sorted sets for leaderboards, rate limiting windows

## Pub/Sub
- Channel naming: `service:event` (e.g. `orders:created`)
- Keep message payloads small — publish IDs, not full objects
- Consumers must handle missed messages (pub/sub has no persistence)
- Use Redis Streams for durable message processing

## Connection Management
- Use connection pooling (`redis.asyncio.ConnectionPool`)
- Set `decode_responses=True` for string-based workloads
- Handle `ConnectionError` and `TimeoutError` with retries
- Close connections on application shutdown
