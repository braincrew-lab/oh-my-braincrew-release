---
title: Clarity Evaluation
dimension: Clarity
weight: 15%
items: 6
---

# Clarity Evaluation Checklist

## Scoring Protocol

For each item: (1) search the prompt for the observable markers, (2) quote the evidence found, (3) render PASS/FAIL verdict.

| # | Item ID | Criterion | PASS when | FAIL when | Evidence Required | Observable Markers | Priority |
|---|---------|-----------|-----------|-----------|-----------------|-------------------|----------|
| 1 | clarity.task-objective | Task objective explicitly stated | Single clear statement of what to produce | No discernible objective; must guess intent | Quote the objective sentence or state "no objective found" | PASS: "Your task is to...", "Generate a...", "Analyze..." / FAIL: no task sentence | P0 |
| 2 | clarity.specificity | Constraints use concrete values | All limits use specific numbers/values | Uses vague qualifiers ("short", "brief", "few") without numbers | Quote each vague qualifier OR each concrete value | PASS: "max 3 sentences", "under 200 words" / FAIL: "keep it short", "be brief" | P1 |
| 3 | clarity.unambiguous | Instructions use unambiguous language | No hedging qualifiers ("might", "could", "maybe", "try to") | Contains ambiguous instructions open to interpretation | Quote the ambiguous phrase and explain two possible readings | PASS: "Always validate input" / FAIL: "You might want to validate input" | P1 |
| 4 | clarity.no-conflicts | No contradictory instructions | All instructions are internally consistent | Contains direct contradictions | Quote both contradictory statements | PASS: all rules align / FAIL: "Be concise" + "Explain in detail" without scope separation | P0 |
| 5 | clarity.defined-terms | Technical terms defined or audience specified | Jargon is defined or target audience expertise stated | Unexplained domain-specific terminology | List undefined jargon or quote the audience definition | PASS: "for junior developers" / FAIL: "Handle CQRS" (undefined) | P2 |
| 6 | clarity.actionable | Instructions are actionable, not abstract | Each instruction maps to a concrete action | Instructions are philosophical or overly abstract | Quote the abstract instruction and suggest its concrete form | PASS: "Return JSON with fields: name, age" / FAIL: "Strive for excellence" | P2 |
