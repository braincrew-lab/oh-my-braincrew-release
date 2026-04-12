# Commit Conventions

## Format
```
type(scope): description

[optional body — explain WHY, not WHAT]

[optional footer — BREAKING CHANGE: description]
```

For detailed commit message structure with What Changed, Root Cause, Solution Approach, and Test Plan sections, see `git/commit-template.md`.

## Types
- `feat`: new feature
- `fix`: bug fix
- `refactor`: code change that neither fixes a bug nor adds a feature
- `test`: adding or updating tests
- `docs`: documentation only
- `chore`: tooling, deps, config changes
- `ci`: CI/CD pipeline changes
- `perf`: performance improvement
- `style`: formatting, whitespace (no code change)
- `build`: build system or dependency changes

## Scope
Use the domain or module name: `api`, `db`, `ui`, `electron`, `ai`, `infra`, `auth`, `ci`, `config`

## Rules
- Subject line: imperative mood, lowercase, no period, max 72 chars
- Body: wrap at 72 chars, separated from subject by blank line
- Reference issues: `Closes #123` or `Refs #456` in footer
- Breaking changes: `BREAKING CHANGE:` footer with migration path
- One logical change per commit
- Never commit secrets, .env files, or generated artifacts
- Branch name must follow the branch naming convention (see `git/branch-naming.md`)
- Run lint checks on changed files before committing (see `omb-lint-check` skill)

## Pre-Commit Security Gate

Before ANY commit, verify all of the following:
- [ ] No secrets, API keys, or tokens in the diff
- [ ] No `console.log` / `console.debug` / `print()` debug statements
- [ ] No hardcoded URLs or IP addresses (use config or env vars)
- [ ] No TODO/FIXME without a linked issue
- [ ] No commented-out code blocks
- [ ] No untyped escapes: `any` (TS) or bare `except:` (Python)
- [ ] `.env` and credential files listed in `.gitignore`
- [ ] Error messages do not leak internal paths, stack traces, or secrets

## See Also

- Branch naming convention: `git/branch-naming.md`
- Detailed commit message template: `git/commit-template.md`
- Git collaboration best practices: `git/collaboration.md`
- PR creation rules: `workflow/06-create-pr.md`
