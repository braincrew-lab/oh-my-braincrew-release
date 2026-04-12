---
title: Reasoning Evaluation
dimension: Reasoning
weight: 10%
items: 4
---

# Reasoning Evaluation Checklist

## Scoring Protocol

For each item: (1) search the prompt for the observable markers, (2) quote the evidence found, (3) render PASS/FAIL verdict.

| # | Item ID | Criterion | PASS when | FAIL when | Evidence Required | Observable Markers | Priority |
|---|---------|-----------|-----------|-----------|-----------------|-------------------|----------|
| 1 | reasoning.thinking-guidance | Reasoning guidance for complex tasks | Explicit thinking steps, questions, or reflection instructions | Complex task with no reasoning guidance | Quote the thinking instruction or state "none" | PASS: "Think through...", "Reflect on..." / FAIL: complex task, no guidance | P2 |
| 2 | reasoning.verification | Self-check or verification step | "Before finalizing, verify X" or equivalent | No output verification step | Quote the verification instruction | PASS: "Verify against...", "Run tests after..." / FAIL: no self-check | P1 |
| 3 | reasoning.step-decomposition | Complex tasks broken into steps | Multi-part tasks use numbered sequential steps | Multi-part task as single undifferentiated instruction | Count steps or state "single block" | PASS: "1. Read... 2. Analyze... 3. Fix..." / FAIL: all in one sentence | P2 |
| 4 | reasoning.effort-matched | Effort matches task complexity | Appropriate depth for the task | Trivial task with excessive framework or complex task with no guidance | State task complexity vs prompt depth, explain mismatch | PASS: matched / FAIL: "classify email" with 500-word framework | P3 |
