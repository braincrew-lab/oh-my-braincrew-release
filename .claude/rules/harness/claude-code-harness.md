---
description: Claude Code harness configuration reference — settings.json, CLAUDE.md, hooks, skills, agents, rules, permissions, MCP, and memory
paths:
  - ".claude/**/*"
  - "CLAUDE.md"
  - "CLAUDE.local.md"
  - ".mcp.json"
---

# Claude Code Harness Configuration Reference

Comprehensive reference for Claude Code harness configuration surfaces. All harness agents (harness-explorer, harness-design, harness-implement, harness-verify) should consult this reference for correctness.

Source: https://code.claude.com/docs/llms.txt

## 1. settings.json

### Scopes (Precedence: Managed > Local > Project > User)

| Scope | Path | Use Case |
|-------|------|----------|
| Managed | OS-specific paths or `managed-settings.json` | Enterprise/admin policies, overrides all |
| Local | `.claude/settings.local.json` | Developer-specific, gitignored |
| Project | `.claude/settings.json` | Shared team config, committed |
| User | `~/.claude/settings.json` | Personal defaults across all projects |

Array settings (e.g., `permissions.allow`) merge across scopes. Scalar settings use most specific value.

### Core Fields

```json
{
  "permissions": {
    "allow": ["Tool(specifier)", "..."],
    "deny": ["Tool(specifier)", "..."],
    "ask": ["Tool(specifier)", "..."]
  },
  "hooks": {
    "EventName": [{
      "matcher": "exact|pipe|regex",
      "hooks": [{ "type": "command", "command": "...", "timeout": 5 }]
    }]
  },
  "env": { "KEY": "value" },
  "model": "sonnet",
  "defaultMode": "default",
  "sandbox": { "enabled": true },
  "attribution": { "commit": "Co-Authored-By: ..." },
  "enabledPlugins": { "plugin-name": true }
}
```

### Environment Variables

| Variable | Description |
|----------|-------------|
| `CLAUDE_PROJECT_DIR` | Absolute path to the project root |
| `CLAUDE_ENV_FILE` | Path for persisting env vars (SessionStart hooks) |
| `CLAUDE_SESSION_ID` | Current session identifier |

## 2. CLAUDE.md

### Placement Scopes

| Scope | Path | Loaded When |
|-------|------|-------------|
| Managed | OS admin-controlled | Always (highest priority) |
| Project | `./CLAUDE.md` or `./.claude/CLAUDE.md` | In project directory |
| User | `~/.claude/CLAUDE.md` | Always (lowest priority) |
| Local | `./CLAUDE.local.md` | In project directory (gitignored) |
| Directory | `subdir/CLAUDE.md` | When working in that subdirectory |

### Loading Behavior

- All scopes are **concatenated** (not overridden)
- Directory walk: loads CLAUDE.md from each parent up to project root
- Subdirectory CLAUDE.md files load **on demand** when Claude reads files there
- After compaction: project-root CLAUDE.md re-injected; nested ones reload on file access
- `@import` syntax: `@path/to/file.md` — max 5 hops, no cycles
- HTML comments (`<!-- -->`) stripped before injection

### Best Practices

- Keep under 200 lines per file
- Split to `.claude/rules/` when growing beyond 200 lines
- Use markdown headers and bullets for structure
- Run `/init` to auto-generate a starting CLAUDE.md

## 3. Hooks

### Events

| Event | Fires When | Can Block? |
|-------|------------|-----------|
| `PreToolUse` | Before any tool call | Yes (exit 2) |
| `PostToolUse` | After tool call completes | No |
| `SessionStart` | Session begins | No |
| `SessionEnd` | Session ends | No |
| `Stop` | Agent finishes response | Yes (exit 2) |
| `UserPromptSubmit` | User sends prompt | Yes (exit 2) |
| `SubagentStart` | Subagent spawned | No |
| `SubagentStop` | Subagent finishes | Yes (exit 2) |
| `TaskCreated` | Background task created | Yes (exit 2) |
| `TaskCompleted` | Background task finishes | Yes (exit 2) |
| `ConfigChange` | Configuration modified | Yes (exit 2) |
| `FileChanged` | File modified externally | No |
| `InstructionsLoaded` | CLAUDE.md/rules loaded | No |

### Handler Types

| Type | Description | Example |
|------|-------------|---------|
| `command` | Shell command | `{ "type": "command", "command": "./check.sh", "timeout": 5 }` |
| `http` | HTTP request | `{ "type": "http", "url": "http://localhost:8080/hook" }` |
| `prompt` | Inject prompt | `{ "type": "prompt", "prompt": "Check safety: $ARGUMENTS" }` |
| `agent` | Spawn subagent | `{ "type": "agent", "prompt": "Verify: $ARGUMENTS" }` |

### Matcher Syntax

| Pattern | Evaluated As |
|---------|-------------|
| `"*"`, `""`, or omitted | Match all |
| Only letters, digits, `_`, `\|` | Exact string or pipe-separated list (e.g., `Edit\|Write`) |
| Contains other chars | JavaScript regex |

Per-event targets: PreToolUse/PostToolUse match tool names, SessionStart matches start source, SubagentStart/Stop matches agent type.

### Exit Codes

| Code | Meaning | Effect |
|------|---------|--------|
| `0` | Success | Parse stdout for JSON output |
| `2` | Block | Prevent the tool call / deny permission |
| Other | Non-blocking error | Log warning, continue |

### JSON Output

```json
{
  "decision": "allow",
  "reason": "explanation",
  "hookSpecificOutput": {
    "permissionDecision": "allow|deny|ask|defer",
    "updatedInput": { "field": "modified value" },
    "additionalContext": "injected context"
  }
}
```

PreToolUse `permissionDecision` precedence: deny > defer > ask > allow.

### Hook Configuration in settings.json

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "./scripts/validate.sh",
        "timeout": 600
      }]
    }]
  }
}
```

### Hook Configuration in Agent/Skill Frontmatter

```yaml
hooks:
  PreToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: "./scripts/check.sh"
          timeout: 5
```

## 4. Skills (SKILL.md)

### Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Recommended | Skill identifier (lowercase, hyphens, max 64 chars) |
| `description` | Recommended | What skill does — triggers matching (truncated at 250 chars) |
| `argument-hint` | No | Placeholder for $ARGUMENTS (e.g., `[branch-name]`) |
| `disable-model-invocation` | No | `true` = only user can invoke |
| `user-invocable` | No | `false` = hidden from `/` menu |
| `allowed-tools` | No | Tool allowlist while skill is active |
| `model` | No | Override model for skill execution |
| `effort` | No | `low`, `medium`, `high`, `max` |
| `context` | No | `fork` = run in forked subagent context |
| `agent` | No | Subagent type for `context: fork` |
| `hooks` | No | Skill-specific hooks |
| `paths` | No | Glob patterns for conditional activation |
| `shell` | No | `bash` (default) or `powershell` |

### String Substitutions

| Token | Expands To |
|-------|------------|
| `$ARGUMENTS` | Full argument string from invocation |
| `$1`, `$2`, ... `$N` | Positional arguments |
| `${CLAUDE_SESSION_ID}` | Current session ID |
| `${CLAUDE_SKILL_DIR}` | Directory containing this SKILL.md |

### Shell Injection

- `` !`command` `` — runs command, output replaces placeholder before Claude sees it
- Multi-line: wrap in `` ```! `` fenced code block

### Compaction Budget

- 5,000 tokens per skill during context compaction
- 25,000 tokens combined for all active skills

### Invocation Control

| Frontmatter | User invokes | Claude invokes |
|-------------|-------------|---------------|
| (default) | Yes | Yes |
| `disable-model-invocation: true` | Yes | No |
| `user-invocable: false` | No | Yes |

## 5. Agents (.md)

### Frontmatter Fields

| Field | Required | Default | Description |
|-------|----------|---------|-------------|
| `name` | Yes | — | Agent identifier (lowercase + hyphens) |
| `description` | Yes | — | When Claude should delegate to this agent |
| `model` | No | inherit | `haiku`, `sonnet`, `opus`, full ID, or `inherit` |
| `permissionMode` | No | `default` | See Permission Modes below |
| `tools` | No | all | Comma-separated tool allowlist |
| `disallowedTools` | No | none | Comma-separated tool denylist |
| `maxTurns` | No | 50 | Maximum conversation turns |
| `color` | No | — | `red`, `blue`, `green`, `yellow`, `purple`, `orange`, `pink`, `cyan` |
| `effort` | No | medium | `low`, `medium`, `high`, `max` |
| `memory` | No | — | `user`, `project`, `local` |
| `skills` | No | [] | Skills to preload |
| `hooks` | No | {} | Agent-scoped hook definitions |
| `mcpServers` | No | {} | Inline MCP server definitions |
| `isolation` | No | — | `worktree` = temporary git worktree |
| `background` | No | false | Run as background task |
| `initialPrompt` | No | — | Auto-sent first turn |

### Permission Modes

| Mode | Behavior |
|------|----------|
| `default` | Ask for each tool use |
| `acceptEdits` | Auto-accept file edits, ask for others |
| `auto` | Auto-accept all tool uses |
| `dontAsk` | Skip tools that would require asking |
| `bypassPermissions` | No permission checks (dangerous) |
| `plan` | Read-only planning mode |

### Tool Restrictions

- `tools: Read, Grep, Glob` — only these tools available
- `disallowedTools: Edit, Write` — these tools blocked
- `Agent(worker, researcher)` — restrict which subagents can be spawned

### Memory Scopes

| Scope | Storage Path |
|-------|-------------|
| `user` | `~/.claude/agent-memory/<name>/MEMORY.md` |
| `project` | `.claude/agent-memory/<name>/MEMORY.md` |
| `local` | `.claude/agent-memory-local/<name>/MEMORY.md` |

First 200 lines / 25KB of MEMORY.md loaded at subagent startup.

## 6. Rules (.claude/rules/)

### Structure

- Directory: `.claude/rules/`
- File format: Markdown with optional YAML frontmatter
- Rules without `paths:` load at session start (global)
- Rules with `paths:` load only when working with matching files

### Path-Scoped Rules Example

```yaml
---
paths:
  - "src/api/**/*.ts"
---

# API Development Rules
- All endpoints must validate input
```

Glob patterns: `**/*.ts` (recursive), `*.md` (root only), `src/**/*` (all under src/). Supports brace expansion: `"src/**/*.{ts,tsx}"`.

## 7. Permissions

### Rule Syntax

Format: `Tool(specifier)` with wildcards.

| Rule | Matches |
|------|---------|
| `Bash(npm*)` | Any bash command starting with `npm` |
| `Edit(src/**)` | Edit any file under `src/` |
| `Read(//etc/*)` | Read files under `/etc/` (absolute) |
| `Read(~/.ssh/*)` | Read files under home `.ssh/` |
| `Write(/config/*)` | Write files under project `config/` |

### Path Specifiers

| Prefix | Meaning |
|--------|---------|
| `//` | Absolute filesystem path |
| `~/` | User home directory |
| `/` | Project root (relative) |
| (none) | Glob pattern |

### Evaluation Order

1. **deny** — if matched, DENY (no override)
2. **ask** — if matched, prompt user
3. **allow** — if matched, ALLOW silently
4. No match — default behavior (depends on permissionMode)

## 8. MCP (Model Context Protocol)

### Transports

| Transport | Use Case | Recommended |
|-----------|----------|-------------|
| `http` | Remote services | Yes |
| `sse` | Server-sent events | No (deprecated) |
| `stdio` | Local processes | Yes (local tools) |

### Configuration Scopes

| Scope | Path | Committed |
|-------|------|-----------|
| Project | `.mcp.json` | Yes |
| User | `~/.claude.json` | No |
| Subagent | Agent frontmatter `mcpServers:` | Yes |

### .mcp.json Format

```json
{
  "mcpServers": {
    "server-name": {
      "type": "http",
      "url": "${API_BASE_URL}/mcp",
      "headers": {
        "Authorization": "Bearer ${API_KEY}"
      }
    },
    "local-tool": {
      "command": "npx",
      "args": ["-y", "@tool/server"],
      "env": {
        "KEY": "${ENV_VAR:-default_value}"
      }
    }
  }
}
```

Environment variable expansion: `${VAR}` and `${VAR:-default}`. Never hardcode secrets — always use `${VAR}` syntax.

### Subagent-Scoped MCP

```yaml
mcpServers:
  local-tool:
    type: stdio
    command: npx
    args: ["-y", "@tool/server"]
```

### Tool Naming

MCP tools follow: `mcp__<server>__<tool>` (e.g., `mcp__memory__create_entities`).

## 9. Memory

### Types

| Type | Written By | Storage |
|------|-----------|---------|
| CLAUDE.md | Developer | Project root, .claude/, subdirectories |
| Auto memory | Claude | `~/.claude/projects/<project>/memory/` |
| Agent memory | Claude | `.claude/agent-memory/<name>/MEMORY.md` |
| Rules | Developer | `.claude/rules/**/*.md` |

### Auto Memory

- Claude writes observations to MEMORY.md files
- Separate from CLAUDE.md (developer-written instructions)
- Agent-scoped: each agent with `memory: project` gets its own memory
- First 200 lines / 25KB of MEMORY.md loaded at startup
- Do not manually edit MEMORY.md files — they are Claude-managed
