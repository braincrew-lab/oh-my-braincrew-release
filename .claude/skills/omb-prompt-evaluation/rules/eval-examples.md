---
title: Examples Evaluation
dimension: Examples
weight: 10%
items: 5
---

# Examples Evaluation Checklist

## Scoring Protocol

For each item: (1) search the prompt for the observable markers, (2) quote the evidence found, (3) render PASS/FAIL verdict.

| # | Item ID | Criterion | PASS when | FAIL when | Evidence Required | Observable Markers | Priority |
|---|---------|-----------|-----------|-----------|-----------------|-------------------|----------|
| 1 | examples.present | At least one example provided | One or more input-output examples | Zero examples | Count examples found or state "0 examples" | PASS: `Input: ... → Output: ...` pair / FAIL: no examples | P2 |
| 2 | examples.tagged | Examples wrapped in tags | Examples in `<example>` tags, separated from instructions | Examples mixed into instruction text | Quote the tag wrapper or state "examples inline" | PASS: `<examples><example>` / FAIL: "for instance, ..." in prose | P3 |
| 3 | examples.good-bad | Good and bad examples contrasted | Both correct and incorrect examples with explanations | Only positive or only negative examples | State which types present (good only / bad only / both) | PASS: "Correct: ..." + "Incorrect: ..." / FAIL: only good examples | P2 |
| 4 | examples.edge-cases | Edge cases covered | At least one non-happy-path example | Only happy-path examples | Quote the edge case or state "happy-path only" | PASS: empty input, error case, boundary / FAIL: only standard inputs | P3 |
| 5 | examples.format-demo | Output format demonstrated by example | Concrete example of exact expected output shape | Format only described in words | Quote the format example or the description-only text | PASS: actual JSON/text output shape / FAIL: "Return as JSON with..." | P2 |
