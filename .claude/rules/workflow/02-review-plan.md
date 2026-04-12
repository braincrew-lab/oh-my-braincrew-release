---
description: Plan review rules — automated evaluation via plan-evaluator and manual pre-mortem checklist
---

# Plan Review

Plans are reviewed through two complementary mechanisms: automated rubric evaluation and manual pre-mortem analysis.

## Automated Evaluation (Primary)

The `@plan-evaluator` agent scores plans using the `omb-evaluation-plan` rubric:

- **~44 checklist items** across 9 dimensions (Requirements, Domain Decomposition, Agent Delegation, Technical Specification, TDD, Phase Structure, Documentation, Risk, Completeness)
- **Evidence-anchored** binary scoring (quote before verdict)
- **P0-P3 priority classification** for every FAIL item
- **Weighted overall score** with grade thresholds (A ≥90%, B ≥80%, C ≥65%, D ≥50%, F <50%)

### Verdicts

| Verdict | Condition | Action |
|---------|-----------|--------|
| **PASS** | 0 P0 + 0 P1 + score ≥80% | Deliver plan to user |
| **CONDITIONAL PASS** | 0 P0 + 0 P1 + score 65-79% | Deliver with P2/P3 notes |
| **FAIL** | P0 or P1 remain | Trigger @plan-improver → re-evaluate (max 3 iterations) |
| **PLATEAU** | Score improves <3% or same issues persist | Stop early, explain |

### Iteration Policy

- Max 3 evaluate → improve iterations
- Each iteration: parallel multi-review → consensus synthesis → @plan-improver fixes P0/P1 → regression check
- Regression rule: fixes must not break previously passing items

### Multi-Reviewer Context (omb-plan Step 3)

When `omb-plan` runs its evaluation loop, Step 3 spawns multiple reviewers **in parallel**:
- @plan-evaluator (quantitative rubric scoring — always included)
- @core-critique (architectural pre-mortem — always included)
- Domain-specific reviewers (based on plan content keywords — see Reviewer Delegation Table in `omb-plan` SKILL.md)

Consensus synthesis (Step 3.5) merges reviewer findings with evaluation tickets. Combined P0/P1 counts from **both** consensus-derived (CP-P{N}-{NNN}) and evaluation-derived (EP-P{N}-{NNN}) tickets determine the verdict. See `.claude/rules/workflow/09-ticket-schema.md` for canonical ticket format.

Priority mapping: Majority (>50%) = P0, Strong minority (33-50%) = P1, Minority (<33%) = P2, Single voice = P3.
Veto power: @core-critique BLOCKING = min P1, @security-audit BLOCKING = min P1.

## Manual Pre-mortem (Complementary)

Before approving any plan, conduct a pre-mortem:

1. **Assume the plan has failed** — what went wrong?
2. **Identify the top 3 most likely failure modes**
3. **Add mitigations** for each to the Risks section (Section 8)

## Assumption Verification

- List every assumption explicitly
- Mark each as VERIFIED (with evidence) or UNVERIFIED
- Unverified assumptions with high impact MUST be flagged in Section 8 (사용자 확인 필요 사항)

## Severity Levels (Manual Review)

### BLOCKING — Must fix before implementation starts
- Missing dependencies between tasks
- Undefined deliverables
- No verification criteria
- Circular dependencies in task graph
- Invalid @agent or Skill() references

### WARNING — Should fix, may proceed with justification
- Missing rollback strategy
- No parallelization identified
- Single point of failure in architecture
- Missing error handling strategy

### NOTE — Nice to fix, non-blocking
- Naming inconsistencies
- Minor documentation gaps
- Style suggestions

## Review Output Format

For manual reviews, use:

```
STATUS: APPROVED | BLOCKED | NEEDS-REVISION
BLOCKING: [count]
WARNINGS: [count]
NOTES: [count]
Summary: [1-2 sentences]
```

For automated reviews, the @plan-evaluator produces:

```
Score: XX% (Grade X)
P0: [count] | P1: [count] | P2: [count] | P3: [count]
Verdict: PASS | CONDITIONAL PASS | FAIL
```
