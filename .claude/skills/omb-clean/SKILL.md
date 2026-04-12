---
name: omb-clean
description: "Worktree cleanup — remove worktrees, mark DONE in DB, optionally delete branches. Delegates to omb:worktree clean."
user-invocable: true
argument-hint: "[<branch> | --all]"
---

# Worktree Cleanup

Remove completed or abandoned worktrees and update the DB. This skill delegates to `omb:worktree clean` for the actual operation.

## Pre-execution Context

!`CLAUDE_PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}" uv run --project "${CLAUDE_PROJECT_DIR}" oh-my-braincrew worktree-status 2>/dev/null || echo "[]"`

## When to Use

- After a PR has been merged and the worktree is no longer needed
- To clean up abandoned worktrees
- To free disk space from stale worktrees
- User says "clean up", "remove worktree", or "I'm done with this branch"

## Arguments

`$ARGUMENTS`

## Execution

<execution_order>
1. **Parse arguments**:
   - `<branch>`: clean a specific worktree
   - `--all`: clean all worktrees with DONE status
   - (none): show active worktrees and ask which to clean

2. **If specific branch**:
   a. Look up the branch in the pre-execution context.
   b. Warn if status is PROGRESS (work may be in flight).
   c. Confirm with the user: "Remove worktree `<branch>` and delete the branch? [yes/no]"
   d. On confirmation, run:
      ```bash
      echo '{}' | CLAUDE_PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}" uv run --project "${CLAUDE_PROJECT_DIR}" oh-my-braincrew WorktreeTeardown <branch> --delete-branch
      ```
   e. Verify CWD is not inside the removed worktree. If so, `cd` back to project root.

3. **If `--all`**:
   a. List all DONE worktrees from the DB.
   b. For each, attempt `git worktree remove` (directory cleanup only, DB records preserved).
   c. Report what was cleaned.

4. **If no arguments**:
   a. Show the pre-execution context as a table.
   b. Ask the user which worktree to clean.
   c. Proceed as in step 2.

5. **Report result**: Show updated worktree status.
</execution_order>

## Rules

- Always confirm before removing a worktree (never auto-clean without user approval).
- DONE records are preserved in the DB for history.
- If the current CWD is inside the worktree being removed, switch to project root first.
- Warn before cleaning PROGRESS worktrees (they may have uncommitted work).
