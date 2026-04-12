---
title: Tool Usage Evaluation
dimension: Tool Usage
weight: 10%
items: 5
---

# Tool Usage Evaluation Checklist

## N/A Condition

If the prompt does not involve tools or agent behavior, mark ALL items in this dimension as N/A.

## Scoring Protocol

For each item: (1) search the prompt for the observable markers, (2) quote the evidence found, (3) render PASS/FAIL verdict.

| # | Item ID | Criterion | PASS when | FAIL when | Evidence Required | Observable Markers | Priority |
|---|---------|-----------|-----------|-----------|-----------------|-------------------|----------|
| 1 | tool.usage-conditions | Tool usage conditions stated | Each tool's when/how/why is defined | "Use tools as needed" or no guidance | Quote tool instructions or state "blanket permission" | PASS: "Use Read for files, Grep for search" / FAIL: "Use tools as needed" | P1 |
| 2 | tool.parallel-calls | Independent calls parallelize | Explicit parallel instruction for independent ops | Sequential instruction for independent calls | Quote parallel instruction or state "none" | PASS: "Read all 3 files in parallel" / FAIL: no parallel guidance | P2 |
| 3 | tool.error-behavior | Failure behavior defined | Retry, fallback, or escalation path specified | No guidance on tool failure | Quote error handling instruction | PASS: "If command fails, diagnose and retry" / FAIL: no error path | P2 |
| 4 | tool.action-mode | Action mode specified | Clear act-first vs ask-first guidance | No autonomy guidance | Quote the autonomy instruction | PASS: "Implement directly" or "Ask before editing" / FAIL: no guidance | P1 |
| 5 | tool.state-tracking | State persistence defined | Progress files, checkpoints, or state management | Long task with no state persistence | Quote state management instruction or state "none" | PASS: "Save progress to state.json" / FAIL: long task, no checkpoints | P2 |
