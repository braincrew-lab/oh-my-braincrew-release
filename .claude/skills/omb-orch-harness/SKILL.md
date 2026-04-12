---
name: omb-orch-harness
description: "Harness domain orchestration. architecture review, prompt improvement, hook audit, frontmatter validation, new feature implementation, and problem diagnosis for Claude Code harness configs."
user-invocable: true
argument-hint: "[task description or harness concern]"
---

# Harness Domain Workflow

You (main session) orchestrate by spawning sub-agents in sequence using the Agent() tool.

Sub-agents CANNOT spawn other sub-agents. Only you (the main session) can orchestrate.

## Tech Context

Claude Code harness configuration: settings.json, CLAUDE.md, .claude/rules/, .claude/skills/, .claude/agents/, .claude/hooks/, .mcp.json, permissions, memory.

Reference: `.claude/rules/harness/claude-code-harness.md` loads automatically via `paths:` rule when working in `.claude/` — this is the sole reference document.

## Intent Detection

Detect the user's intent and route to the matching workflow.

| # | Workflow | Signals | Agent Sequence |
|---|----------|---------|----------------|
| 1 | Architecture Review | "review harness", "harness audit", "check configuration", "what's configured", "harness inventory" | @harness-explorer → report |
| 2 | Improvement Suggestion | "improve harness", "optimize agents", "suggest improvements", "harness recommendations" | @harness-explorer → @harness-design → report |
| 3 | Prompt Improvement | "improve prompts", "review prompt quality", "prompt score", "prompt review" | @harness-prompt-engineer |
| 4 | Hook Audit | "hook review", "audit hooks", "check hooks", "hook configuration" | @harness-explorer (focus: hooks) → report |
| 5 | Skill Assignment Audit | "skill audit", "check skill assignments", "which agents load which skills" | @harness-explorer (focus: skills) → report |
| 6 | Frontmatter Validation | "validate frontmatter", "check agent definitions", "verify agents", "verify skills" | @harness-verify |
| 7 | New Feature | "create agent", "add skill", "new rule", "add hook", "new harness feature" | @harness-explorer → @harness-design → @core-critique → @harness-implement → @harness-verify |
| 8 | Problem Diagnosis | "harness broken", "agent not working", "skill not loading", "hook failing", "debug harness" | @harness-explorer → @harness-design → @harness-implement → @harness-verify |

## Intent Disambiguation

When the user's request matches multiple workflows:

1. **Specific signals win over general signals.** A keyword that appears in only one workflow is more specific than one that appears in multiple.
   - "hook review" → Hook Audit (specific), not Architecture Review (general "review")
   - "improve prompts" → Prompt Improvement (specific), not Improvement Suggestion (general "improve")
   - "validate agents" → Frontmatter Validation (specific), not Architecture Review
2. **When multiple workflows match with equal specificity**, select the most targeted workflow (fewer agent steps = more targeted).
3. **When ambiguity remains**, present the matching workflows to the user via AskUserQuestion and let them choose.

## Workflow Details

### Workflow 1: Architecture Review

Spawn @harness-explorer with a broad exploration request.

```
Agent(@harness-explorer):
  "Perform a full harness inventory. Catalog all settings.json scopes, CLAUDE.md files,
   agents, skills, rules, hooks, MCP configs, and memory. Report summary statistics
   and any cross-reference issues."
```

- Expect: `<omb>DONE</omb>` with full inventory report
- On `<omb>BLOCKED</omb>`: surface to user
- Present the explorer's report directly to the user

### Workflow 2: Improvement Suggestion

**Step 1:** Spawn @harness-explorer for current state analysis.
```
Agent(@harness-explorer):
  "Explore the current harness configuration. Focus on: agent coverage gaps,
   unused skills, missing hooks, inconsistent conventions, and potential optimizations."
```

**Step 2:** Spawn @harness-design with explorer findings.
```
Agent(@harness-design):
  "Based on the following harness exploration findings, design improvement suggestions.
   Focus on: convention consistency, missing configurations, optimization opportunities.
   Do NOT propose implementation — only design recommendations.
   
   Explorer findings:
   {explorer result summary}"
```

- Present design recommendations to the user for approval before any implementation

### Workflow 3: Prompt Improvement

Spawn @harness-prompt-engineer with the target file(s).

```
Agent(@harness-prompt-engineer):
  "Review and improve prompt quality in: {target files or 'all harness agent files'}.
   Run the full evaluate-diagnose-fix-reevaluate cycle per omb-prompt-review methodology."
```

- @harness-prompt-engineer handles its own internal iteration (max 3 rounds)
- Expect: `<omb>DONE</omb>` with score delta and changed files
- Present the improvement summary to the user

### Workflow 4: Hook Audit

Spawn @harness-explorer with hook-specific focus.

```
Agent(@harness-explorer):
  "Focus on hook configurations. Audit: settings.json hook entries, agent frontmatter hooks,
   hook scripts in .claude/hooks/, exit code handling, matcher syntax, and cross-references
   between settings.json hook commands and actual script files."
```

- Expect: `<omb>DONE</omb>` with hook-focused report
- Present findings directly to the user

### Workflow 5: Skill Assignment Audit

Spawn @harness-explorer with skill-specific focus.

```
Agent(@harness-explorer):
  "Focus on skill assignments. Audit: which agents preload which skills (frontmatter skills: field),
   which skills exist in .claude/skills/, any orphaned skills not referenced by any agent,
   any agent referencing a non-existent skill, and skill invocation patterns in CLAUDE.md."
```

- Expect: `<omb>DONE</omb>` with skill assignment report
- Present findings directly to the user

### Workflow 6: Frontmatter Validation

Spawn @harness-verify targeting all agent and skill files.

```
Agent(@harness-verify):
  "Validate frontmatter for all agent files in .claude/agents/ and all skill files in .claude/skills/.
   Check: valid field names, valid values, required fields present, cross-file reference consistency.
   Report BLOCKING and NON-BLOCKING issues."
```

- On `<omb>DONE</omb>` (verdict: PASS): report clean validation to user
- On `<omb>RETRY</omb>` (verdict: FAIL): present issues to user for decision on whether to fix

### Workflow 7: New Feature (full orchestration cycle)

**Step 1: Explore** — Spawn @harness-explorer to understand current conventions.
```
Agent(@harness-explorer):
  "Explore existing harness conventions relevant to creating: {new feature description}.
   Focus on: naming patterns, frontmatter conventions, directory structure, and similar
   existing configurations that the new feature should follow."
```

**Step 2: Design** — Spawn @harness-design with exploration context.
```
Agent(@harness-design):
  "Design the following harness configuration: {new feature description}.
   
   Current conventions from explorer:
   {explorer result summary}
   
   Follow existing project patterns. Produce complete specification."
```

**Step 3: Critique** (optional but recommended) — Spawn @core-critique.
```
Agent(@core-critique):
  "Review this harness configuration design for correctness, consistency, and completeness.
   
   Design:
   {design result summary}
   
   Check: valid Claude Code field names, proper scoping, cross-reference integrity,
   output contract compliance, convention consistency."
```
- On `<omb>DONE</omb>` (verdict: APPROVE): proceed to step 4
- On `<omb>RETRY</omb>` (verdict: REJECT): re-spawn @harness-design with critique feedback (max 2 retries)

**Step 4: Implement** — Spawn @harness-implement with approved design.
```
Agent(@harness-implement):
  "Implement the following approved harness configuration design:
   {design result summary}
   
   Critique notes (if any):
   {critique concerns}
   
   Implement ONLY what the design specifies — no extras."
```

**Step 5: Verify** — Spawn @harness-verify with changed files.
```
Agent(@harness-verify):
  "Verify the following harness configuration changes:
   Changed files: {implement changed_files}
   
   Check all 10 review criteria: frontmatter, hooks, permissions, cross-references,
   output contract, conventions, settings.json, MCP, CLAUDE.md, security."
```
- On `<omb>DONE</omb>` (verdict: PASS): workflow complete
- On `<omb>RETRY</omb>` (verdict: FAIL): spawn @code-debug with findings, then retry step 4 (max 3 retries)

### Workflow 8: Problem Diagnosis

**Step 1: Explore** — Spawn @harness-explorer with focused search.
```
Agent(@harness-explorer):
  "Diagnose this harness issue: {problem description}.
   Focus on: the specific configuration area mentioned, cross-references,
   hook exit codes, permission rules, and any misconfiguration indicators."
```

**Step 2: Design fix** — Spawn @harness-design with diagnosis.
```
Agent(@harness-design):
  "Based on this diagnosis, design a fix:
   Problem: {problem description}
   Findings: {explorer result summary}
   
   Propose minimal changes to resolve the issue."
```

**Step 3: Implement** — Spawn @harness-implement with fix design.
```
Agent(@harness-implement):
  "Implement this harness fix:
   {design result summary}
   
   Implement ONLY the fix — no unrelated changes."
```

**Step 4: Verify** — Spawn @harness-verify.
```
Agent(@harness-verify):
  "Verify the fix for: {problem description}
   Changed files: {implement changed_files}
   Confirm the original issue is resolved and no regressions introduced."
```
- On `<omb>DONE</omb>` (verdict: PASS): report resolution to user
- On `<omb>RETRY</omb>` (verdict: FAIL): retry step 3 (max 3 retries)

## Hard Rules

1. **Sub-agents CANNOT spawn sub-agents** — only the main session orchestrates via Agent().
2. **Scope guard** — harness agents only modify files in `.claude/`, `CLAUDE.md`, `CLAUDE.local.md`, or `.mcp.json`.
3. **Output contract** — every sub-agent must end with `<omb>DONE|RETRY|BLOCKED</omb>` + result envelope.
4. **Read-only agents stay read-only** — @harness-explorer, @harness-design, @harness-verify must have empty `changed_files`.
5. **No invented field names** — all frontmatter fields must be valid Claude Code fields per `.claude/rules/harness/claude-code-harness.md`.

## Retry Policy

- Design retries (after critique REJECT): max 2
- Implement retries (after verify FAIL): max 3, with @code-debug diagnosis between retries
- Prompt engineer retries: max 3 internal iterations (handled within @harness-prompt-engineer)
- After max retries exceeded: ask the user for guidance

## Context Passing

Pass the previous agent's result summary to the next agent. Include:
- The original task description
- Exploration findings (configuration inventory, conventions, issues)
- Design decisions and specifications
- Critique concerns (if any)
- Changed files list from implement (for verify)
