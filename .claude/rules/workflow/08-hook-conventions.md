# Hook Conventions

## Naming Convention

All hook dispatching uses a single unified script in `.claude/hooks/omb/`:

```
omb-hook.sh <EventType>
```

Where `<EventType>` maps to a Claude Code lifecycle event in PascalCase:

| Command | Lifecycle Event | Matcher |
|---------|----------------|---------|
| `omb-hook.sh SessionStart` | SessionStart | — |
| `omb-hook.sh PreToolUse` | PreToolUse | Bash, Write\|Edit |
| `omb-hook.sh PostToolUse` | PostToolUse | Write\|Edit |
| `omb-hook.sh Stop` | Stop | Agent |
| `omb-hook.sh WorktreeSetup` | WorktreeSetup | manual invocation |
| `omb-hook.sh WorktreeTeardown` | WorktreeTeardown | manual invocation |

## Architecture

```
Claude Code lifecycle event
  ↓
settings.json hook entry (type: command)
  ↓
.claude/hooks/omb/omb-hook.sh (unified dispatcher)
  ↓
uv run oh-my-braincrew <EventType> [args...]
  ↓
src/hook/cli.py → Registry → Handler(s)
```

### Shell Wrapper

The single `omb-hook.sh` file is a **thin dispatcher only** — all logic lives in `src/hook/`. The shell wrapper follows this exact template:

```bash
#!/usr/bin/env bash
# omb-hook.sh — Unified thin wrapper for oh-my-braincrew Python CLI
# Usage: omb-hook.sh <EventType> [args...]
set -euo pipefail
exec uv run --project "${CLAUDE_PROJECT_DIR}" oh-my-braincrew "$1" "${@:2}"
```

Rules:
- No `jq`, `grep`, or other logic in the shell wrapper
- `exec` replaces the shell process to preserve stdin piping and exit codes
- `$1` is the EventType, `${@:2}` passes through remaining CLI args

### Python Package

Source: `src/hook/`

| Sub-package / Module | Purpose |
|---------------------|---------|
| `cli.py` | Entry point: parse event type, read stdin, dispatch, exit |
| `protocol.py` | JSON stdin/stdout I/O |
| `registry.py` | Handler registration and sequential dispatch with timeout |
| `types.py` | EventType enum, ExitCode enum, HookInput/HookOutput |
| `contract.py` | Environment validation |
| `core/` | Core handlers (session start, stop) |
| `lifecycle/` | Lifecycle handlers (pre-tool-use, post-tool-use) |
| `quality/` | Quality gate handlers (lint checks, PR gates) |
| `security/` | Security handlers (secret scanning, scope guards) |
| `worktree/` | Worktree handlers (setup, teardown) |

## Protocol

- **stdin**: JSON payload from Claude Code (event-specific fields)
- **stdout**: Text injected into Claude's context (SessionStart, UserPromptSubmit)
- **stderr**: Diagnostic messages shown in user terminal (verbose mode)
- **Exit codes**: `0` = allow, `2` = block, other = non-blocking error (fail-open)

## Adding a New Handler

No new shell scripts are needed. To add a new handler:

1. Create a handler `.py` file in the appropriate sub-package under `src/hook/` (e.g., `src/hook/quality/<name>.py`) implementing the `Handler` ABC
2. Register in `src/hook/cli.py:build_registry()`
3. Create `tests/hooks/test_<name>.py`
4. If a new lifecycle event: add a new entry in `settings.json` pointing to `omb-hook.sh` with the new EventType

## HARD Rules

1. **[HARD] All hook dispatching MUST use the single `omb-hook.sh` dispatcher** — no other shell scripts for hooks.
2. **[HARD] Shell wrapper contains NO logic** — only the `exec uv run` template.
3. **[HARD] Python handles all JSON** — no `jq` in shell scripts.
4. **[HARD] Every handler has tests** — `tests/hooks/test_<name>.py` required.
5. **[HARD] Zero runtime dependencies** — `src/hook/` uses stdlib only.
