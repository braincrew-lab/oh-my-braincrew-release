---
name: omb-orch-security
description: "Security domain end-to-end orchestration. audit → implement → review."
user-invocable: true
argument-hint: "[task description]"
---

# Security Domain Workflow

You (main session) orchestrate by spawning sub-agents in sequence using the Agent() tool.

Sub-agents CANNOT spawn other sub-agents. Only you (the main session) can orchestrate.

## Tech Context

OWASP Top 10, authentication, authorization, secrets management, input validation, CSP, CORS, rate limiting, encryption, dependency auditing

## Steps

1. **Audit** — Spawn @security-audit with the task description
   - Wait for result envelope
   - Expect: `<omb>DONE</omb>`
   - On `<omb>BLOCKED</omb>`: surface to user
   - The auditor will identify vulnerabilities, misconfigurations, and security gaps
   - Produces a prioritized findings list with severity ratings

2. **Implement** — Spawn @security-implement with the audit findings
   - Wait for result envelope
   - Expect: `<omb>DONE</omb>`
   - The implementer will apply security fixes, add validation, configure auth, and harden configurations
   - On `<omb>BLOCKED</omb>` (e.g., needs architectural changes): surface to user

3. **Review** — Spawn @code-review to validate the security implementation
   - On `<omb>DONE</omb>` (verdict: APPROVE): workflow complete
   - On `<omb>RETRY</omb>` (verdict: REJECT): spawn @code-debug with failure details, then retry step 2 (max 3 retries)
   - Review focuses on: no regressions, fixes correctly applied, no new vulnerabilities introduced

## Retry Policy

- Implement retries: max 3 (after review `<omb>RETRY</omb>`, with code-debug between)
- After max retries exceeded: ask the user for guidance

## Context Passing

Pass the previous agent's result summary to the next agent. Include:
- The original task description
- Audit findings with severity and location
- Remediation recommendations from the audit
- Changed files list from implement (for review)
- Any constraints or trade-offs noted
