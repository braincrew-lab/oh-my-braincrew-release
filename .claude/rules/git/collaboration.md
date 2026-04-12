---
description: Git collaboration best practices — branching, merging, PRs, releases, and conflict resolution
---

# Git Collaboration Best Practices

## Protected Branches

| Branch | Protection | Push Policy |
|--------|-----------|-------------|
| `main` | Protected | No direct pushes. All changes via PR. |
| `release/*` | Protected | No direct pushes. Cherry-pick or merge from main. |
| `develop` (if used) | Semi-protected | Prefer PR, direct push allowed for urgent fixes. |

- Enable branch protection rules in GitHub/GitLab settings
- Require status checks to pass before merge
- Require at least 1 approving review

## Merge Strategy

| Scenario | Strategy | Why |
|----------|----------|-----|
| Feature branch → main | Squash merge | Clean history, one commit per feature |
| Release branch → main | Merge commit | Preserve release history and cherry-picks |
| Main → feature branch (sync) | Rebase | Linear history, no unnecessary merge commits |
| Hotfix → main | Squash merge | Single atomic fix in history |

Rules:
- Never force-push to `main` or `release/*`
- Resolve merge conflicts locally before pushing — avoid resolving via GitHub UI for complex conflicts
- Test after conflict resolution before pushing

## PR Review Requirements

- Minimum 1 approval before merge (2 for security-sensitive changes)
- All CI checks must pass (lint, type check, tests, build)
- No self-merge on team projects (solo projects exempt)
- Use Draft PR for work-in-progress — convert to Ready when CI passes
- PR title follows conventional commit format: `type(scope): description`
- PR description explains WHY, not just WHAT (see `git/commit-template.md`)
- Single responsibility: one logical change per PR. Do not bundle unrelated changes.
- Keep PRs small when possible: < 400 lines changed is ideal, > 800 needs justification

## Release Tagging

Format: **Semantic Versioning** `vMAJOR.MINOR.PATCH`

| Version Part | When to Bump | Example |
|-------------|-------------|---------|
| MAJOR | Breaking API changes | v1.0.0 → v2.0.0 |
| MINOR | New features, backward-compatible | v1.0.0 → v1.1.0 |
| PATCH | Bug fixes, backward-compatible | v1.0.0 → v1.0.1 |

Rules:
- Tag from `main` only (after PR merge)
- Use annotated tags: `git tag -a v1.2.0 -m "Release v1.2.0: description"`
- Update changelog BEFORE tagging (see `workflow/06-create-pr.md` for format)
- Pre-release versions: `v1.2.0-rc.1`, `v1.2.0-beta.1`

## Branch Lifecycle

| Stage | Action |
|-------|--------|
| Creation | Create from `main` (or `develop` if used). Name follows `git/branch-naming.md`. |
| Active | Push regularly. Rebase onto main at least every 2 days to avoid drift. |
| Ready | Open PR, request review, ensure CI passes. |
| Merged | Delete branch immediately after merge (auto-delete recommended). |
| Stale | Branches > 2 weeks without activity: rebase and continue, or close. |

Guidelines:
- Feature branches should live max 5 business days
- If a feature takes longer, break it into smaller incremental PRs
- Never leave merged branches around — delete them

## Conflict Resolution

1. **Rebase onto target branch** before opening or updating a PR:
   ```bash
   git fetch origin
   git rebase origin/main
   ```
2. **Resolve conflicts locally** in your editor — avoid the GitHub merge editor for anything non-trivial
3. **Test after resolution** — run lint, type check, and tests before pushing:
   ```bash
   # Python
   ruff check . && pytest
   # TypeScript
   npx tsc --noEmit && npx eslint . && npx vitest run
   ```
4. **If rebase gets messy**, abort and try a clean approach:
   ```bash
   git rebase --abort
   git merge origin/main  # fallback to merge commit
   ```

## Commit Hygiene

- One logical change per commit (see `git/commit-conventions.md`)
- Use the appropriate commit message template tier (see `git/commit-template.md`)
- Squash WIP commits before PR review: `git rebase -i origin/main`
- Never commit generated files, build artifacts, or secrets
- Keep `.gitignore` up to date for the project tech stack
