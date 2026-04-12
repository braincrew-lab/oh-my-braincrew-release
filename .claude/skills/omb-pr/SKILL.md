---
name: omb-pr
description: "Create GitHub PRs — validate branch, lint, commit, push, and create PR with structured template and label. Full PR workflow orchestration."
user-invocable: true
argument-hint: "[--worktree] [--base main] [--draft]"
---

## Language Setting

Documentation language (`OMB_DOCUMENTATION_LANGUAGE`): !`echo ${OMB_DOCUMENTATION_LANGUAGE:-en}`

# PR Creation Workflow

Orchestrate the full GitHub PR lifecycle: validate branch name, run lint checks, commit changes, push, and create a PR with a structured template and label. Delegates commit and PR creation to the @git-commit agent. PR body language follows the documentation language (`OMB_DOCUMENTATION_LANGUAGE`) from the Language Setting section. Technical terms, file paths, commands, and code references remain in English.

## When to Use

- After implementation is complete and you want to submit a PR
- Manually via `/omb-pr` to create a PR from the current branch
- With `--draft` to create a draft PR for work-in-progress
- With `--base {branch}` to target a branch other than `main`

## HARD RULES

- **[HARD] No Claude/Anthropic attribution in PR body or commit messages.** No `Generated with Claude Code`, `Co-Authored-By: Claude`, `noreply@anthropic.com`, etc. Case-insensitive, with or without emoji. See `rules/no-claude-attribution.md`.
- **[HARD] If attribution is detected after PR creation, remove it immediately with `gh pr edit`.**

## Architecture

```
Skill("omb-pr") orchestrates:
  Step 1: Validate branch name
  Step 2: Skill("omb-lint-check") — gate
  Step 3: Spawn @git-commit agent (mode=pr)
          → commit (if needed) → push → gh pr create --label
  Step 4: Report PR URL
```

## Execution Steps

<execution_order>
1. **Parse arguments**: Extract options from the skill argument string.
   - `--worktree` — isolate PR preparation in a worktree (set `worktree_mode = true`)
   - `--base {branch}` — target branch for the PR (default: `main`)
   - `--draft` — create a draft PR
   - If no arguments provided, use defaults.

1.5. **Worktree Setup** (conditional — only when `worktree_mode = true`):
   Follow `.claude/rules/workflow/07-worktree-protocol.md`.
   - Get current branch slug: `git rev-parse --abbrev-ref HEAD`
   - Derive worktree branch: `chore/pr-{current-branch-slug}`
   - Run: `bash .claude/hooks/omb/omb-hook.sh WorktreeSetup chore/pr-{slug}`
   - Enter: `cd worktrees/chore/pr-{slug} && pwd`
   - If setup fails or `pwd` mismatches: report BLOCKED.
   - Record `worktree_active = true`, `worktree_branch`, `worktree_path`.

2. **Validate branch name**: Run `git rev-parse --abbrev-ref HEAD` to get the current branch.
   - Check against regex: `^(feat|fix|refactor|test|docs|chore|ci|perf|style|build)/[a-z0-9]+(-[a-z0-9]+)*$`
   - If on `main` or `develop`: report BLOCKED — cannot create a PR from the target branch itself.
   - If branch name is invalid and not a special branch (`release/*`, `hotfix/*`): report BLOCKED with rename guidance:
     ```
     git branch -m {type}/{suggested-name}
     ```
   - If valid: proceed.

3. **Run lint check**: Invoke `Skill("omb-lint-check")` on all changed files (unstaged + staged).
   - If verdict is FAIL: report BLOCKED with lint errors. Do NOT proceed.
   - If verdict is PASS: write the lint marker file for the PreToolUse hook:
     ```bash
     mkdir -p "$CLAUDE_PROJECT_DIR/.omb" && date +%s > "$CLAUDE_PROJECT_DIR/.omb/.lint-passed"
     ```
   - The `omb-hook.sh PreToolUse` PreToolUse hook will verify this marker before allowing `gh pr create`.

4. **Spawn @git-commit agent**: Spawn the `git-commit` agent with `mode=pr` context.

   Pass these parameters in the agent prompt:
   - `mode: pr` — instructs the agent to execute the full PR flow (commit + push + create PR)
   - `base: {base branch}` — target branch for the PR
   - `draft: true|false` — whether to create a draft PR
   - `branch: {current branch name}` — for PR title derivation

   The agent will:
   a. Check for uncommitted changes and commit them (standard commit flow)
   b. Analyze all commits on the branch vs base for PR description
   c. Push the branch with `git push -u origin HEAD`
   d. Create the PR with `gh pr create` using the structured template
   e. Assign exactly one label from the predefined label list
   f. Return the PR URL

   If the agent returns `<omb>BLOCKED</omb>`: report BLOCKED to the user.
   If the agent returns `<omb>RETRY</omb>`: retry once with feedback.
   If the agent returns `<omb>DONE</omb>`: extract the PR URL and proceed.

4.5. **Record PR URL in worktree DB** (if a worktree is active):
   After successful PR creation, record the PR URL in the worktree DB:
   ```bash
   CLAUDE_PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}" uv run --project "${CLAUDE_PROJECT_DIR}" oh-my-braincrew worktree-update {branch} --status PROGRESS --pr {pr_url}
   ```
   This enables `omb:worktree status` to show the PR link and SessionStart recovery to include it.

4.6. **Worktree Teardown** (conditional — only when `worktree_active = true`):
   Follow `.claude/rules/workflow/07-worktree-protocol.md`.
   - Changes are already pushed to remote, so default action is **discard**.
   - Run: `cd {project-root} && bash .claude/hooks/omb/omb-hook.sh WorktreeTeardown {worktree_branch} --delete-branch`
   - Verify: `pwd` confirms CWD is back at project root.

4.7. **Attribution check** (always — safety net per `rules/no-claude-attribution.md`):
   After PR creation, verify the remote PR body does not contain Claude attribution:
   ```bash
   gh pr view {pr_url} --json body --jq '.body' > /tmp/pr-body-check.txt
   ```
   - Check (case-insensitive) for prohibited patterns:
     ```bash
     grep -qiE 'generated with claude code|claude\.com/claude-code' /tmp/pr-body-check.txt
     ```
   - If found (exit 0): strip the matching line(s) and update the PR:
     ```bash
     grep -ivE 'generated with claude code|claude\.com/claude-code' /tmp/pr-body-check.txt > /tmp/pr-body-clean.txt
     # Trim trailing blank lines
     sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' /tmp/pr-body-clean.txt > /tmp/pr-body-final.txt
     gh pr edit {pr_url} --body-file /tmp/pr-body-final.txt
     ```
   - Log: `[attribution] REMOVED — stripped N line(s)` or `[attribution] CLEAN`
   - Clean up: `rm -f /tmp/pr-body-check.txt /tmp/pr-body-clean.txt /tmp/pr-body-final.txt`

4.8. **Language verification** (always — ensures PR body matches `OMB_DOCUMENTATION_LANGUAGE`):
   Read the documentation language from the Language Setting section above.
   - `doc_language` = value from `OMB_DOCUMENTATION_LANGUAGE` (default: `en`)

   Fetch the PR body:
   ```bash
   gh pr view {pr_url} --json body --jq '.body' > /tmp/pr-lang-check.txt
   ```

   Verify language match:
   - If `doc_language = ko`: Check for Korean (Hangul) content in the PR body section headers and descriptions.
     ```bash
     grep -cP '[\uAC00-\uD7AF]' /tmp/pr-lang-check.txt
     ```
     If Hangul count is 0 or near-zero (body is English-only): the body language does NOT match. Rewrite the PR body in Korean:
     - Section headers in Korean (## 요약, ## 동기 / 배경, ## 변경 사항, ## 테스트 계획, ## 관련 이슈, ## 체크리스트)
     - Description text in Korean
     - File paths, code references, commands, agent names, technical terms stay in English
     - Write rewritten body to `/tmp/pr-lang-rewrite.txt`
     - Apply: `gh pr edit {pr_url} --body-file /tmp/pr-lang-rewrite.txt`
     - Log: `[language] REWRITTEN — en → ko`

   - If `doc_language = en`: Check that the body is primarily English.
     If body has Korean-dominant content: rewrite section headers and descriptions in English.
     - Apply: `gh pr edit {pr_url} --body-file /tmp/pr-lang-rewrite.txt`
     - Log: `[language] REWRITTEN — ko → en`

   - If language matches: Log `[language] VERIFIED — {doc_language}`

   Clean up: `rm -f /tmp/pr-lang-check.txt /tmp/pr-lang-rewrite.txt`

5. **Report result**: Output the PR URL and final status.
</execution_order>

## Retry Policy

| Step | Failure | Action | Max Retries |
|------|---------|--------|-------------|
| Step 2 | Invalid branch name | BLOCKED — user must rename | 0 |
| Step 3 | Lint FAIL | BLOCKED — user must fix code | 0 |
| Step 4 | git-commit BLOCKED | BLOCKED — surface to user | 0 |
| Step 4 | git-commit RETRY | Retry with feedback | 1 |
| Step 4.7 | Attribution detected | Auto-fix via gh pr edit | 1 |
| Step 4.8 | Language mismatch | Auto-fix via gh pr edit | 1 |

## PreToolUse Hook

The `omb-hook.sh PreToolUse` hook (configured in `settings.json`) enforces that `gh pr create` cannot run unless the lint marker `.omb/.lint-passed` exists and is fresh (< 600 seconds). This prevents bypassing the lint gate by calling `gh pr create` directly via Bash.

## Output Format

### On Success

```markdown
## PR Created

### Branch
`{branch-name}` → `{base-branch}`

### Lint Check
PASS ({N} files checked)

### Commit
`{commit-hash}` — {commit message title}

### PR
{pr_url}

### Label
`type: {label}`
```

<omb>DONE</omb>

```result
verdict: PR created
summary: "Created PR #{number} from {branch} to {base} with label type:{label}"
artifacts:
  - {pr_url}
changed_files: []
concerns: []
blockers: []
retryable: false
next_step_hint: "Review PR and request reviewers"
```

### On Failure

```markdown
## PR Creation Failed

### Step: {step number and name}
### Reason: {specific error}
### Action Required: {what the user needs to do}
```

<omb>BLOCKED</omb>

```result
verdict: {failure reason}
summary: "{what failed and why}"
artifacts: []
changed_files: []
concerns: []
blockers:
  - "{specific blocker}"
retryable: false
next_step_hint: "{what to fix}"
```
