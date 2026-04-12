---
title: Role Evaluation
dimension: Role
weight: 10%
items: 4
---

# Role Evaluation Checklist

## Scoring Protocol

For each item: (1) search the prompt for the observable markers, (2) quote the evidence found, (3) render PASS/FAIL verdict.

| # | Item ID | Criterion | PASS when | FAIL when | Evidence Required | Observable Markers | Priority |
|---|---------|-----------|-----------|-----------|-----------------|-------------------|----------|
| 1 | role.identity-defined | Role or identity established | Explicit role with domain and expertise | No role definition, using default behavior | Quote the role definition or state "no role found" | PASS: "You are a senior Python engineer" / FAIL: no identity statement | P0 |
| 2 | role.specific-expertise | Expertise is specific, not generic | Names domain, years, or specialization | Generic "helpful assistant" or similar | Quote the expertise description | PASS: "specializing in distributed systems" / FAIL: "helpful AI assistant" | P1 |
| 3 | role.system-user-separation | WHO and WHAT properly separated | System prompt = identity, user prompt = task | Task instructions in system prompt or role in user prompt | State where role and task are placed | PASS: role in system, task in user / FAIL: all in one prompt | P2 |
| 4 | role.behavioral-boundaries | Behavioral limits defined | What the role should and should not do | No behavioral guidance beyond identity | Quote boundary rules or state "no boundaries found" | PASS: "Do not provide medical advice" / FAIL: role with no constraints | P3 |
