---
title: Claude Code Evaluation
dimension: Claude Code
weight: 8%
items: 5
---

# Claude Code Evaluation Checklist

## N/A Condition

If the prompt is NOT for Claude Code (i.e., not a CLAUDE.md, agent instruction, or skill targeting agentic coding), mark ALL items as N/A.

## Scoring Protocol

For each item: (1) search the prompt for the observable markers, (2) quote the evidence found, (3) render PASS/FAIL verdict.

| # | Item ID | Criterion | PASS when | FAIL when | Evidence Required | Observable Markers | Priority |
|---|---------|-----------|-----------|-----------|-----------------|-------------------|----------|
| 1 | claude-code.verification | Verification criteria provided | Tests, screenshots, expected outputs, or linting commands specified | No way for Claude to verify its own work | Quote the verification instruction | PASS: "Run tests after implementing" / FAIL: no verification criteria | P0 |
| 2 | claude-code.claudemd-concise | CLAUDE.md content is concise and non-obvious | Only includes rules Claude can't infer from code | Contains self-evident rules or bloated instructions | Quote any self-evident rule or count total lines | PASS: <50 lines, all non-obvious / FAIL: "Write clean code", "Use TypeScript" | P1 |
| 3 | claude-code.context-management | Context management guidance present | Clear /clear, compaction, or scoping instructions | Long task with no context management guidance | Quote context guidance or state "none" | PASS: "/clear between tasks", "scope reads narrowly" / FAIL: no guidance | P1 |
| 4 | claude-code.subagent-guidance | Subagent usage guidance provided | When to use/not use subagents defined | No guidance (risks overuse on Claude 4.6) | Quote subagent guidance or state "none" | PASS: "Use subagents for research, not simple tasks" / FAIL: no guidance | P2 |
| 5 | claude-code.autonomy-calibrated | Autonomy level calibrated | Reversibility framework or act/ask guidance | No autonomy guidance for autonomous agent | Quote the autonomy/reversibility instruction | PASS: "Ask before destructive actions" / FAIL: no autonomy calibration | P2 |
