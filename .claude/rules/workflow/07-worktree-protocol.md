# Worktree Protocol (DB-Based)

All worktree lifecycle management goes through the SQLite DB at `.omb/db/worktrees.db`. The `omb:worktree` skill is the single management interface.

## Architecture

```
omb:worktree (master skill)
  |
oh-my-braincrew CLI (WorktreeSetup / WorktreeTeardown / worktree-status / worktree-update)
  |
WorktreeDB (src/hook/db.py) — SQLite + git worktree operations
  |
.omb/db/worktrees.db (single source of truth)
```

## State Machine

```
IDLE --> PLAN --> PROGRESS --> DONE
 |                     |
 +-- (omb:clean) ------+--> DONE
```

| Status | Meaning | Transition Trigger |
|--------|---------|-------------------|
| `IDLE` | Worktree created, no plan yet | `omb:worktree create` |
| `PLAN` | Plan file exists | `omb:plan` completion |
| `PROGRESS` | Execution in progress | `omb:run` start |
| `DONE` | Completed or cleaned up | `omb:clean` or PR merge |

## HARD Rules

1. **[HARD] All state changes go through WorktreeDB** — never modify worktree state by filesystem inspection alone.
2. **[HARD] `omb:worktree` is the single management interface** — other skills call `omb:worktree context` to determine the active worktree, not their own parsing logic.
3. **[HARD] DONE records are never deleted** — preserved for history tracking.
4. **[HARD] Never auto-merge** — always ask the user before merging worktree changes.
5. **[HARD] Branch names must match convention** — `^(feat|fix|refactor|test|docs|chore|ci|perf|style|build)/[a-z0-9]+(-[a-z0-9]+)*$`.

## Skill Integration

Every skill that supports worktree context MUST start with:

```
Step 0: Worktree Context
  1. Invoke Skill("omb-worktree") with argument "context"
  2. Based on response:
     - Single active worktree -> cd into it, proceed
     - No active worktree -> work on main
     - Multiple -> user chooses
```

Skills update DB state after their work:

| Skill | Update Command |
|-------|---------------|
| `omb:plan` | `omb:worktree update <branch> --status PLAN --plan <file>` |
| `omb:run` | `omb:worktree update <branch> --status PROGRESS --todo <file>` |
| `omb:pr` | `omb:worktree update <branch> --pr <url>` |

## SessionStart Recovery

`WorktreeRecoveryHandler` reads the DB on SessionStart and outputs recovery guidance:
- Lists all active worktrees (status != DONE)
- Suggests next action based on current status
- Includes PR URL if one was recorded

## CLI Commands

| Command | Purpose |
|---------|---------|
| `oh-my-braincrew WorktreeSetup <branch>` | Create worktree + DB record (IDLE) |
| `oh-my-braincrew WorktreeTeardown <branch> [--delete-branch]` | Remove worktree + mark DONE |
| `oh-my-braincrew worktree-status` | JSON dump of active worktrees |
| `oh-my-braincrew worktree-update <branch> --status X [--plan Y] [--todo Z] [--pr URL]` | Update DB fields |

## DB Schema

File: `.omb/db/worktrees.db`

```sql
CREATE TABLE worktrees (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    branch TEXT UNIQUE NOT NULL,
    worktree_path TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'IDLE',
    plan_file TEXT,
    todo_file TEXT,
    pr_url TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    description TEXT
);
```

WAL mode enabled for concurrent access safety.
