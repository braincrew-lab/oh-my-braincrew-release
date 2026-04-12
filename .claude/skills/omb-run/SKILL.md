---
name: omb-run
description: "Execute implementation plans — parse TODO checklist, delegate to domain agents, enforce TDD, track progress in .omb/todo/, incremental lint checks. Supports --worktree isolation and session recovery."
user-invocable: true
argument-hint: "[--worktree] [plan file path]"
---

# Plan Executor

Reads an `omb-plan` output file (`.omb/plans/*.md`), tracks progress in `.omb/todo/`, and executes each task by delegating to domain-specific agents. Enforces TDD and runs lint checks after every implementation task.

## Architecture

```
Skill("omb-run") orchestrates:

  Step 0: Resolve Plan File
    |
  Step 1: Worktree Setup (if --worktree)
    |
  Step 2: Create or Resume TODO Tracker (.omb/todo/)
    |
  Step 3: Parse Plan (Section 3 + Section 4)
    |
  Step 4: Execute Task Loop
    |--- 4a: Dependency check
    |--- 4b: Resolve domain + agent from plan annotation
    |--- 4c: Delegate via orchestration skill or direct Agent()
    |--- 4d: TDD enforcement (RED -> GREEN -> IMPROVE)
    |--- 4e: Skill("omb-lint-check") after implementation
    |--- 4f: Update TODO tracker
    |--- 4g: Handle RETRY / BLOCKED
    |
  Step 5: Final Verification
    |
  Step 6: Worktree Merge (if --worktree, with user approval)
    |
  Step 7: Summary Report
```

## When to Apply

- After `omb-plan` has produced a plan file in `.omb/plans/`
- User says "run", "execute", "implement the plan", or references a plan file
- When resuming interrupted implementation (todo file already exists)

## Write Permissions

```
WRITE: .omb/todo/*.md (todo tracking files)
WRITE: All source files via delegated Agent() calls
READ:  .omb/plans/*.md, entire codebase
```

---

## Step 0: Resolve Plan File

Parse the skill argument to extract the plan file path and flags.

### Argument Parsing

```
omb-run [--worktree] [plan-file-path]
```

- `--worktree`: Optional flag. If present, set `worktree_mode = true`.
- `plan-file-path`: Path to the plan `.md` file. Can be:
  - Absolute path: `/path/to/.omb/plans/2026-04-11-name.md`
  - Relative path: `.omb/plans/2026-04-11-name.md`
  - Filename only: `2026-04-11-name.md` (resolve under `.omb/plans/`)

### Resolution Rules

1. **Explicit path**: Validate the file exists. If not found at the given path, try prepending `.omb/plans/`.
2. **No path provided**: List `.omb/plans/*.md` and pick the most recent by filename date prefix. If multiple plans share the same date, use `AskUserQuestion` to let the user choose.
3. **Validation**: Confirm the plan has **Section 3** (TODO checklist) and **Section 4** (implementation details). If either is missing, report BLOCKED with the specific missing section.

---

## Step 1: Worktree Setup (conditional)

**Only execute when `worktree_mode = true`.** Follow `.claude/rules/workflow/07-worktree-protocol.md`.

<execution_order>
1. Derive branch name from plan filename: `{type}/{plan-kebab-name}` (e.g., `feat/user-auth-flow` from `2026-04-11-user-auth-flow.md`). Infer `{type}` from plan content (feature → `feat`, bug fix → `fix`, refactor → `refactor`). Default to `feat` if ambiguous.
2. Run the worktree setup script:
   ```bash
   bash .claude/hooks/omb/omb-hook.sh WorktreeSetup {type}/{plan-kebab-name}
   ```
3. Enter the worktree and verify `pwd`:
   ```bash
   cd worktrees/{type}/{plan-kebab-name} && pwd
   ```
   Confirm the output matches `{project-root}/worktrees/{type}/{plan-kebab-name}`.
4. Confirm the plan file is accessible from the worktree
5. If the setup script exits non-zero or `pwd` mismatches: report BLOCKED and stop — do NOT proceed in the main tree
</execution_order>

Record for Step 6:
- `worktree_active = true`
- `worktree_branch = {type}/{plan-kebab-name}`
- `worktree_path = {project-root}/worktrees/{type}/{plan-kebab-name}`

---

## Step 2: Create or Resume TODO Tracker

The TODO file path is `.omb/todo/{plan-filename}.md` — same filename as the plan file.

### Case A: File Does Not Exist (New Execution)

1. Create `.omb/todo/` directory if it does not exist
2. Parse Section 3 of the plan to extract all tasks
3. Generate the TODO tracker file:

```markdown
# Execution Tracker: {plan title from H1}

> Plan: .omb/plans/{filename}.md
> Started: {current YYYY-MM-DD HH:MM}
> Last updated: {current YYYY-MM-DD HH:MM}
> Status: IN_PROGRESS

## Progress

| # | Task | Agent | Domain | Status | Retries | Started | Completed |
|---|------|-------|--------|--------|---------|---------|-----------|
| 1 | {task description} | @{agent} | {domain} | PENDING | 0 | — | — |
| 2 | ... | ... | ... | PENDING | 0 | — | — |

## Task Log

<!-- Appended per task as execution proceeds -->
```

### Case B: File Already Exists (Session Recovery)

1. Read the existing TODO tracker file
2. Find the first row with Status = `PENDING` or `RETRY`
3. Report resume point to user: **"Resuming from task #{n}: {task description}"**
4. Continue from that task in Step 4

---

## Step 3: Parse Plan

Extract two data structures from the plan file.

### From Section 3 (TODO Checklist)

Parse each line matching this pattern:

```
- [ ] #{n} [CP] {description} -> @{agent} | Skill("{skill}")
```

Where:
- `#{n}` — task number
- `[CP]` — critical path flag (optional)
- `{description}` — task description
- `@{agent}` — agent to delegate to
- `Skill("{skill}")` — skill to load (optional)
- Handle arrow variants: `→` and `->`
- Handle optional `|` delimiter between agent and skill

Extract per task:
- `task_number`, `is_critical_path`, `description`, `agent`, `skill`

### From Section 4 (Phase Details)

Parse the phase tables to enrich each task with:

```
| # | Task | Agent | Skill | MCP Tool | Dependencies | Deliverable |
```

Cross-reference by task `#` column. Extract per task:
- `phase` — which phase group
- `dependencies` — list of task numbers that must complete first
- `deliverables` — expected output files/artifacts
- `mcp_tools` — MCP tools needed (or `—`)
- `implementation_notes` — text under `구현 참고사항` for the task's phase

---

## Step 4: Execute Task Loop

For each task in order (respecting dependencies):

### 4a. Dependency Check

Before starting task `#n`, verify ALL tasks listed in its `dependencies` column have Status = `DONE` in the TODO tracker.

- If a dependency is `BLOCKED`: mark this task `BLOCKED` with reason `"dependency #{dep} blocked"`
- If a dependency is `PENDING` but appears later in the list: execution order error — flag and stop

### 4b. Domain Resolution

Use the agent delegation table to resolve domain and execution mode:

| @agent Pattern | Domain | Orchestration Skill | Implement | Verify |
|----------------|--------|---------------------|-----------|--------|
| @api-* | API | `omb-orch-api` | @api-implement | @api-verify |
| @db-* | DB | `omb-orch-db` | @db-implement | @db-verify |
| @ui-* | UI | `omb-orch-ui` | @ui-implement | @ui-verify |
| @electron-* | Electron | `omb-orch-electron` | @electron-implement | @electron-verify |
| @ai-* | AI | `omb-orch-ai` | @ai-implement | @ai-verify |
| @infra-* | Infra | `omb-orch-infra` | @infra-implement | @infra-verify |
| @security-* | Security | `omb-orch-security` | @security-implement | — |
| @code-* | Code | `omb-orch-code` | @code-test | — |
| @docs-* | Docs | — (direct `Agent()`) | @doc-writer | — |

**Resolution logic:**
1. Extract domain prefix from @agent-name (e.g., @api-implement -> `api` -> API)
2. Determine task type from agent suffix: `-design`, `-implement`, `-verify`, `-test`, `-write`, `-review`, `-audit`

### 4c. Delegation — Two Modes

**Mode A: Full Orchestration (for `-implement` agents)**

Load the domain orchestration skill and execute its full cycle:

```
Skill("omb-orch-{domain}") with task context:
  - Task: #{n} {description}
  - Implementation notes: {from Section 4}
  - Expected deliverables: {from Section 4}
  - Dependency artifacts: {changed_files from completed predecessor tasks}
  - TDD: Skill("omb-tdd") MUST be loaded by implement agent
```

The orchestration skill handles its own design-critique-implement-verify sub-cycle with retries.

**Mode B: Direct Agent Delegation (for `-design`, `-test`, `-write`, `-review`, `-audit` agents)**

Spawn the specific agent directly:

```
Agent({
  subagent_type: "{agent-name}",
  prompt: "Task #{n}: {description}

Context from plan:
{Section 4 implementation notes for this task's phase}

Expected deliverable: {deliverable}

Previous task outputs:
{list of artifacts from completed dependency tasks}

Rules:
- Follow output contract: end with <omb>DONE|RETRY|BLOCKED</omb> + result envelope
- Scope: implement ONLY what is described above — no extras"
})
```

### 4d. TDD Enforcement

For every task that creates or modifies source code (implement, test agents):

1. The agent prompt MUST reference `Skill("omb-tdd")` so TDD rules are loaded
2. Expect RED-GREEN-IMPROVE evidence in the agent's result
3. If the result does not mention test execution and the task is an implement task: mark as `RETRY` with feedback `"TDD cycle not evidenced — rerun with explicit RED-GREEN-IMPROVE steps"`

### 4e. Post-Task Lint Check

After every task that modifies source files:

1. Run `Skill("omb-lint-check")` in the main session
2. **Lint PASS**: proceed to mark task DONE
3. **Lint FAIL**: spawn @code-debug agent with lint failures, then re-execute the implement agent with debug output. This counts toward the retry budget.

### 4f. Update TODO Tracker

After each task completes or fails, **immediately** update the `.omb/todo/` file:

1. Update the task's row in the Progress table:
   - `Status`: `DONE`, `RETRY`, or `BLOCKED`
   - `Retries`: increment if retried
   - `Started` / `Completed`: timestamps

2. Append a task log entry:

```markdown
### Task #{n}: {description}
- Agent: @{agent}
- Status: {DONE | BLOCKED}
- Artifacts: {list of files created/modified from agent's changed_files}
- Notes: {concerns from agent's result, if any}
```

3. Update the file header's `Last updated` timestamp

### 4g. Error Handling and Retry Policy

```
<omb>DONE</omb>:
  -> Run Skill("omb-lint-check")
  -> Lint PASS: mark DONE, next task
  -> Lint FAIL: spawn code-debug, retry implement (budget: 3 total)

<omb>RETRY</omb>:
  -> Design agents: retry with agent's feedback (max 2)
  -> Implement agents: spawn code-debug first, then retry (max 3)
  -> Track retry count in TODO tracker

<omb>BLOCKED</omb>:
  -> Mark task BLOCKED in TODO tracker with blocker reason
  -> If task is [CP] (critical path): STOP execution, report to user
  -> If task is NOT [CP]: skip, continue with next task that has no dependency on this one
  -> If ALL remaining tasks depend on the blocked task: STOP, report to user

After max retries exhausted:
  -> Mark task BLOCKED with reason "max retries exceeded"
  -> Follow same BLOCKED handling as above
```

---

## Step 5: Final Verification

After all tasks are processed:

1. Run the full test suite for the project:
   - Python: `pytest` (if `pyproject.toml` or `pytest.ini` exists)
   - TypeScript: `npx vitest run` (if `vitest.config.*` exists)
   - Or use the test commands specified in Section 6 (TDD verification plan) of the plan
2. Run `Skill("omb-lint-check") --all` for a comprehensive lint pass
3. Report results but do NOT loop — present failures to user for decision

---

## Step 6: Worktree Merge (conditional)

**Only when `worktree_active = true`.** Follow `.claude/rules/workflow/07-worktree-protocol.md`.

1. Present the implementation summary to the user
2. Ask via `AskUserQuestion`:
   ```
   Implementation complete in worktree branch `{worktree_branch}`.
   Options:
   1. Merge — merge changes into the original branch, then remove worktree
   2. Keep — keep worktree for manual review
   3. Discard — remove worktree and delete branch
   ```
3. On **merge**:
   ```bash
   cd {original project root} && git merge {worktree_branch}
   bash .claude/hooks/omb/omb-hook.sh WorktreeTeardown {worktree_branch} --delete-branch
   ```
4. On **keep**:
   ```bash
   cd {original project root}
   ```
5. On **discard**:
   ```bash
   cd {original project root}
   bash .claude/hooks/omb/omb-hook.sh WorktreeTeardown {worktree_branch} --delete-branch
   ```
6. Verify return: run `pwd` and confirm CWD is back at the original project root.

**NEVER auto-merge. Always ask the user.**

---

## Step 7: Summary Report

Present the final execution report:

```markdown
## Execution Summary

**Plan:** .omb/plans/{filename}.md
**TODO:** .omb/todo/{filename}.md
**Worktree:** {branch name or "N/A"}

### Task Results

| # | Task | Status | Retries | Artifacts |
|---|------|--------|---------|-----------|
| 1 | ... | DONE | 0 | file1.py, file2.py |
| 2 | ... | DONE | 1 | ... |
| 3 | ... | BLOCKED | — | — |

### Statistics
- Tasks completed: X / Y
- Tasks blocked: Z
- Total retries: N
- Final lint: PASS | FAIL
- Final tests: PASS | FAIL

### Blocked Tasks (if any)
- #{n}: {blocker reason}

### Next Steps
- {Suggested actions for blocked tasks}
- {Manual verification items from plan Section 8}
```

---

## Anti-Patterns

| Anti-Pattern | Why It's Bad | Correct Approach |
|-------------|-------------|-----------------|
| Skipping lint checks between tasks | Errors accumulate, harder to fix later | `Skill("omb-lint-check")` after every source-modifying task |
| Auto-merging worktrees | User loses review opportunity | Always `AskUserQuestion` before merge |
| Continuing past BLOCKED `[CP]` task | All downstream tasks will fail | Stop execution, report to user |
| Running tasks out of dependency order | Missing prerequisites cause failures | Check dependency column before each task |
| Batching TODO updates | Session crash loses progress | Update `.omb/todo/` immediately after each task |
| Passing insufficient context to agents | Agent makes wrong assumptions | Include Section 4 notes + dependency artifacts |
| Re-running entire plan after recovery | Wastes time redoing completed work | Resume from first PENDING/RETRY in TODO tracker |

## Rules

- Sequential task execution within dependency chains; independent tasks within the same phase MAY run in parallel via multiple `Agent()` calls in a single message
- Every implement task MUST go through TDD — enforced by including `Skill("omb-tdd")` in agent prompts
- `Skill("omb-lint-check")` after every task that modifies source files — no exceptions
- TODO tracker MUST be updated after every single task, not batched
- Worktree operations use `.claude/hooks/omb/omb-hook.sh WorktreeSetup` and `.claude/hooks/omb/omb-hook.sh WorktreeTeardown` scripts — follow `.claude/rules/workflow/07-worktree-protocol.md`
- If the plan file is modified after execution starts, warn the user but do NOT re-parse automatically
- English only for all skill content, prompts, and agent instructions
- The main session orchestrates — sub-agents CANNOT spawn other agents
- Every sub-agent MUST end with `<omb>STATUS</omb>` + result envelope (see `.claude/rules/output-contract.md`)
