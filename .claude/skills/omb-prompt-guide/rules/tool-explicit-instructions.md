---
title: Tell Claude Exactly When and How to Use Tools
impact: MEDIUM-HIGH
impactDescription: Prevents tool misuse and missed opportunities
tags: tools, instructions, explicit, suggest-vs-implement, overtriggering
---

## Tell Claude Exactly When and How to Use Tools

Claude follows literal instructions in tool-use contexts. "Can you suggest changes?" yields suggestions, not edits. "Make these changes" triggers tool calls. Be explicit about whether Claude should **act** or **advise**.

**Claude 4.6 overtriggering warning:** Opus 4.6 and Sonnet 4.6 are more responsive to tool instructions than previous models. Aggressive language like "CRITICAL: You MUST use this tool when..." will cause overtriggering. Use normal phrasing: "Use this tool when..."

**Incorrect (ambiguous intent — suggest or implement?):**

```text
Can you suggest some improvements to this function?
```

**Correct (explicit action intent):**

```text
Read the function in src/auth.py, then edit it to add input
validation for the email parameter.
```

**Action-first mode (for autonomous agents):**

```xml
<default_to_action>
By default, implement changes rather than only suggesting them.
If the user's intent is unclear, infer the most useful likely
action and proceed, using tools to discover missing details
instead of guessing.
</default_to_action>
```

**Ask-first mode (for conservative agents):**

```xml
<do_not_act_before_instructions>
Do not jump into implementation unless clearly instructed.
When intent is ambiguous, default to providing information
and recommendations rather than taking action.
</do_not_act_before_instructions>
```

**Tuning tool aggression for Claude 4.6:**
- Replace "Default to using [tool]" → "Use [tool] when it would enhance your understanding"
- Remove "If in doubt, use [tool]" — this causes overtriggering on newer models
- Use the `effort` parameter to reduce overall aggressiveness

Reference: [Anthropic Prompting Best Practices — Tool Usage](https://platform.claude.com/docs/en/docs/build-with-claude/prompt-engineering/claude-prompting-best-practices)
