---
name: omb-prompt-review
description: "Iterative prompt improvement loop. Loads omb-prompt-guide for reference, runs omb-prompt-evaluation for quantitative scoring, then fixes issues and re-evaluates until all P0/P1 issues are resolved. Use when asked to review, audit, improve, or polish a prompt."
user-invocable: true
argument-hint: "<prompt text or file path>"
---

# Prompt Review (Iterative Improvement Loop)

Orchestrates a continuous improve-evaluate cycle until the prompt meets quality standards.

## Workflow Overview

```
┌──────────────────────────────────────────────────────┐
│  1. Load omb-prompt-guide (reference)                 │
│  2. Run omb-prompt-evaluation (score + tickets)       │
│  3. Diagnose root causes (cluster related failures)   │
│  4. Plan fixes (one fix per root cause, not per item) │
│  5. Implement fixes                                   │
│  6. Re-evaluate + regression check                    │
│  7. Loop (3-6) until exit condition met               │
│  8. Report final results                              │
└──────────────────────────────────────────────────────┘
Max iterations: 3
Exit when: 0 P0 + 0 P1 issues, OR plateau detected, OR max iterations
```

## Step-by-Step

### Step 1: Load Reference

Load `omb-prompt-guide` to have the full rule set available for remediation guidance.

### Step 2: Initial Evaluation

Run `omb-prompt-evaluation` on the input prompt. This produces:
- **Score sheet** — Evidence-anchored pass/fail across 52 items, 11 dimensions
- **Issue tickets** — P0-P3 prioritized with quoted evidence and remediation

### Step 3: Diagnose Root Causes

Before fixing individual issues, cluster related failures by root cause. Multiple FAIL items often share a single underlying problem. Fixing the root cause resolves multiple items at once.

**Root Cause Categories:**

| Category | Signal | Fix Approach |
|----------|--------|-------------|
| **STRUCTURAL** | Multiple structure.* and separation failures | Add XML tag structure: `<role>`, `<task>`, `<rules>`, `<format>`. Reorder components per 10-component framework. |
| **UNDERSPECIFIED** | Multiple clarity.* and output.* failures | Replace each vague qualifier with a concrete number. Add explicit format specification with schema. Add 2-3 input-output examples. |
| **MISSING-COMPONENT** | Entire dimension scores 0% | Add the missing component entirely: role section, examples block, safety rules, verification step. |
| **OVERENGINEERED** | safety.calibrated FAIL + clarity.no-conflicts | Prune excessive CRITICAL/MUST/NEVER language. Resolve contradictory instructions. Simplify to targeted rules. |
| **CONTEXT-MISMATCH** | claude-code.* or tool.* failures on wrong prompt type | Reframe for the correct use case (agent vs chat, Claude Code vs API, single-turn vs multi-window). |

**Diagnosis output format:**

```
Root Cause Analysis:
1. STRUCTURAL — No XML tags → affects structure.xml-tags, structure.separation, structure.ordering
2. UNDERSPECIFIED — Vague constraints → affects clarity.specificity, output.length-specified
3. MISSING-COMPONENT — No examples → affects examples.present, examples.format-demo, examples.good-bad
```

### Step 4: Improvement Loop

For each iteration (max 3):

1. **Plan fixes by root cause** — One fix per root cause, not per item
2. **Apply fixes** using the Fix Strategy Templates (below):
   - Reference the specific `omb-prompt-guide` rule for each fix
   - Apply the remediation from the issue ticket
   - Preserve all existing good qualities (do not regress)
3. **Re-evaluate** — Run `omb-prompt-evaluation` on the improved prompt
4. **Regression check** — Produce a diff table:

```
| Item ID | Before | After | Delta |
|---------|--------|-------|-------|
| clarity.task-objective | FAIL | PASS | +1 |
| structure.xml-tags | PASS | PASS | 0 |
| examples.present | PASS | FAIL | -1 REGRESSION |
```

**Any REGRESSION (-1) entries must be fixed before proceeding.** If a fix introduces a regression, the fix is wrong — revise it.

5. **Check exit condition**:
   - **Exit if:** 0 P0 AND 0 P1 remaining → proceed to final report
   - **Continue if:** P0 or P1 issues remain AND iterations < 3
   - **Force exit if:** iterations = 3 → report with remaining issues
   - **Plateau exit** (see below)

## Fix Strategy Templates

For each root cause category, apply the corresponding template:

### STRUCTURAL fixes
1. Wrap content types in XML tags: `<role>`, `<task>`, `<rules>`, `<examples>`, `<format>`
2. Reorder components per 10-component framework (role → context → task → rules → examples → format)
3. Nest hierarchical content with parent-child tags (`<examples><example>`)

### UNDERSPECIFIED fixes
1. Replace each vague qualifier with a concrete number ("short" → "max 3 sentences")
2. Add 2-3 input-output examples in `<examples>` tags
3. Add explicit format specification with schema or template

### MISSING-COMPONENT fixes
1. Add the missing section using the minimal template from `omb-prompt-guide`
2. Place it in the correct position per the 10-component framework
3. Keep it minimal — add just enough to pass the relevant checklist items

### OVERENGINEERED fixes
1. Count CRITICAL/MUST/NEVER instances — reduce to 2-3 targeted rules
2. Identify and resolve contradictory instructions
3. Remove redundant safety language that doesn't add new constraints

### CONTEXT-MISMATCH fixes
1. Identify the actual use case (agent, chat, Claude Code, API)
2. Add/remove dimensions based on the N/A Decision Tree
3. Reframe instructions for the correct context (e.g., add verification for agents)

### Step 4: Final Report

```
## Prompt Review — Final Report

### Iteration Summary

| Iteration | Score | P0 | P1 | P2 | P3 | Changes Made |
|-----------|-------|----|----|----|----|--------------| 
| Initial   | XX%   | X  | X  | X  | X  | —            |
| Round 1   | XX%   | X  | X  | X  | X  | [summary]    |
| Round 2   | XX%   | X  | X  | X  | X  | [summary]    |
| Final     | XX%   | X  | X  | X  | X  | [summary]    |

### Issue Resolution Log

| Ticket | Priority | Status | Resolution |
|--------|----------|--------|------------|
| PP-P0-001 | P0 | RESOLVED (R1) | [what was fixed] |
| PP-P1-001 | P1 | RESOLVED (R2) | [what was fixed] |
| PP-P2-001 | P2 | OPEN | [deferred — not blocking] |
| PP-P3-001 | P3 | OPEN | [optional improvement] |

### Remaining Issues (P2/P3 — non-blocking)

[List any P2/P3 issues that were not addressed, with remediation hints]

### Final Prompt

[The fully improved prompt after all iterations]

### Verdict

- **PASS** — 0 P0, 0 P1, overall score ≥80%
- **CONDITIONAL PASS** — 0 P0, 0 P1, overall score 65-79%
- **FAIL** — P0 or P1 issues remain after 3 iterations
```

## Exit Conditions

| Condition | Action |
|-----------|--------|
| 0 P0 + 0 P1 + score ≥80% | **PASS** — output final prompt |
| 0 P0 + 0 P1 + score 65-79% | **CONDITIONAL PASS** — output with P2/P3 notes |
| P0 or P1 remain after 3 iterations | **FAIL** — output best version + unresolved tickets |
| **Score plateau** | **PLATEAU** — stop early (see criteria below) |

### Plateau Detection (improved)

Stop early when improvement has stalled. Three plateau signals:

| Signal | Criterion | Action |
|--------|-----------|--------|
| **Score plateau** | Overall score improves <3% AND no P0/P1 issues resolved in this iteration | Stop — diminishing returns |
| **Issue plateau** | Same P0/P1 issues remain open after fix attempt (fix didn't work) | Stop — root cause needs user input |
| **Oscillation** | An issue resolved in round N reappears as FAIL in round N+1 | Stop — fix is introducing regressions |

When a plateau is detected, report which signal triggered it and suggest what the user should consider.

## Rules

- **Do not regress** — Each iteration must preserve all previously passing items. Produce the regression diff table to verify.
- **Diagnose before fixing** — Cluster failures by root cause before applying fixes. One root cause fix > five item-level fixes.
- **P0 before P1** — Always fix critical issues first
- **P2/P3 are optional** — Only fix P2/P3 if P0/P1 are already resolved and iterations remain
- **Show your work** — Each fix must reference the guide rule AND the root cause category it addresses
- **Minimal changes** — Fix the issue without rewriting unaffected sections
- **Evidence in tickets** — Every issue ticket must include the quoted evidence from the evaluation
- **Ticket format** — See `.claude/rules/workflow/09-ticket-schema.md` for canonical schema. Use `PP-P{N}-{NNN}` prefix for all tickets.
