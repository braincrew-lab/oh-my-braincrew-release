---
name: omb-orch-electron
description: "Desktop/Electron domain end-to-end orchestration. design → critique → implement → verify."
user-invocable: true
argument-hint: "[task description]"
---

# Desktop/Electron Domain Workflow

You (main session) orchestrate by spawning sub-agents in sequence using the Agent() tool.

Sub-agents CANNOT spawn other sub-agents. Only you (the main session) can orchestrate.

## Tech Context

Electron, IPC (main/renderer), preload scripts, contextBridge, BrowserWindow, native menus, auto-updater, packaging

## Steps

1. **Design** — Spawn @electron-design with the task description
   - Wait for result envelope
   - Expect: `<omb>DONE</omb>`
   - On `<omb>BLOCKED</omb>`: surface to user
   - The designer will produce process architecture, IPC channel definitions, window management strategy, and security boundaries

2. **Critique** (optional but recommended) — Spawn @core-critique with the design output
   - On `<omb>DONE</omb>` (verdict: APPROVE): proceed to step 3. If concerns are listed, note them.
   - On `<omb>RETRY</omb>` (verdict: REJECT): re-spawn @electron-design with critique feedback (max 2 retries)

3. **Implement** — Spawn @electron-implement with the approved design
   - Wait for result envelope
   - Expect: `<omb>DONE</omb>`
   - The implementer will create main process code, preload scripts, renderer logic, and IPC handlers

4. **Verify** — Spawn @electron-verify to validate the implementation
   - On `<omb>DONE</omb>` (verdict: PASS): workflow complete
   - On `<omb>RETRY</omb>` (verdict: FAIL): spawn @code-debug with failure details, then retry step 3 (max 3 retries)

## Retry Policy

- Design retries: max 2 (after critique `<omb>RETRY</omb>`)
- Implement retries: max 3 (after verify `<omb>RETRY</omb>`, with code-debug between)
- After max retries exceeded: ask the user for guidance

## Context Passing

Pass the previous agent's result summary to the next agent. Include:
- The original task description
- Process architecture (main vs renderer responsibilities)
- IPC channel definitions and security model
- Any concerns flagged by critique
- Changed files list from implement (for verify)
