---
description: PR creation rules and conventions
---

# PR Creation Rules

## Branch Naming

PR source branch must follow the branch naming convention: `{type}/{short-kebab-description}`

Valid types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `ci`, `perf`, `style`, `build`

See `git/branch-naming.md` for full rules and examples.

## Conventional Commit Messages

Format: `type(scope): description`

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `ci`, `perf`, `style`, `build`

Examples:
- `feat(auth): add OAuth2 login flow`
- `fix(api): handle null response from payment provider`
- `refactor(db): migrate to SQLAlchemy 2.0 async syntax`

Breaking changes: add `BREAKING CHANGE:` in commit footer.

For detailed commit message structure, see `git/commit-template.md`.

## PR Template

```markdown
## Summary
- What changed and why (1-3 bullet points)

## Root Cause / Motivation
Why this change was needed. What problem or requirement triggered it.

## Changes
- List of specific changes

## Test Plan
- [ ] Unit tests added/updated
- [ ] Integration tests pass
- [ ] Manual testing steps
- [ ] Lint check passes (`/omb-lint-check`)

## Breaking Changes
(if applicable — describe what breaks and migration path)

## Checklist
- [ ] Branch name follows naming convention (`type/description`)
- [ ] Commit messages follow commit template
- [ ] Type check passes
- [ ] Linter passes
- [ ] No secrets committed
- [ ] Documentation updated if needed
```

## Changelog Format

```markdown
## [version] - YYYY-MM-DD
### Added
### Changed
### Fixed
### Removed
```

## PR Review Checklist

- PR title follows conventional commit format
- Branch name follows naming convention
- Description explains WHY, not just WHAT
- Single responsibility — one logical change per PR
- No unrelated changes bundled
- All CI checks pass before requesting review
- Draft PR if work is still in progress
- PR size: < 400 lines ideal, > 800 needs justification
