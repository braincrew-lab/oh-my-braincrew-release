---
title: Safety and Guardrails Evaluation
dimension: Safety and Guardrails
weight: 13%
items: 5
---

# Safety and Guardrails Evaluation Checklist

## N/A Conditions

- Simple non-agent prompt → N/A for safety.escalation
- No sensitive data → N/A for safety.data-handling

## Scoring Protocol

For each item: (1) search the prompt for the observable markers, (2) quote the evidence found, (3) render PASS/FAIL verdict.

| # | Item ID | Criterion | PASS when | FAIL when | Evidence Required | Observable Markers | Priority |
|---|---------|-----------|-----------|-----------|-----------------|-------------------|----------|
| 1 | safety.boundaries | Explicit MUST NOT rules | Clear prohibitions for dangerous actions | No boundaries for autonomous agent | Quote boundary rules or state "none found" | PASS: "MUST NOT: delete files, push to main" / FAIL: no prohibitions | P0 |
| 2 | safety.hallucination-prevention | Investigation-before-answering | "Read/check before claiming" present | Model may speculate about unread data | Quote the investigation instruction | PASS: "Read the file before answering" / FAIL: no read-first rule | P0 |
| 3 | safety.data-handling | Sensitive data rules | Instructions for API keys, PII, credentials | Sensitive data with no handling rules | Quote data handling instruction or state "none" | PASS: "Never commit .env files" / FAIL: mentions keys, no rules | P1 |
| 4 | safety.escalation | Escalation path defined | "Ask the user when..." or "stop if..." | Autonomous agent with no escalation | Quote the escalation trigger | PASS: "Ask if unsure about..." / FAIL: agent with no ask-when | P1 |
| 5 | safety.calibrated | Safety language calibrated | Context-appropriate, not excessive | No safety OR aggressive CRITICAL/MUST overuse | Count CRITICAL/MUST/NEVER instances, assess proportion | PASS: 2-3 targeted rules / FAIL: 15+ in a short prompt | P2 |
