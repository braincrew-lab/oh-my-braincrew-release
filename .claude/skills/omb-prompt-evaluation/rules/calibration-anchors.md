---
title: Calibration Anchors
description: Reference prompts for scoring calibration — use to benchmark borderline verdicts
---

# Calibration Anchors

Use these 3 reference prompts to calibrate your scoring. When a verdict is borderline, compare the prompt under evaluation against these anchors.

## Anchor A: Low Quality (~30% score)

```text
Help me with my code. Make it better. Use best practices.
```

**Expected score:** ~30%
**Why:** No task objective (P0), no role, no format, no examples, no safety, vague constraints. Only passes clarity.actionable marginally.

**Key failures:** clarity.task-objective, clarity.specificity, role.identity-defined, output.format-defined, safety.boundaries

---

## Anchor B: Medium Quality (~65% score)

```text
You are a code reviewer. Review the following Python file for bugs,
security issues, and style problems.

Rules:
- Focus on correctness first, style second
- Flag any SQL injection or XSS vulnerabilities
- Use severity levels: CRITICAL, WARNING, INFO

<code>
{{CODE}}
</code>

Return your review as a numbered list of findings.
```

**Expected score:** ~65%
**Why:** Has role, task, some structure, format spec. Missing: examples, thinking guidance, XML tag separation, specific expertise, length constraints, behavioral boundaries.

**Key passes:** clarity.task-objective, role.identity-defined, output.format-defined, safety.boundaries
**Key failures:** examples.present, structure.xml-tags, role.specific-expertise, reasoning.verification

---

## Anchor C: High Quality (~90% score)

```xml
<system_prompt>
You are a senior security engineer with 10+ years specializing in
Python web application security (OWASP Top 10, SQLAlchemy, FastAPI).
</system_prompt>

<task>
Review the provided Python code for security vulnerabilities.
Produce a structured security audit report.
</task>

<rules>
- MUST check for: SQL injection, XSS, CSRF, auth bypass, secrets in code
- MUST NOT: modify the code, suggest unrelated refactoring
- If you find a CRITICAL vulnerability, flag it prominently at the top
- Before reporting, verify each finding by reading the relevant code path
- Severity levels: CRITICAL (exploitable now), HIGH (exploitable with effort), MEDIUM (defense-in-depth), LOW (best practice)
</rules>

<examples>
<example>
Input: `query = f"SELECT * FROM users WHERE id = {user_id}"`
Output:
- **CRITICAL** SQL Injection at line 42
  - Risk: Arbitrary SQL execution via user_id parameter
  - Fix: Use parameterized query `session.execute(text("SELECT * FROM users WHERE id = :id"), {"id": user_id})`
</example>
</examples>

<format>
## Security Audit Report

**Summary:** 1-2 sentences with total finding count by severity

**Findings:** (ordered by severity)
- [SEVERITY] Title at file:line
  - Risk: What can go wrong
  - Evidence: Quote the vulnerable code
  - Fix: Specific remediation with code example

**Verdict:** PASS (0 CRITICAL, 0 HIGH) | FAIL (otherwise)
</format>
```

**Expected score:** ~90%
**Why:** Strong role with specific expertise, XML structure, examples, verification step, format spec with schema, safety boundaries, severity calibration. Minor gaps: no edge-case example, no length constraint, no multi-window guidance (not needed here).

**Key passes:** All P0 and P1 items, most P2 items
**Key failures:** examples.edge-cases (only one example), output.length-specified (no word count)

---

## How to Use Anchors

1. **Before scoring:** Read all 3 anchors to calibrate your internal threshold
2. **Borderline verdicts:** If unsure between PASS and FAIL, compare the item against the same item in the nearest anchor
3. **Score sanity check:** After scoring, verify the overall score is in the right ballpark relative to anchors
