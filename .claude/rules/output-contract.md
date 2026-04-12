# Output Contract

Every sub-agent MUST end its response with a `<omb>` status tag followed by a result envelope.

## Status Tags

There are exactly **3** status values, wrapped in `<omb>` XML tags:

| Status | Meaning | When to use |
|--------|---------|-------------|
| `<omb>DONE</omb>` | Task completed, proceed | Successful completion (with or without concerns) |
| `<omb>RETRY</omb>` | Task failed, retry possible | Critique rejection, verification failure |
| `<omb>BLOCKED</omb>` | Cannot proceed, needs human | Missing context, unresolvable dependency |

## Envelope Format

```
<omb>DONE</omb>

```result
verdict: <domain-specific detail>
summary: <1-3 sentence summary of what was done>
artifacts:
  - <key output paths or identifiers>
changed_files:
  - <files modified, empty list for read-only agents>
concerns:
  - <concerns if any, empty list if none>
blockers:
  - <blocking issues, empty list if none>
retryable: true | false
next_step_hint: <suggested next action>
```

## Verdict Field (optional)

The `verdict:` field preserves domain-specific language for human readability:

| Agent Type | Verdict Values |
|------------|---------------|
| critique | APPROVE, REJECT |
| verify | PASS, FAIL |
| review | APPROVE, REJECT |
| audit | PASS, FAIL |
| All others | omit or use a free-form label |

The verdict does NOT affect orchestration flow — only the `<omb>` tag does.

## Rules

- The `<omb>` tag + envelope MUST be the final block in your response.
- Use ONLY the 3 allowed status values: DONE, RETRY, BLOCKED.
- `concerns:` non-empty = completed with caveats (orchestrator proceeds but logs them).
- `retryable: true` means the orchestrator may re-run this agent with adjustments.
- `next_step_hint` helps the orchestrator decide what to spawn next.
- `changed_files` MUST be empty for read-only agents (design, critique, verify, explore).
- `artifacts` should list concrete outputs: file paths, endpoint names, schema names.
