---
title: Structure Evaluation
dimension: Structure
weight: 12%
items: 5
---

# Structure Evaluation Checklist

## Scoring Protocol

For each item: (1) search the prompt for the observable markers, (2) quote the evidence found, (3) render PASS/FAIL verdict.

| # | Item ID | Criterion | PASS when | FAIL when | Evidence Required | Observable Markers | Priority |
|---|---------|-----------|-----------|-----------|-----------------|-------------------|----------|
| 1 | structure.xml-tags | XML tags used for content boundaries | Distinct content types wrapped in descriptive tags | Mixed content without clear boundaries | List tags found or state "no XML tags used" | PASS: `<role>`, `<task>`, `<rules>` / FAIL: plain text with no delimiters | P1 |
| 2 | structure.ordering | Components follow recommended ordering | Role/context before task before format | Task or format appears before role/context | State the order of components found | PASS: role→context→task→rules→format / FAIL: task before role | P2 |
| 3 | structure.separation | Role, task, rules, format separated | Each concern has its own section | Identity, task, constraints mixed in single block | Quote where concerns are mixed or list separate sections | PASS: distinct sections / FAIL: "You are X. Do Y. Never Z." in one paragraph | P1 |
| 4 | structure.hierarchy | Nested tags for complex structures | Parent-child relationships use nested tags | Flat structure for hierarchical content | Quote the flat structure or the nested pattern | PASS: `<examples><example>` / FAIL: flat list for nested data | P3 |
| 5 | structure.consistent-naming | Tag names are consistent | Same naming convention throughout | Mixed naming styles or inconsistent tags | List inconsistent tag names found | PASS: all snake_case / FAIL: `<system_prompt>` + `<outputFormat>` mixed | P3 |
