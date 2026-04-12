---
name: omb-codex-review
description: "Run Codex code review via CLI — analyzes local git state and reports findings."
user-invocable: true
argument-hint: "[--base <ref>] [--uncommitted] [--commit <sha>] [focus-text]"
allowed-tools: Bash, Read, Grep, Glob
---

# Codex Code Review

Run a code review using the Codex CLI. Returns findings verbatim.

## Pre-execution Check

!`which codex 2>/dev/null || echo "NOT_FOUND"`

If `codex` is not found, stop and tell the user:
```
Codex CLI is not installed. Run: npm install -g @openai/codex
```

## Arguments

$ARGUMENTS

## Execution

1. Determine the review scope from arguments:
   - `--base <ref>` — review changes against a base branch
   - `--uncommitted` — review staged, unstaged, and untracked changes
   - `--commit <sha>` — review a specific commit
   - Free-form text (no flags) — treated as custom review instructions with `--uncommitted`
   - No arguments at all — defaults to `--uncommitted`

2. Build and run the review command. **Important:** `--uncommitted` and `[PROMPT]` are mutually exclusive in the codex CLI.
   - If `$ARGUMENTS` contains `--base`, `--uncommitted`, or `--commit`: run `codex review $ARGUMENTS`
   - If `$ARGUMENTS` is free-form text (no flags): run `codex review "$ARGUMENTS"` (the prompt implicitly reviews uncommitted changes)
   - If `$ARGUMENTS` is empty: run `codex review --uncommitted`

```bash
# Example: no args — review all uncommitted changes
codex review --uncommitted

# Example: with base branch
codex review --base main

# Example: with focus text (PROMPT reviews uncommitted changes implicitly)
codex review "check the auth flow for race conditions"
```

3. Return the Codex output **verbatim**. Do not paraphrase, summarize, or add commentary.

4. After presenting findings, **STOP**. Do not auto-apply fixes unless the user explicitly asks.

## Rules

- This command is review-only. Do not fix issues or suggest that you are about to make changes.
- Preserve all file paths, line numbers, and verdicts exactly as reported by Codex.
- If Codex reports no issues, say so and stop.
- If the review fails (non-zero exit), report the error and stop.
