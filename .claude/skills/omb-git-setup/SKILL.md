---
name: omb-git-setup
user-invocable: true
description: >
  (omb) Set up git workflow: pre-commit hooks (ruff, eslint), .gitignore review, GitHub Actions CI/secret scan.
  Triggers on: git setup, git hooks, pre-commit, gitignore review, ci setup, github actions.
argument-hint: "[--hooks-only | --gitignore-only | --actions-only]"
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, AskUserQuestion, Agent
---

# Git Workflow Setup

Set up git workflow tooling for a project: pre-commit hooks, .gitignore review, and GitHub Actions suggestions.

## HARD RULES

- [HARD] All output in English
- [HARD] Ask ONE question at a time via AskUserQuestion (never batch multiple questions)
- [HARD] Never overwrite existing files without asking the user first
- [HARD] Detect tech stack BEFORE asking user questions (Phase 1 must complete before Phase 2)
- [HARD] Never store secrets in generated files — use environment variables or GitHub Secrets

## Pre-execution Context

!`ls .pre-commit-config.yaml .gitignore .github/workflows/ .git/hooks/pre-commit .git/hooks/commit-msg 2>/dev/null || echo "none found"`
!`git rev-parse --is-inside-work-tree 2>/dev/null || echo "not a git repo"`

Parse pre-execution output to set flags:
- `is_git_repo`: true if "true" was returned from `git rev-parse`
- `has_pre_commit_config`: true if `.pre-commit-config.yaml` was listed
- `has_gitignore`: true if `.gitignore` was listed
- `has_workflows_dir`: true if `.github/workflows/` was listed
- `has_hook_pre_commit`: true if `.git/hooks/pre-commit` was listed
- `has_hook_commit_msg`: true if `.git/hooks/commit-msg` was listed

If `is_git_repo` is false: report "NEEDS_CONTEXT — not inside a git repository. Run `git init` first." and stop.

## Arguments

Parse `$ARGUMENTS` for phase-skipping flags:

| Flag | Phases to Run |
|------|--------------|
| `--hooks-only` | Phase 1 (detect), Phase 2 (confirm), Phase 3 (hooks) only |
| `--gitignore-only` | Phase 1 (detect), Phase 2 (confirm), Phase 4 (.gitignore) only |
| `--actions-only` | Phase 1 (detect), Phase 2 (confirm), Phase 5 (GitHub Actions) only |
| `--labels-only` | Phase 6 (GitHub Labels) only — no stack detection needed |
| (none) | All phases |

---

## Phase 1: Tech Stack Detection (Silent)

No user interaction. Launch an Explore agent to scan the project.

Invoke the `Agent` tool with `subagent_type: "Explore"` and `model: "haiku"`:

```
Scan the project and report the tech stack:
- Programming languages detected (from file extensions, pyproject.toml, package.json, go.mod, Cargo.toml)
- Frameworks and libraries (FastAPI, React, Express, Django, Next.js, etc.)
- Linter and formatter configs (ruff, eslint, prettier, golangci-lint, etc.)
- Test frameworks detected
- Existing CI files under .github/workflows/
- Infrastructure files (*.tf, Dockerfile, docker-compose*)

Output as a structured summary. Do NOT modify any files.
```

Parse the agent result into a `stack` object with fields:
- `languages`: list (e.g., `["python", "typescript"]`)
- `frameworks`: list (e.g., `["fastapi", "react"]`)
- `linters`: list (e.g., `["ruff", "eslint"]`)
- `has_terraform`: boolean
- `has_docker`: boolean
- `existing_workflows`: list of filenames under `.github/workflows/`

---

## Phase 2: User Confirmation

Show the detected stack and ask for confirmation before proceeding.

```
AskUserQuestion:
  question: "Detected tech stack:\n\n{{stack_summary}}\n\nIs this correct? Anything to add or correct?"
  header: "Tech Stack"
  options:
    - label: "Looks correct — proceed"
      description: "Use detected stack for all phases"
    - label: "Add/correct items"
      description: "Specify corrections (use 'Other' to type)"
```

Update `stack` with any user corrections before continuing.

---

## Phase 3: Git Hooks Setup

Skip this phase if `--gitignore-only` or `--actions-only` flag was provided.

### Step 3.1: Hook Approach

```
AskUserQuestion:
  question: "How would you like to configure git hooks?"
  header: "Git Hooks"
  options:
    - label: "Shell hooks (.git/hooks/pre-commit)"
      description: "Native git hooks — no extra tool needed. Teammates must run install-hooks.sh."
    - label: "pre-commit framework (.pre-commit-config.yaml)"
      description: "Requires `pip install pre-commit`. Hooks run in isolated environments."
    - label: "Skip"
      description: "Do not configure hooks right now"
```

If "Skip": proceed to Phase 4.

### Step 3.2a: Shell Hooks

If `has_hook_pre_commit` is true: ask before overwriting.

```
AskUserQuestion:
  question: ".git/hooks/pre-commit already exists. Overwrite it?"
  header: "Overwrite Hook"
  options:
    - label: "Yes — overwrite"
      description: "Replace the existing pre-commit hook"
    - label: "No — skip hook creation"
      description: "Keep the existing hook as-is"
```

If overwrite confirmed (or no existing hook): generate `.git/hooks/pre-commit` with blocks for each detected linter:

```bash
#!/usr/bin/env bash
set -euo pipefail

# oh-my-braincrew pre-commit hook
# Generated by omb-git-setup

STAGED=$(git diff --cached --name-only --diff-filter=ACMR)

if [ -z "$STAGED" ]; then
  exit 0
fi
```

Python block (include if `python` in `stack.languages`):
```bash
PY_FILES=$(echo "$STAGED" | grep '\.py$' || true)
if [ -n "$PY_FILES" ]; then
  echo "Running ruff..."
  echo "$PY_FILES" | xargs ruff check || exit 1
fi
```

TypeScript/JavaScript block (include if `typescript` or `javascript` in `stack.languages`):
```bash
TS_FILES=$(echo "$STAGED" | grep -E '\.(ts|tsx|js|jsx)$' || true)
if [ -n "$TS_FILES" ]; then
  echo "Running eslint..."
  echo "$TS_FILES" | xargs npx eslint --no-error-on-unmatched-pattern || exit 1
fi
```

After writing `.git/hooks/pre-commit`, run:
```bash
chmod +x .git/hooks/pre-commit
```

Also store a copy of the hook source at `scripts/pre-commit` (committed to the repo) and create `scripts/install-hooks.sh` so teammates can install:

```bash
#!/usr/bin/env bash
set -euo pipefail
# Install git hooks for this project
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SCRIPT_DIR/pre-commit" .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
echo "Git hooks installed."
```

After writing, run:
```bash
chmod +x scripts/install-hooks.sh
```

### Step 3.2b: pre-commit Framework

If `has_pre_commit_config` is true:

```
AskUserQuestion:
  question: ".pre-commit-config.yaml already exists. Overwrite it?"
  header: "Overwrite Config"
  options:
    - label: "Yes — overwrite"
      description: "Replace the existing pre-commit configuration"
    - label: "No — skip"
      description: "Keep the existing configuration as-is"
```

If user chose "No — skip": proceed to Step 3.3.

Generate `.pre-commit-config.yaml` with repos matching detected stack:

```yaml
# oh-my-braincrew pre-commit configuration
# Generated by omb-git-setup
repos:
```

Python block (if `python` in `stack.languages`):
```yaml
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.4.0
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format
```

TypeScript/JavaScript block (if `typescript` or `javascript` in `stack.languages`):
```yaml
  - repo: local
    hooks:
      - id: eslint
        name: eslint
        entry: npx eslint
        language: node
        types_or: [javascript, ts, tsx]
        pass_filenames: true
```

After writing `.pre-commit-config.yaml`, run:
```bash
pre-commit install
```

Report the result of `pre-commit install` to the user.

### Step 3.3: Commit-msg Hook (Optional)

```
AskUserQuestion:
  question: |
    Add a commit-msg hook to enforce conventional commit format?

    | Commit Type | PR Label |
    |-------------|----------|
    | feat | Feature |
    | fix | Bugfix |
    | refactor | Refactor |
    | test | Test |
    | docs | Docs |
    | chore | Chore |
    | ci | CI |
    | perf | Improvements |
    | style | Style |
    | build | Build |

    Pattern: type(scope): description
  header: "Commit Format"
  options:
    - label: "Yes — add commit-msg hook"
      description: "Blocks commits that don't match the conventional commit format"
    - label: "No — skip"
      description: "No enforcement on commit message format"
```

If yes and `has_hook_commit_msg` is true:

```
AskUserQuestion:
  question: ".git/hooks/commit-msg already exists. Overwrite it?"
  header: "Overwrite Hook"
  options:
    - label: "Yes — overwrite"
      description: "Replace the existing commit-msg hook"
    - label: "No — skip"
      description: "Keep the existing hook as-is"
```

If overwrite confirmed (or no existing hook), generate `.git/hooks/commit-msg`:

```bash
#!/usr/bin/env bash
# oh-my-braincrew commit-msg hook
# Enforces conventional commit format
set -euo pipefail

COMMIT_MSG=$(cat "$1")
PATTERN='^(feat|fix|refactor|test|docs|chore|ci|perf|style|build)(\([a-z0-9-]+\))?: .{1,72}$'

if ! echo "$COMMIT_MSG" | grep -qE "$PATTERN"; then
  echo "ERROR: Commit message does not follow conventional commit format."
  echo "Expected: type(scope): description (max 72 chars)"
  echo "Types: feat, fix, refactor, test, docs, chore, ci, perf, style, build"
  echo ""
  echo "Your message: $COMMIT_MSG"
  exit 1
fi
```

After writing, run:
```bash
chmod +x .git/hooks/commit-msg
```

---

## Phase 4: .gitignore Review

Skip this phase if `--hooks-only` or `--actions-only` flag was provided.

### Recommended entries per stack

| Stack | Entries |
|-------|---------|
| Python | `__pycache__/`, `*.pyc`, `dist/`, `venv/`, `.venv/`, `.pytest_cache/`, `.ruff_cache/`, `.coverage`, `.pyright/` |
| Node/TS | `node_modules/`, `dist/`, `build/`, `.next/`, `.turbo/`, `*.tsbuildinfo`, `.eslintcache`, `coverage/` |
| Go | `bin/`, `vendor/` (conditional) |
| Rust | `target/` |
| Terraform | `.terraform/`, `*.tfstate*`, `*.tfvars` |
| General | `.env`, `.env.*`, `!.env.example`, `.DS_Store`, `.idea/`, `.vscode/`, `*.log` |

Build the recommended entry list from `stack` fields. Always include General entries.

### If `.gitignore` does not exist

Generate a full `.gitignore` from recommended entries for the detected stack. Show a preview, then:

```
AskUserQuestion:
  question: "No .gitignore found. Create one with entries for {{stack_summary}}?\n\nPreview:\n{{gitignore_preview}}"
  header: ".gitignore"
  options:
    - label: "Create .gitignore"
      description: "Write the generated .gitignore to project root"
    - label: "Skip"
      description: "Do not create .gitignore"
```

### If `.gitignore` exists

Read the existing `.gitignore`. Compare against recommended entries. Identify missing entries.

If there are missing entries:

```
AskUserQuestion:
  question: "Your .gitignore is missing {{N}} recommended entries for {{stack_summary}}:\n\n{{missing_entries_list}}\n\nAdd them?"
  header: ".gitignore"
  options:
    - label: "Add all missing entries"
      description: "Append recommended entries to existing .gitignore"
    - label: "Review and select"
      description: "Decide which entries to add"
    - label: "Skip"
      description: "Keep .gitignore as-is"
```

If "Review and select": ask one question per entry group (by stack), not per individual entry.

If no missing entries: report ".gitignore looks complete — no additions needed."

---

## Phase 5: GitHub Actions Suggestions

Skip this phase if `--hooks-only` or `--gitignore-only` flag was provided.

### Step 5.1: Scan Existing Workflows

Read `existing_workflows` from Phase 1 stack detection. List what is already present.

### Step 5.2: Workflow Selection

Present available workflows, noting any already present:

```
AskUserQuestion:
  question: "Select GitHub Actions workflows to add:\n\n(Already present: {{existing_workflows_list}})"
  header: "GitHub Actions"
  options:
    - label: "PR CI (lint + test)"
      description: "Runs linters and tests on every pull request"
    - label: "Commit lint"
      description: "Validates PR title follows conventional commit format"
    - label: "Secret scanning"
      description: "Runs gitleaks to detect exposed secrets on push"
    - label: "Slack notifications"
      description: "Sends PR/issue events to a Slack webhook"
    - label: "None — skip"
      description: "Do not add any GitHub Actions workflows"
```

Allow multi-select (user can list multiple options). For each selected workflow, proceed to Step 5.3.

### Step 5.3: Generate Workflows

Create `.github/workflows/` directory if it does not exist.

**PR CI workflow** (`ci.yml`):

Attempt to load CI templates by reading the relevant skill files:
- Python: read `.claude/skills/omb-ci-python/SKILL.md` and apply its CI template
- TypeScript: read `.claude/skills/omb-ci-typescript/SKILL.md` and apply its CI template
- Infra: read `.claude/skills/omb-ci-infra/SKILL.md` and apply its CI template

If skill files are not found, use these fallback inline templates:

Python CI fallback (`.github/workflows/ci-python.yml`):
```yaml
name: Python CI
on:
  pull_request:
    branches: [main]
jobs:
  lint-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - run: pip install ruff pytest
      - run: ruff check .
      - run: pytest tests/ -v
```

TypeScript CI fallback (`.github/workflows/ci-typescript.yml`):
```yaml
name: TypeScript CI
on:
  pull_request:
    branches: [main]
jobs:
  lint-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: npm
      - run: npm ci
      - run: npx eslint .
      - run: npx tsc --noEmit
      - run: npx vitest run
```

**Commit lint workflow** (`.github/workflows/commit-lint.yml`):
```yaml
name: Commit Lint
on:
  pull_request:
    types: [opened, synchronize, edited]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - name: Check PR title
        uses: amannn/action-semantic-pull-request@v5
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          types: |
            feat
            fix
            refactor
            test
            docs
            chore
            ci
            perf
            style
            build
```

**Secret scanning workflow** (`.github/workflows/secret-scan.yml`):
```yaml
name: Secret Scan
on:
  push:
    branches: [main]
  pull_request:
jobs:
  gitleaks:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**Slack notifications workflow** (`.github/workflows/notify-slack.yml`):
```yaml
name: Slack Notifications
on:
  pull_request:
    types: [opened, closed, ready_for_review]
  issues:
    types: [opened, closed]
jobs:
  notify:
    runs-on: ubuntu-latest
    steps:
      - name: Send Slack notification
        uses: slackapi/slack-github-action@v1.26.0
        with:
          payload: |
            {
              "text": "[${{ github.repository }}] ${{ github.event_name }}: ${{ github.event.pull_request.title || github.event.issue.title }}",
              "attachments": [{ "color": "good", "text": "${{ github.event.pull_request.html_url || github.event.issue.html_url }}" }]
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
          SLACK_WEBHOOK_TYPE: INCOMING_WEBHOOK
```

### Step 5.4: Slack Reminder

If Slack notifications workflow was generated, remind the user:

```
NOTE: Add SLACK_WEBHOOK_URL to your GitHub repository secrets:
  Repository → Settings → Secrets and variables → Actions → New repository secret
  Name: SLACK_WEBHOOK_URL
  Value: (your Slack incoming webhook URL)
```

---

## Phase 6: GitHub Labels

Skip this phase if `--hooks-only`, `--gitignore-only`, or `--actions-only` flag was provided.

### Step 6.1: Check GitHub Remote

```bash
git remote get-url origin 2>/dev/null
```

If the remote URL does not contain `github.com`: report "GitHub Labels — SKIPPED (not a GitHub remote)" and skip this phase.

### Step 6.2: Fetch Existing Labels

```bash
gh label list --json name,color,description --limit 100
```

Parse the JSON output into a list of existing labels.

### Step 6.3: Sync Canonical Labels

The canonical PR label list is:

| Label | Color | Description |
|-------|-------|-------------|
| `Feature` | `a2eeef` | New feature or capability |
| `Bugfix` | `d73a4a` | Bug fix |
| `Refactor` | `f9d0c4` | Code restructuring |
| `Test` | `bfd4f2` | Test additions or modifications |
| `Docs` | `0075ca` | Documentation only |
| `Chore` | `cfd3d7` | Maintenance, dependency updates |
| `CI` | `e6e6e6` | CI/CD pipeline changes |
| `Improvements` | `fbca04` | Performance and quality improvements |
| `Style` | `c5def5` | Code style/formatting |
| `Build` | `d4c5f9` | Build system changes |

For each canonical label, compare against existing labels:

- **Does not exist** → create:
  ```bash
  gh label create "{name}" --color "{color}" --description "{description}" --force 2>/dev/null || true
  ```
- **Exists but color differs** → update:
  ```bash
  gh label create "{name}" --color "{color}" --description "{description}" --force 2>/dev/null || true
  ```
- **Exists but description is empty** → update:
  ```bash
  gh label create "{name}" --color "{color}" --description "{description}" --force 2>/dev/null || true
  ```
- **Matches name, color, and has description** → skip (already up-to-date)

Note: `gh label create --force` is idempotent — it creates the label if missing or updates it if it exists.

### Step 6.4: Report

Output a sync result table:

```markdown
| Label | Status |
|-------|--------|
| Feature | Created / Updated / Up-to-date |
| Bugfix | Created / Updated / Up-to-date |
| ... | ... |
```

---

## Completion Signal

When this skill completes, report the result clearly.

On success, output "DONE" followed by a summary table:

```markdown
## Git Workflow Setup Complete

| Component | Status | Files |
|-----------|--------|-------|
| Pre-commit hooks | Created / Skipped | `.git/hooks/pre-commit` |
| Commit-msg hook | Created / Skipped | `.git/hooks/commit-msg` |
| .gitignore | Created / Updated / Skipped | `.gitignore` |
| GitHub Actions | Created (N) / Skipped | `.github/workflows/` |
| GitHub Labels | Synced (N created, N updated) / Skipped | (remote) |

### Files Created / Modified
List all files created or modified during this run.

### Next Steps
Provide relevant next steps based on what was configured (e.g., stage files, run hooks, add secrets).
```

On failure: State "FAILED" with reason.
On needing more context: State "NEEDS_CONTEXT" with what is missing.

[HARD] STOP AFTER REPORTING: After reporting, do NOT invoke the next skill or output additional commentary.
