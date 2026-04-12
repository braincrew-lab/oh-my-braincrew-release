---
name: omb-orch-infra
description: "Infrastructure domain end-to-end orchestration. design → critique → implement → verify."
user-invocable: true
argument-hint: "[task description]"
---

# Infrastructure Domain Workflow

You (main session) orchestrate by spawning sub-agents in sequence using the Agent() tool.

Sub-agents CANNOT spawn other sub-agents. Only you (the main session) can orchestrate.

## Tech Context

Docker, GitHub Actions, Kubernetes, Terraform, AWS, Azure, CI/CD pipelines, networking, secrets management, monitoring

## Steps

1. **Design** — Spawn @infra-design with the task description
   - Wait for result envelope
   - Expect: `<omb>DONE</omb>`
   - On `<omb>BLOCKED</omb>`: surface to user
   - The designer will produce infrastructure topology, resource definitions, networking layout, and deployment strategy

2. **Critique** — Spawn @infra-critique with the design output
   - On `<omb>DONE</omb>` (verdict: APPROVE): proceed to step 3. If concerns are listed, note them.
   - On `<omb>RETRY</omb>` (verdict: REJECT): re-spawn @infra-design with critique feedback (max 2 retries)
   - Infra critique focuses on cost, security, scalability, and blast radius

3. **Implement** — Spawn @infra-implement with the approved design
   - Wait for result envelope
   - Expect: `<omb>DONE</omb>`
   - The implementer will create Dockerfiles, Terraform modules, CI/CD configs, and K8s manifests

4. **Verify** — Spawn @infra-verify to validate the implementation
   - On `<omb>DONE</omb>` (verdict: PASS): workflow complete
   - On `<omb>RETRY</omb>` (verdict: FAIL): spawn @code-debug with failure details, then retry step 3 (max 3 retries)

## Retry Policy

- Design retries: max 2 (after critique `<omb>RETRY</omb>`)
- Implement retries: max 3 (after verify `<omb>RETRY</omb>`, with code-debug between)
- After max retries exceeded: ask the user for guidance

## Context Passing

Pass the previous agent's result summary to the next agent. Include:
- The original task description
- Infrastructure topology and resource specifications
- Networking, security groups, and access policies
- Any concerns flagged by critique (especially cost and security)
- Changed files list from implement (for verify)
