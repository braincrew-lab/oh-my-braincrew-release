---
name: omb-lint-check
description: "Pre-commit lint check — detect tech stack from changed files and run appropriate linters. Reports pass/fail with file:line details."
user-invocable: true
argument-hint: "[--staged | --all | specific files]"
---

# Pre-Commit Lint Check

Run static analysis on changed files before committing. Detects the project tech stack from file extensions and runs the appropriate linters on changed files only (not the entire repo).

## When to Use

- Before creating a commit (called by git-commit agent as step 5)
- Manually via `/omb-lint-check` to check current changes
- After implementing code, before marking a task as done

## Execution Steps

<execution_order>
1. **Get changed files**: Determine which files to lint.
   - If `--staged` or called from git-commit: `git diff --cached --name-only --diff-filter=ACMR`
   - If `--all` or no flag: `git diff --name-only --diff-filter=ACMR` (unstaged changes)
   - If specific files provided: use those files directly
   - If no changed files found, report PASS with "No files to lint" and stop.

2. **Filter excluded paths**: Remove files matching these patterns:
   - `node_modules/`, `.git/`, `__pycache__/`, `dist/`, `build/`, `.next/`, `venv/`, `.venv/`
   - Any path listed in `.gitignore`

3. **Group files by type**: Map file extensions to linter groups:

   | Extension | Linter Group | Tool |
   |-----------|-------------|------|
   | `*.py` | Python | ruff |
   | `*.ts`, `*.tsx` | TypeScript | eslint, tsc |
   | `*.js`, `*.jsx` | JavaScript | eslint |
   | `Dockerfile*` | Docker | hadolint |
   | `*.yml`, `*.yaml` (in k8s/, kubernetes/, docker-compose*) | YAML | yamllint |
   | `*.sql` | SQL | sqlfluff |
   | `*.tf` | Terraform | terraform validate |

4. **Check tool availability**: For each linter group with files, verify the tool exists:
   ```bash
   command -v {tool} &>/dev/null
   ```
   - If tool is missing: record WARNING (not FAIL). Fail-open — do not block on missing tools.
   - If tool exists: proceed to run it.

5. **Run linters on changed files only**:

   **Python** (ruff):
   ```bash
   ruff check {file1} {file2} ...
   ```

   **TypeScript/JavaScript** (eslint):
   ```bash
   npx eslint {file1} {file2} ... --no-error-on-unmatched-pattern
   ```

   **TypeScript** (tsc — only if tsconfig.json exists in project root):
   ```bash
   npx tsc --noEmit
   ```
   Note: tsc checks the entire project, not individual files. Run once if any .ts/.tsx files changed.

   **Dockerfile** (hadolint):
   ```bash
   hadolint {file1} {file2} ...
   ```

   **YAML** (yamllint):
   ```bash
   yamllint -d relaxed {file1} {file2} ...
   ```

   **SQL** (sqlfluff — only if .sqlfluff or pyproject.toml with sqlfluff config exists):
   ```bash
   sqlfluff lint {file1} {file2} ...
   ```

   **Terraform** (terraform validate — only if .tf files present):
   ```bash
   cd {terraform-dir} && terraform validate
   ```

6. **Collect and report results**: Aggregate all linter output into a summary.
</execution_order>

## Output Format

Report results in this structured format:

```markdown
## Lint Check Results

### Summary
| Metric | Count |
|--------|-------|
| Files checked | N |
| Passed | N |
| Failed | N |
| Warnings (missing tools) | N |

### Failures
| File | Line | Linter | Severity | Message |
|------|------|--------|----------|---------|
| src/app.py | 42 | ruff | error | E501 line too long (120 > 88) |
| src/utils.ts | 15 | eslint | error | no-unused-vars: 'x' is declared but never used |

### Warnings (if any)
- [yamllint] Tool not installed — skipped YAML lint. Install: `pip install yamllint`
- [sqlfluff] Tool not installed — skipped SQL lint. Install: `pip install sqlfluff`

### Verdict: PASS | FAIL
```

## Verdict Rules

- **PASS**: All linters that ran reported zero errors (warnings from linters are acceptable)
- **FAIL**: Any linter reported at least one error
- Missing tools do NOT cause FAIL — they produce a WARNING with install instructions

## Fail-Open Pattern

This skill follows the same fail-open philosophy as `omb-hook.sh PostToolUse`:
- If a linter binary is not found, warn and skip — do not block
- If a linter config file is missing (e.g., no `.eslintrc`), skip that linter
- Only actual lint errors cause FAIL

## Common Install Commands

If a tool is missing, suggest the appropriate install command:

| Tool | Install Command |
|------|----------------|
| ruff | `pip install ruff` or `uv tool install ruff` |
| eslint | `npm install -g eslint` or project-local via `npx` |
| hadolint | `brew install hadolint` (macOS) or `apt-get install hadolint` |
| yamllint | `pip install yamllint` |
| sqlfluff | `pip install sqlfluff` |
| terraform | See https://developer.hashicorp.com/terraform/install |
