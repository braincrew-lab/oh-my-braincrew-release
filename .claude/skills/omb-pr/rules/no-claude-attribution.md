# No Claude Attribution in PRs and Commits

## Rule

PR bodies and commit messages created by the `git-commit` agent MUST NEVER contain any Claude or Anthropic attribution.

## Prohibited Patterns (case-insensitive)

### PR Body
- `Generated with Claude Code`
- `Generated with [Claude Code]`
- Any line containing `generated with claude code`
- Any URL linking to `claude.com/claude-code`

### Commit Message
- `Co-Authored-By:` lines referencing Claude, Anthropic, or noreply@anthropic.com
- Any trailer or footer containing `Claude` or `Anthropic` attribution

## Rationale

These attributions are auto-injected by Claude Code defaults. They add noise to PRs and git history, are not part of the structured templates, and leak tooling metadata into public-facing project history.

## Enforcement

1. **Prevention (commit)**: `git-commit` agent constraint forbids Co-Authored-By trailers referencing Claude/Anthropic
2. **Prevention (PR)**: `git-commit` agent constraint forbids watermark in PR HEREDOC body
3. **Detection (PR)**: Step 4.7 in `omb-pr` reads remote PR body after creation
4. **Remediation (PR)**: If detected, strip the line and `gh pr edit` immediately
