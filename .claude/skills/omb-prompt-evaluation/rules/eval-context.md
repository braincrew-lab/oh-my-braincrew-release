---
title: Context Management Evaluation
dimension: Context Management
weight: 8%
items: 4
---

# Context Management Evaluation Checklist

## N/A Conditions

- Single-turn with no documents → N/A for context.placement, context.grounding
- Not multi-window → N/A for context.multi-window
- No prior context → N/A for context.history

## Scoring Protocol

For each item: (1) search the prompt for the observable markers, (2) quote the evidence found, (3) render PASS/FAIL verdict.

| # | Item ID | Criterion | PASS when | FAIL when | Evidence Required | Observable Markers | Priority |
|---|---------|-----------|-----------|-----------|-----------------|-------------------|----------|
| 1 | context.placement | Documents before instructions | Documents/data appear before the query | Instructions first, documents appended at end | State document and instruction positions | PASS: docs top, query bottom / FAIL: query first, data appended | P2 |
| 2 | context.grounding | Grounding for large inputs | Quoting, citation, or extract-then-analyze used | Direct analysis without grounding | Quote grounding instruction or state "none" | PASS: "Quote relevant sections first" / FAIL: "Analyze the doc" | P2 |
| 3 | context.multi-window | Multi-window persistence | Progress saving and state recovery included | Long task with no persistence guidance | Quote persistence instruction or state "none" | PASS: "Save progress to progress.md" / FAIL: no recovery plan | P3 |
| 4 | context.history | Prior context summarized | Prior conversation summarized for continuity | "Continue where we left off" with no context | Quote summary or the bare continuation | PASS: "Previously we completed X" / FAIL: "Continue" with no context | P3 |
