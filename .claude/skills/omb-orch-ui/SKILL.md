---
name: omb-orch-ui
description: "UI/Frontend domain end-to-end orchestration. design → critique → implement → verify."
user-invocable: true
argument-hint: "[task description]"
---

# UI/Frontend Domain Workflow

You (main session) orchestrate by spawning sub-agents in sequence using the Agent() tool.

Sub-agents CANNOT spawn other sub-agents. Only you (the main session) can orchestrate.

## Tech Context

React, TypeScript, Tailwind CSS, Vite, component architecture, state management, accessibility

## Optional MCP Integrations

- **Pencil MCP** — visual design tool for .pen files. Detection: call `mcp__pencil__get_editor_state`. When active, the design step produces .pen files as the PRIMARY artifact and the orchestrator pauses for human review before proceeding.
- **Chrome MCP** — browser automation for visual verification. Detection: call `mcp__claude-in-chrome__tabs_context_mcp`. When active, the verify step includes browser-based visual checks (layout, console errors, responsive, interactions).

Both are optional. The workflow adapts automatically based on availability. Detect both at the start of orchestration and pass availability flags to downstream agents.

## Pencil Design Workflow (when Pencil MCP is active)

When Pencil MCP is detected, the UI workflow becomes **visual-first**:

```
1. Design (visual) — ui-design creates .pen file in designs/ as PRIMARY artifact
2. HUMAN REVIEW — Orchestrator pauses for user approval of the visual design
3. Critique — core-critique reviews both visual design and text spec
4. Implement — ui-implement receives .pen file path, extracts exact values via Pencil MCP
5. Verify — ui-verify checks design fidelity against .pen file + Chrome browser checks
```

.pen files are stored at `designs/YYYY-MM-DD-descriptive-name.pen` (e.g., `designs/2026-04-11-login-page.pen`).

## Quality Skills (auto-loaded by sub-agents)

- **omb-react-perf** (ui-implement, ui-verify) — 64 React performance rules. CRITICAL rules are mandatory checks.
- **omb-react-composition** (ui-design, ui-implement, ui-verify) — 8 composition patterns. Mandatory for component API design.
- **omb-ui-guidelines** (ui-design) — Web Interface Guidelines for accessibility and UX.

These are enforced at implementation time (agent has rules in context) and verified at verification time (agent checks against rules). No manual invocation needed.

## Steps

1. **Design** — Spawn @ui-design with the task description
   - If Pencil MCP is active, include in the agent prompt: "Pencil MCP is available. Create a visual design in a .pen file at `designs/YYYY-MM-DD-name.pen` as the primary artifact."
   - Wait for result envelope
   - Expect: `<omb>DONE</omb>`
   - On `<omb>BLOCKED</omb>`: surface to user
   - The designer will produce component hierarchy, props interfaces, layout structure, and interaction patterns
   - If Pencil was used, the result will include a .pen file path — do NOT proceed to critique yet, go to step 1.5

1.5. **Human Review** (when .pen file was created) — Pause for user approval
   - Present the .pen file path to the user
   - Ask: "Visual design created at `[path].pen`. Please review in Pencil. Approve to proceed, or describe changes needed."
   - On approval: proceed to step 2 (critique)
   - On change request: re-spawn @ui-design with the user's feedback (counts toward design retry limit)
   - This step is SKIPPED when Pencil was not used (proceed directly to step 2)

2. **Critique** (optional but recommended) — Spawn @core-critique with the design output
   - On `<omb>DONE</omb>` (verdict: APPROVE): proceed to step 3. If concerns are listed, note them.
   - On `<omb>RETRY</omb>` (verdict: REJECT): re-spawn @ui-design with critique feedback (max 2 retries)

3. **Implement** — Spawn @ui-implement with the approved design
   - If a .pen design file was produced in step 1, include in the agent prompt: "Reference Pencil design: `[path].pen` — extract exact layout, spacing, color values via Pencil MCP before implementing."
   - Wait for result envelope
   - Expect: `<omb>DONE</omb>`
   - The implementer will create components, styles, hooks, and state logic

4. **Verify** — Spawn @ui-verify to validate the implementation
   - The verifier checks against React perf rules (omb-react-perf) and composition patterns (omb-react-composition) in addition to tsc/eslint/vitest
   - If Chrome MCP is available, include in the agent prompt: "Chrome MCP is available. Run browser-based visual checks after CLI checks."
   - If a .pen design file exists, include: "Check design fidelity against `[path].pen`"
   - Browser check results use SKIPPED (not FAIL) when Chrome is unavailable
   - On `<omb>DONE</omb>` (verdict: PASS): workflow complete
   - On `<omb>RETRY</omb>` (verdict: FAIL): spawn @code-debug with failure details, then retry step 3 (max 3 retries)

## Retry Policy

- Design retries: max 2 (after critique `<omb>RETRY</omb>`)
- Implement retries: max 3 (after verify `<omb>RETRY</omb>`, with code-debug between)
- After max retries exceeded: ask the user for guidance

## Context Passing

Pass the previous agent's result summary to the next agent. Include:
- The original task description
- Component tree, props interfaces, and layout decisions
- Styling approach and responsive breakpoints
- Any concerns flagged by critique
- Changed files list from implement (for verify)
- .pen design file path (if created by ui-design in step 1)
- Pencil MCP availability (detected at orchestration start)
- Chrome MCP availability (detected at orchestration start)
- Dev server URL for Chrome verification (default: http://localhost:3000)
