---
name: omb-worktree
description: "Worktree lifecycle management — create, status, context, update, clean, and resume worktrees with SQLite state tracking."
user-invocable: true
argument-hint: "[create <branch> | status | context | update <branch> --status X | clean <branch> | resume <branch>]"
---

# Worktree Manager

Central management interface for git worktrees with persistent SQLite state tracking. All worktree operations go through this skill to maintain a single source of truth in `.omb/db/worktrees.db`.

## Pre-execution Context

!`CLAUDE_PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}" uv run --project "${CLAUDE_PROJECT_DIR}" oh-my-braincrew worktree-status 2>/dev/null || echo "[]"`

## When to Use

- Creating, managing, or cleaning up git worktrees
- Other skills need to determine the current worktree context
- User asks about active worktrees or wants to switch between them
- Resuming work after `/clear` or a new session

## Arguments

`$ARGUMENTS`

## Subcommand Router

Parse `$ARGUMENTS` to extract the subcommand (first word). Route to the matching section below.

| Subcommand | Aliases | Action |
|------------|---------|--------|
| `create` | `new` | Create a new worktree + DB record |
| `status` | `list`, `ls` | Show all worktree states |
| `context` | — | Determine current work context (for other skills) |
| `update` | `set` | Update DB fields for a branch |
| `clean` | `rm`, `remove` | Remove worktree + mark DONE |
| `resume` | `switch`, `cd` | Switch CWD to an existing worktree |
| (none) | — | Interactive mode |

---

## `create <branch> [description]`

<execution_order>
1. Validate branch name matches `^(feat|fix|refactor|test|docs|chore|ci|perf|style|build)/[a-z0-9]+(-[a-z0-9]+)*$`.
2. Run:
   ```bash
   echo '{}' | CLAUDE_PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}" uv run --project "${CLAUDE_PROJECT_DIR}" oh-my-braincrew WorktreeSetup $BRANCH_NAME
   ```
3. If exit 0: enter worktree and verify:
   ```bash
   cd worktrees/$BRANCH_NAME && pwd
   ```
4. Report the new worktree path and IDLE status.
</execution_order>

---

## `status`

Display all worktree records from the DB as a formatted table.

<execution_order>
1. Read the pre-execution context output (worktree-status JSON).
2. If empty array: report "No active worktrees."
3. Otherwise format as:

```
| Branch | Status | Plan | PR |
|--------|--------|------|----|
| feat/auth-flow | PROGRESS | .omb/plans/auth.md | — |
| feat/dashboard | PLAN | .omb/plans/dash.md | — |
```
</execution_order>

---

## `context`

Determine the current working context. Designed for other skills to call programmatically.

<execution_order>
1. Read the pre-execution context output (worktree-status JSON).
2. Count active worktrees (status != DONE):
   - **0**: Report "No active worktrees. Working on main."
   - **1**: Report the single active worktree. Include branch, status, plan_file, todo_file, pr_url. Suggest `cd worktrees/<branch> && pwd` if not already there.
   - **2+**: Present the list and ask the user which worktree to work in.
3. Return the chosen/single worktree context for the calling skill.
</execution_order>

---

## `update <branch> --status <STATUS> [--plan <file>] [--todo <file>] [--pr <url>]`

Update DB fields for an existing worktree.

<execution_order>
1. Parse flags from arguments.
2. Run:
   ```bash
   CLAUDE_PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}" uv run --project "${CLAUDE_PROJECT_DIR}" oh-my-braincrew worktree-update <branch> --status <STATUS> [--plan <file>] [--todo <file>] [--pr <url>]
   ```
3. Report success or failure.
</execution_order>

Valid statuses: `IDLE`, `PLAN`, `PROGRESS`, `DONE`.

---

## `clean <branch>` / `clean --all`

Remove a worktree and mark it DONE in the DB.

<execution_order>
1. If `--all`: query DB for all DONE worktrees, remove their directories only (keep DB records).
2. If specific branch:
   a. Confirm with the user before removing.
   b. Run:
      ```bash
      echo '{}' | CLAUDE_PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}" uv run --project "${CLAUDE_PROJECT_DIR}" oh-my-braincrew WorktreeTeardown <branch> --delete-branch
      ```
   c. Verify CWD is not inside the removed worktree. If it is, `cd` back to project root.
3. Report result.
</execution_order>

---

## `resume <branch>`

Switch CWD to an existing worktree.

<execution_order>
1. Verify the worktree exists in the DB and has status != DONE.
2. Run:
   ```bash
   cd worktrees/<branch> && pwd
   ```
3. Report current status and suggest next action based on DB state:
   - IDLE: "Create a plan with `omb:plan`"
   - PLAN: "Execute with `omb:run <plan_file>`"
   - PROGRESS: "Resume with `omb:run`"
</execution_order>

---

## Interactive Mode (no arguments)

When invoked without arguments, enter interactive mode.

<execution_order>
1. Read the pre-execution context (worktree-status JSON).
2. If active worktrees exist, present options:
   - Resume existing worktree (show branch, status, progress)
   - Create new worktree
   - Clean up worktrees
   - Show full status
3. If no active worktrees:
   - Create new worktree
   - Show history (all records including DONE)
4. After user selects, execute the corresponding subcommand.
</execution_order>

---

## Integration with Other Skills

Other skills call `context` to determine the active worktree before proceeding:

```
Step 0 (any skill with worktree support):
  1. Skill("omb-worktree") context
  2. Based on response:
     - Single active worktree → cd into it, proceed
     - No active worktree → work on main
     - Multiple → user chooses
```

Skills that update worktree state after their work:

| Skill | DB Update |
|-------|-----------|
| `omb:plan` | `update <branch> --status PLAN --plan <file>` |
| `omb:run` | `update <branch> --status PROGRESS --todo <file>` |
| `omb:pr` | `update <branch> --pr <url>` |
| `omb:clean` | Delegates to `omb:worktree clean` |

## Rules

- All worktree state changes MUST go through the DB (never modify state by inspecting the filesystem alone).
- DONE records are never deleted from the DB (history preservation).
- Branch names MUST follow the naming convention in `.claude/rules/git/branch-naming.md`.
- Never auto-merge worktrees. Always ask the user first.
