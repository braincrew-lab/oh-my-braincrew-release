---
name: omb-harness
description: >
  Harness configuration management — create, update, and verify .claude/ harness components
  (agents, skills, hooks, rules, settings.json, CLAUDE.md, MCP configs).
  Routes to harness-explorer for discovery, harness-design for planning,
  harness-implement for creation, and harness-verify for validation.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, Agent, AskUserQuestion
argument-hint: "[--verify | --prompt | --fix | --plan] [target or task description]"
---

# Harness Configuration Management

Manages `.claude/` harness components (agents, skills, hooks, rules, settings.json, CLAUDE.md, MCP configs) through specialized sub-agents. Mode flags let users target a specific workflow phase instead of running the full cycle.

Current harness structure:
!`ls .claude/agents/omb/ .claude/skills/ .claude/rules/ .claude/hooks/omb/ 2>/dev/null | head -20`

## Architecture

```
omb:harness [flag] [target]
  ↓
Argument Parsing (detect mode flag)
  ↓
Mode Router
  ├── --verify  → @harness-verify (validation only)
  ├── --prompt  → @harness-prompt-engineer (prompt quality)
  ├── --fix     → explorer → design → implement → verify (diagnosis-first)
  ├── --plan    → explorer → design (stop before implementation)
  └── (default) → explorer → design → implement → verify (full cycle)
```

## Arguments

```
omb:harness [--verify | --prompt | --fix | --plan] [target or task description]
```

### Argument Parsing

1. Check if `$ARGUMENTS` contains one of the mode flags: `--verify`, `--prompt`, `--fix`, `--plan`
2. If a flag is found: set `mode` to the flag value, strip the flag from the argument string
3. If multiple flags are found: use `AskUserQuestion` to ask the user which single mode they want — do not guess
4. If no flag is found: set `mode = "default"` (full 4-step workflow)
5. Pass the remaining string as the task description (`target`)

### Mode Flags (mutually exclusive)

| Flag | Mode | Use Case | Agent Sequence |
|------|------|----------|----------------|
| (none) | `default` | Create or update a harness component end-to-end | explorer → design → implement → verify |
| `--verify` | `verify` | Check existing configs for errors without changing anything | @harness-verify |
| `--prompt` | `prompt` | Improve prompt quality in agent/skill `.md` files | @harness-prompt-engineer |
| `--fix` | `fix` | Diagnose and repair a broken harness component | explorer → design → implement → verify |
| `--plan` | `plan` | Design a change and review before committing to implementation | explorer → design |

### No-Target Defaults

When no task description is provided after the flag:

| Flag | Behavior |
|------|----------|
| `--verify` | Verify ALL harness files (agents, skills, hooks, rules, settings.json, MCP) |
| `--prompt` | Review ALL harness agent and skill `.md` files |
| `--fix` | Use `AskUserQuestion`: "What harness problem are you experiencing?" |
| `--plan` | Use `AskUserQuestion`: "What harness configuration do you want designed?" |

---

## Mode Routing

Based on the parsed `mode`, execute the corresponding workflow. Skip to the matching section below.

### Mode: `verify`

Run verification only. Skip Steps 1-3 of the default workflow.

Spawn `@harness-verify` against the specified target or all harness files.

```
Agent(@harness-verify):
  "Verify harness configuration: {target, or 'all harness files' if none specified}.
   Check all review criteria: frontmatter validity, output contract compliance,
   cross-reference integrity, hook exit codes, permission syntax, settings.json
   structure, MCP config format, convention consistency, and security."
```

- On `<omb>DONE</omb>` (verdict: PASS): report clean validation to user
- On `<omb>RETRY</omb>` (verdict: FAIL): present issues to user and suggest re-running with `--fix` to auto-repair
- On `<omb>BLOCKED</omb>`: surface to user and stop

### Mode: `prompt`

Run prompt quality improvement. Skip the default workflow entirely.

Spawn `@harness-prompt-engineer` for the evaluate-diagnose-fix cycle.

```
Agent(@harness-prompt-engineer):
  "Review and improve prompt quality in: {target, or 'all harness agent and skill .md files'}.
   Run the full evaluate-diagnose-fix-reevaluate cycle per omb-prompt-review methodology.
   Scope: .claude/agents/**/*.md and .claude/skills/**/SKILL.md only."
```

- @harness-prompt-engineer handles its own internal iteration (max 3 rounds)
- Expect: `<omb>DONE</omb>` with score delta and changed files
- Present the improvement summary to the user

### Mode: `fix`

Run problem diagnosis and fix workflow. Same agent sequence as default mode, but the explorer focuses on diagnosing the specific problem rather than general discovery.

If no target is provided, use `AskUserQuestion`: "What harness problem are you experiencing?"

**Step 1: Diagnose** — Spawn @harness-explorer.
```
Agent(@harness-explorer):
  "Diagnose this harness issue: {target}.
   Focus on: the specific configuration area mentioned, cross-references,
   hook exit codes, permission rules, and any misconfiguration indicators."
```
- Expect: `<omb>DONE</omb>` with diagnosis findings
- On `<omb>BLOCKED</omb>`: surface to user and stop

**Step 2: Design fix** — Spawn @harness-design with diagnosis.
```
Agent(@harness-design):
  "Based on this diagnosis, design a fix:
   Problem: {target}
   Findings: {explorer result summary}
   Propose minimal changes to resolve the issue."
```
- Expect: `<omb>DONE</omb>` with fix specification
- On `<omb>RETRY</omb>`: re-spawn with feedback (max 2 retries)

**Step 3: Implement fix** — Spawn @harness-implement.
```
Agent(@harness-implement):
  "Implement this harness fix:
   {design result summary}
   Implement ONLY the fix — no unrelated changes."
```
- Expect: `<omb>DONE</omb>` with `changed_files`

**Step 4: Verify fix** — Spawn @harness-verify.
```
Agent(@harness-verify):
  "Verify the fix for: {target}
   Changed files: {implement changed_files}
   Confirm the original issue is resolved and no regressions introduced."
```
- On `<omb>DONE</omb>` (verdict: PASS): report resolution to user
- On `<omb>RETRY</omb>` (verdict: FAIL): spawn `@code-debug` with findings, then retry Step 3 (max 3 retries)

### Mode: `plan`

Run discovery and design only. Stop before implementation to let the user review.

If no target is provided, use `AskUserQuestion`: "What harness configuration do you want designed?"

**Step 1: Discovery** — Spawn @harness-explorer.
```
Agent(@harness-explorer):
  "Explore existing harness conventions relevant to: {target}.
   Focus on: naming patterns, frontmatter conventions, directory structure,
   and similar existing configurations that the new component should follow."
```
- Expect: `<omb>DONE</omb>` with convention summary
- On `<omb>BLOCKED</omb>`: surface to user and stop

**Step 2: Design** — Spawn @harness-design.
```
Agent(@harness-design):
  "Design the following harness configuration: {target}.

   Current conventions from explorer:
   {explorer result summary}

   Follow existing project patterns. Produce complete specification including:
   frontmatter fields, prompt body structure, file paths, and cross-references."
```
- Expect: `<omb>DONE</omb>` with complete design specification

**After design completes:** Present the design specification to the user. Do NOT proceed to implementation. The user can then:
- Run `omb:harness` without a flag to execute the full cycle
- Run `omb:harness --fix` if adjustments are needed
- Modify the design manually

### Mode: `default` (no flag)

Execute the full 4-step sequential workflow defined below in "Agent Delegation Flow".

---

## Agent Delegation Flow (default mode)

This skill orchestrates four specialized agents in sequence. Only the main session spawns agents via `Agent()` — sub-agents cannot spawn other sub-agents.

### Step 1: Discovery (read-only)

Spawn `@harness-explorer` to catalog the existing harness configuration relevant to the task.

```
Agent(@harness-explorer):
  "Explore existing harness conventions relevant to: {task description}.
   Focus on: naming patterns, frontmatter conventions, directory structure,
   and similar existing configurations that the new component should follow."
```

- Expect: `<omb>DONE</omb>` with inventory and convention summary
- On `<omb>BLOCKED</omb>`: surface to user and stop
- **Skip when**: creating a brand-new component type with no existing state to reference (e.g., first agent in a new namespace). Proceed directly to Design.
- Pass the explorer's convention summary to the Design step.

### Step 2: Design (read-only)

Spawn `@harness-design` to plan the configuration changes.

```
Agent(@harness-design):
  "Design the following harness configuration: {task description}.

   Current conventions from explorer:
   {explorer result summary}

   Follow existing project patterns. Produce complete specification including:
   frontmatter fields, prompt body structure, file paths, and cross-references."
```

- Expect: `<omb>DONE</omb>` with complete design specification
- On `<omb>RETRY</omb>`: re-spawn `@harness-design` with feedback (max 2 retries)
- On `<omb>BLOCKED</omb>`: surface to user and stop
- Pass the full design specification to the Implementation step.

### Step 3: Implementation (write)

Spawn `@harness-implement` to create or modify harness files.

```
Agent(@harness-implement):
  "Implement the following approved harness configuration design:
   {design result summary}

   Implement ONLY what the design specifies — no unsolicited additions."
```

- Expect: `<omb>DONE</omb>` with `changed_files` list
- On `<omb>BLOCKED</omb>`: surface to user and stop
- Pass the `changed_files` list to the Verification step.

### Step 4: Verification (read-only)

Spawn `@harness-verify` to validate the changes.

```
Agent(@harness-verify):
  "Verify the following harness configuration changes:
   Changed files: {implement changed_files}

   Check all review criteria: frontmatter validity, output contract compliance,
   cross-reference integrity, hook exit codes, permission syntax, settings.json
   structure, MCP config format, convention consistency, and security."
```

- On `<omb>DONE</omb>` (verdict: PASS): workflow complete — report success to user
- On `<omb>RETRY</omb>` (verdict: FAIL): spawn `@code-debug` with findings, then retry Step 3 (max 3 retries)
- On `<omb>BLOCKED</omb>`: surface to user and stop

## Scope

This skill manages these harness components:

| Component | Paths |
|-----------|-------|
| Agents | `.claude/agents/omb/*.md` |
| Skills | `.claude/skills/omb-*/SKILL.md` |
| Hooks | `.claude/hooks/omb/` |
| Rules | `.claude/rules/**/*.md` |
| Settings | `.claude/settings.json`, `.claude/settings.local.json` |
| MCP | `.mcp.json` |
| Reference | `.claude/rules/harness/claude-code-harness.md` |

All write operations MUST target `.claude/`, `CLAUDE.md`, `CLAUDE.local.md`, or `.mcp.json`. No application code is modified by this workflow.

## Key References

**Agents** (in `.claude/agents/omb/`):
- `harness-explorer` — read-only discovery and cataloging of harness configuration
- `harness-design` — harness configuration design (agents, skills, hooks, rules)
- `harness-implement` — harness configuration implementation (creates/modifies files)
- `harness-verify` — harness configuration verification and quality gate

**Rules**:
- `.claude/rules/harness/claude-code-harness.md` — authoritative Claude Code field reference (valid frontmatter fields, hook syntax, permission rules, MCP format)

**Orchestration**:
- `Skill("omb-orch-harness")` — full harness domain orchestration with intent detection and retry policy

## Hard Rules

1. **Sub-agents MUST NOT spawn sub-agents** — only the main session orchestrates via `Agent()`.
2. **Scope guard** — all write operations target `.claude/`, `CLAUDE.md`, `CLAUDE.local.md`, or `.mcp.json` only. No application code.
3. **Output contract** — every sub-agent ends with `<omb>DONE|RETRY|BLOCKED</omb>` + result envelope.
4. **Mode flags are mutually exclusive** — if multiple flags are detected, ask the user to choose one.
5. **`--fix` and `--plan` require a target** — if none provided, ask via `AskUserQuestion` before proceeding.

## Output Contract

When the harness configuration task completes:

<omb>DONE</omb>

```result
summary: "<one-line summary of what was created or modified>"
artifacts:
  - "<created/modified file paths>"
changed_files:
  - "<all files created or modified>"
concerns:
  - "<concerns if any, empty list if none>"
blockers: []
retryable: false
next_step_hint: "invoke omb-orch-harness for broader harness management workflows"
```

When blocked by missing context or unresolvable dependency:

<omb>BLOCKED</omb>

```result
summary: "<description of what is blocking>"
artifacts: []
changed_files: []
concerns: []
blockers:
  - "<blocking issue description>"
retryable: true
next_step_hint: "resolve the blocking issue and re-invoke omb-harness"
```
