---
description: Canonical ticket schema for P0-P3 issue tickets across all evaluation, review, and verification skills
---

# Ticket Schema

Canonical format for P0-P3 issue tickets used across all evaluation, review, and verification skills.

## Ticket ID Format

```
{PREFIX}-P{0-3}-{NNN}
```

- `PREFIX`: Two-letter source identifier (see Prefix Table)
- `P{0-3}`: Priority level
- `NNN`: Sequential number per priority within the report (001, 002, ...)

### Prefix Table

| Context | Evaluation Prefix | Consensus Prefix | Example |
|---------|------------------|-----------------|---------|
| Plan | `EP` | `CP` | `EP-P0-001`, `CP-P1-003` |
| Verify | `EV` | `CV` | `EV-P0-001`, `CV-P2-002` |
| Prompt | `PP` | — | `PP-P0-001` |

- **Evaluation prefixes** (`EP`, `EV`, `PP`) are set by evaluation skills (producers).
- **Consensus prefixes** (`CP`, `CV`) are set by orchestration skills during consensus synthesis.
- `PP` has no consensus prefix because prompt-review is a single-reviewer workflow.

## Priority Definitions

| Priority | Criteria | Action |
|----------|----------|--------|
| P0 | Blocks correctness or safety. Must fix before proceeding. | Iteration required |
| P1 | Significant quality gap. Should fix before delivery. | Iteration required |
| P2 | Minor quality issue. Fix if time permits. | Advisory |
| P3 | Cosmetic or stylistic. No functional impact. | Advisory |

## Individual Ticket Format

Used by: omb-evaluation-plan, omb-evaluation-impl, omb-prompt-evaluation

```markdown
### {PREFIX}-P{0-3}-{NNN}: {Title}

| Field | Value |
|-------|-------|
| **Dimension** | {rubric dimension name} |
| **Item** | `{checklist_id}` — {human-readable name} |
| **Evidence** | {context-appropriate — see Evidence Format} |
| **Impact** | {what goes wrong if unfixed — one sentence} |
| **Root Cause** | {why this issue exists} |
| **Remediation** | {specific fix with concrete example} |
| **Status** | OPEN |
```

### Field Rules

| Field | Required | Notes |
|-------|----------|-------|
| Dimension | Always | Rubric dimension name |
| Item | Always | `{checklist_id}` — human-readable name |
| Evidence | Always | See Evidence Format below |
| Impact | Always | What goes wrong if unfixed. One sentence. |
| Root Cause | Conditional | Required for `PP-*` (prompt). Optional for `EP-*`/`EV-*`. |
| Remediation | Always | Specific fix with concrete example (before/after, or exact addition). |
| Status | Always | `OPEN` when created by evaluation skills. Updated by orchestration skills. |

## Evidence Format

Evidence format is context-dependent:

| Context | Format | Example |
|---------|--------|---------|
| Plan evaluation | Quoted plan text or `"not found"` | `"Section 1.4 is absent"` |
| Code evaluation | `` `file:line` `` — `"description"` | `` `src/api/auth.py:42` — "missing error handler" `` |

This distinction is intentional: plan tickets reference document sections, code tickets reference source locations.

## Status Lifecycle

```
OPEN → RESOLVED (R{n}) | DEFERRED
```

- `OPEN`: Created by evaluation skills. Default state.
- `RESOLVED (R{n})`: Fixed in iteration round `n`. Set by orchestration skills.
- `DEFERRED`: Intentionally not fixed. Set by orchestration skills with justification.

Status is managed by **orchestration skills** (omb-plan, omb-plan-review, omb-verify, omb-prompt-review), not by evaluation skills.

## Consensus Finding Table

Used by: omb-plan (Step 3.5), omb-plan-review (Step 4), omb-verify (Step 5)

```markdown
| Ticket | Finding | Flagged By | Consensus | Priority | Evidence | Status |
|--------|---------|-----------|-----------|----------|----------|--------|
| CP-P0-001 | {finding} | @agent1, @agent2 | Majority (3/5) | P0 | "quoted text" | OPEN |
```

| Column | Description | Format |
|--------|-------------|--------|
| Ticket | Unique ID | `{CP\|CV}-P{0-3}-{NNN}` |
| Finding | What is wrong | One sentence, concrete and actionable |
| Flagged By | Which reviewers agreed | `@agent1, @agent2` — comma-separated |
| Consensus | Vote ratio | `{level} ({count}/{total})` |
| Priority | Derived from consensus | `P0` \| `P1` \| `P2` \| `P3` |
| Evidence | Plan text or code reference | Context-appropriate (see Evidence Format) |
| Status | Lifecycle tracking | `OPEN` \| `RESOLVED (R{n})` \| `DEFERRED` |

### Consensus-to-Priority Mapping

| Consensus Level | Threshold | Priority |
|----------------|-----------|----------|
| Majority | >50% of reviewers | P0 |
| Strong minority | 33-50% | P1 |
| Minority | <33% | P2 |
| Single voice | 1 reviewer | P3 |

Veto power: `@core-critique` BLOCKING = min P1, `@security-audit` BLOCKING = min P1.

## Score Sheet

Used by: omb-evaluation-plan, omb-evaluation-impl, omb-prompt-evaluation

### Plan/Prompt Variant (8 columns)

```markdown
| # | Dimension | Pass | Fail | N/A | Score | Weight | Weighted |
|---|-----------|------|------|-----|-------|--------|----------|
| 1 | {dimension} | 4 | 2 | 0 | 67% | 15% | 10.0% |
| | **Total** | **32** | **10** | **2** | | | **72%** |
```

### Verify Variant (9 columns — adds Blocked)

```markdown
| # | Dimension | Pass | Fail | Blocked | N/A | Score | Weight | Weighted |
|---|-----------|------|------|---------|-----|-------|--------|----------|
| 1 | {dimension} | 5 | 1 | 0 | 0 | 83% | 20% | 16.7% |
```

- `Blocked` column is verify-only (tool unavailability). Plan/Prompt evaluations omit it.
- Score = `pass / (pass + fail)` — N/A and Blocked excluded from denominator.
- Weighted = Score × Weight. Overall = sum of Weighted column.

## Issue Resolution Summary

Used by: omb-plan-review (Step 7), omb-verify (Step 8), omb-prompt-review (iteration log)

```markdown
| Ticket | Source | Priority | Status | Round | Resolution |
|--------|--------|----------|--------|-------|------------|
| CP-P0-001 | Consensus | P0 | RESOLVED | R1 | Added rate limit config |
| EP-P0-002 | Evaluation | P0 | RESOLVED | R1 | Added acceptance criteria |
```

| Column | Description | Format |
|--------|-------------|--------|
| Ticket | Original ticket ID | `{EP\|CP\|EV\|CV\|PP}-P{0-3}-{NNN}` |
| Source | Origin system | `Evaluation` \| `Consensus` \| `Lint` |
| Priority | Original priority | `P0` \| `P1` \| `P2` \| `P3` |
| Status | Final state | `RESOLVED` \| `DEFERRED` \| `OPEN` |
| Round | Which iteration resolved it | `R{n}` or `—` if still open |
| Resolution | What was done | One sentence describing the fix or deferral reason |

## Iteration History Table

Used by: omb-plan (Step 6), omb-plan-review (final report), omb-verify (final report)

```markdown
| Round | Score | Grade | P0 | P1 | P2 | P3 | Reviewers | Key Changes |
|-------|-------|-------|----|----|----|----|-----------| ------------|
| Draft | 62% | D | 2 | 3 | 4 | 1 | 5 | — |
| R1 | 78% | C | 0 | 1 | 3 | 1 | 5 | Rate limit, acceptance criteria |
```

## Grade Thresholds

| Grade | Score Range |
|-------|------------|
| A | ≥ 90% |
| B | ≥ 80% |
| C | ≥ 65% |
| D | ≥ 50% |
| F | < 50% |
