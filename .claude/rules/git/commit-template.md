---
description: Detailed commit message template — structured markdown format for LLM-readable commits
---

# Commit Message Template

## Template

```
type(scope): short description (max 72 chars)

## What Changed
- Concrete change 1 at a higher level than raw file diffs
- Concrete change 2

## Root Cause
Why this change was needed. What problem, gap, or requirement triggered it.
For feat: what user need or business requirement.
For fix: what was broken and the underlying cause.

## Solution Approach
How the change addresses the root cause. Key design decisions made.
Trade-offs considered and why this approach was chosen over alternatives.

## Test Plan
- [ ] Specific verification step 1
- [ ] Specific verification step 2
- [ ] Commands to run: `pytest tests/test_foo.py -v`

## Breaking Changes
BREAKING CHANGE: description of what breaks and migration path

## References
Closes #123, Refs #456
```

## Section Rules

| Section | Required | When to Include | What to Write |
|---------|----------|-----------------|---------------|
| Title | Always | Every commit | `type(scope): imperative description` — max 72 chars, lowercase, no period |
| What Changed | Medium/Full | > 1 file or non-trivial change | Bullet list of concrete changes at a higher abstraction than the diff |
| Root Cause | Medium/Full | Any feat, fix, or refactor | The WHY — problem, gap, or requirement. Not the what. |
| Solution Approach | Full only | Complex changes, design decisions | HOW the change solves the root cause. Trade-offs and alternatives considered. |
| Test Plan | Medium/Full | Any code change | Specific, reproducible verification steps. Include commands to run. |
| Breaking Changes | When applicable | Any backward-incompatible change | What breaks + migration path for consumers |
| References | When applicable | Linked issues or PRs | `Closes #N` for resolved issues, `Refs #N` for related issues |

## Usage Tiers

Choose the tier based on change complexity:

### Short Form (title only or title + 1-line body)

When to use:
- `docs`, `style`, `chore` commits with < 3 files changed
- Trivial changes (typo fix, dep version bump, config tweak)

Example:
```
docs(api): fix typo in authentication endpoint description
```

### Medium Form (title + What Changed + Root Cause + Test Plan)

When to use:
- Most `feat` and `fix` commits
- Refactors that change multiple files
- Any change that a reviewer needs context for

Example:
```
fix(api): handle null response from payment provider

## What Changed
- Added null check in PaymentService.processRefund()
- Added fallback error response when provider returns null
- Added unit test for null response scenario

## Root Cause
The Stripe webhook occasionally sends a null response body during
partial outages. Our code assumed a non-null response, causing an
unhandled TypeError that returned a 500 to the client.

## Test Plan
- [ ] Run: `pytest tests/test_payment_service.py -k test_null_response`
- [ ] Verify 500 error no longer occurs with null mock response
- [ ] Check error logging captures the null response event
```

### Full Form (all sections)

When to use:
- Breaking changes
- Complex refactors touching > 10 files
- Security fixes
- Architecture-level changes
- Any change that future developers will need to understand deeply

Example:
```
refactor(auth): migrate session storage from cookies to JWT tokens

## What Changed
- Replaced express-session cookie middleware with jose JWT library
- Added JWT signing/verification utility in src/lib/jwt.ts
- Updated all 12 route handlers to use Bearer token auth
- Added token refresh endpoint at POST /api/auth/refresh
- Updated CORS config to allow Authorization header

## Root Cause
Legal compliance audit (2026-Q1) flagged cookie-based session storage
as non-compliant with updated data residency requirements. JWT tokens
stored client-side eliminate server-side session state that was tied
to a specific region.

## Solution Approach
Chose JWT over opaque tokens because: (1) no server-side session store
needed, (2) claims can carry user role for middleware auth checks,
(3) token refresh pattern handles expiry gracefully. Trade-off: tokens
are larger than session IDs, but acceptable for our payload size.

## Test Plan
- [ ] Run: `npm test -- --grep "auth"`
- [ ] Manual: login flow works with new JWT tokens
- [ ] Manual: token refresh extends session without re-login
- [ ] Manual: expired token returns 401, not 500
- [ ] Verify: old cookie-based sessions are rejected

## Breaking Changes
BREAKING CHANGE: All API endpoints now require Bearer token auth
instead of session cookies. Clients must update to use Authorization
header. See migration guide in docs/auth-migration.md.

## References
Closes #456, Refs #400
```

## Rules

- Title line follows the conventional commit format from `git/commit-conventions.md`
- Omit empty sections entirely — do not include a section header with no content
- "What Changed" should describe changes at a higher level than "modified file X" — explain the logical change
- "Root Cause" must explain WHY, never just restate the title
- "Test Plan" must contain specific, reproducible steps — not vague claims like "tested manually"
- "Solution Approach" should mention alternatives considered when the choice is non-obvious
- Wrap body text at 72 characters per line
