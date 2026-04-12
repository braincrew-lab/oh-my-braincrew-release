---
title: Context Engineering Evaluation
dimension: Context Engineering
weight: 5%
items: 4
---

# Context Engineering Evaluation Checklist

## N/A Condition

If the prompt is for a simple single-turn task that does not span multiple context windows and does not involve large documents, mark ALL items as N/A.

## Scoring Protocol

For each item: (1) search the prompt for the observable markers, (2) quote the evidence found, (3) render PASS/FAIL verdict.

| # | Item ID | Criterion | PASS when | FAIL when | Evidence Required | Observable Markers | Priority |
|---|---------|-----------|-----------|-----------|-----------------|-------------------|----------|
| 1 | context-eng.multi-window | Multi-window workflow designed | State recovery, progress files, and resumption instructions | Long task with no cross-window persistence | Quote the persistence/recovery instructions | PASS: "Review progress.md on new window" / FAIL: long task, no state management | P1 |
| 2 | context-eng.state-persistence | Structured state files defined | JSON/markdown state files with clear schema | Relies solely on context memory for multi-session work | Quote state file definitions or state "none" | PASS: "Track in tests.json: {id, status}" / FAIL: no state files | P2 |
| 3 | context-eng.token-budget | Token efficiency guidance provided | Scoped reads, compaction guidance, or subagent delegation | Broad "read everything" instructions that waste context | Quote the scoping instruction or the wasteful one | PASS: "Read only auth-related files" / FAIL: "Read every file in src/" | P2 |
| 4 | context-eng.compaction-guidance | Compaction preservation rules | Specifies what to preserve during compaction | No compaction guidance (critical context may be lost) | Quote compaction preservation rules or state "none" | PASS: "When compacting, preserve modified files list" / FAIL: no guidance | P3 |
