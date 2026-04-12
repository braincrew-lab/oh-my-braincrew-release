---
description: Branch naming convention rules — enforces {type}/{short-kebab-description} format
---

# Branch Naming Convention

## Format

```
{type}/{short-kebab-description}
```

Branch names MUST match this regex:

```
^(feat|fix|refactor|test|docs|chore|ci|perf|style|build)/[a-z0-9]+(-[a-z0-9]+)*$
```

## Valid Types

Types are identical to the commit convention types (see `git/commit-conventions.md`):

| Type | Purpose |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code restructuring (no behavior change) |
| `test` | Adding or updating tests |
| `docs` | Documentation only |
| `chore` | Tooling, deps, config changes |
| `ci` | CI/CD pipeline changes |
| `perf` | Performance improvement |
| `style` | Formatting, whitespace (no code change) |
| `build` | Build system or dependency changes |

## Special Branches (Exempt)

These branches are exempt from the type prefix rule:

- `main` — production branch
- `develop` — integration branch
- `release/*` — release preparation (e.g., `release/v1.2.0`)
- `hotfix/*` — emergency production fixes (e.g., `hotfix/critical-auth-bypass`)

## Rules

- All lowercase, no uppercase letters
- Kebab-case after the slash (words separated by hyphens)
- Max 50 characters total
- Description should be 2-5 words, concise and meaningful
- No issue numbers in branch name (use commit footer for `Refs #123`)
- No special characters except hyphens and forward slash

## Examples

| Branch Name | Valid | Reason |
|-------------|-------|--------|
| `feat/add-oauth-login` | Yes | Correct type + kebab-case description |
| `fix/null-response-handler` | Yes | Correct type + descriptive name |
| `chore/update-deps` | Yes | Correct type + concise description |
| `refactor/extract-auth-middleware` | Yes | Correct type + clear intent |
| `ci/add-lint-workflow` | Yes | Correct type + specific description |
| `feature/add-oauth` | No | `feature` is not a valid type (use `feat`) |
| `feat/Add_OAuth` | No | Uppercase and underscore not allowed |
| `feat/` | No | Missing description |
| `my-branch` | No | Missing type prefix |
| `feat/add-oauth-login-flow-for-google-and-github-sso` | No | Exceeds 50 character limit |
| `fix/123` | No | Numbers only — not descriptive |

## How to Rename a Non-Conforming Branch

If your current branch does not follow the convention, rename it:

```bash
# Rename local branch (while on that branch)
git branch -m {correct-name}

# If already pushed to remote, update remote
git push origin -u {correct-name}
git push origin --delete {old-name}
```

Example:
```bash
git branch -m feat/add-oauth-login
git push origin -u feat/add-oauth-login
```
