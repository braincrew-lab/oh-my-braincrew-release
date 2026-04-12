---
paths: ["src/**"]
---

# Security Checklist (OWASP Top 10)

## SQL Injection
- NEVER concatenate user input into SQL queries
- Use parameterized queries or ORM query builders exclusively
- Validate and sanitize all input before database operations

## Cross-Site Scripting (XSS)
- Escape all user-generated content before rendering in HTML
- Use framework auto-escaping (React JSX, Jinja2 autoescape)
- Set `Content-Security-Policy` headers to restrict script sources
- Sanitize HTML input with allowlist-based sanitizers

## Cross-Site Request Forgery (CSRF)
- Use CSRF tokens for all state-changing operations
- Validate `Origin` and `Referer` headers
- Use `SameSite=Strict` or `Lax` for session cookies

## Authentication and Authorization
- Hash passwords with bcrypt/argon2 — never store plaintext
- Implement rate limiting on login endpoints
- Use short-lived JWTs with refresh token rotation
- Check authorization on every request, not just at the route level

## Secret Exposure
- NEVER commit secrets, API keys, or credentials to source control
- Use environment variables or secret managers (Vault, AWS SSM)
- Add `.env`, `*.pem`, `*.key` to `.gitignore`
- Rotate exposed secrets immediately

## Dependency Vulnerabilities
- Run `npm audit` / `pip audit` / `safety check` in CI
- Pin dependency versions in lockfiles
- Update dependencies regularly — automate with Dependabot/Renovate

## Input Validation
- Validate type, length, format, and range of all inputs
- Reject unexpected fields (use strict schema validation)
- Validate file uploads: type, size, content (not just extension)
- Never trust client-side validation alone
