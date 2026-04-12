---
title: Tune Claude's Verbosity Level
impact: MEDIUM
impactDescription: Reduces unnecessary output
tags: verbosity, conciseness, tuning, claude-4-6, markdown, latex
---

## Tune Claude's Verbosity Level

Claude 4.6 models are significantly more concise than previous versions: more direct, more conversational, and may skip summaries after tool calls. If you need more visibility, ask explicitly. If Claude is still too verbose, use XML wrappers for persistent formatting control. Tell Claude what to produce, not what to avoid.

**Claude 4.6 behavior changes:**
- More direct and grounded (fact-based, not self-celebratory)
- May skip verbal summaries after tool calls
- Defaults to LaTeX for mathematical expressions

**Incorrect (negative instruction):**

```text
Don't be too verbose.
```

**Correct (positive instruction for desired style):**

```text
Respond with only the changed code. No explanations, no summaries,
no commentary. If you need to explain a non-obvious choice, add a
single inline comment.
```

**To get summaries back (if Claude skips them):**

```text
After completing a task that involves tool use, provide a quick
summary of the work you've done.
```

**To suppress LaTeX (Claude 4.6 defaults to LaTeX for math):**

```text
Format your response in plain text only. Do not use LaTeX, MathJax,
or markup notation such as \( \), $, or \frac{}{}. Write all math
using standard text characters (/ for division, * for multiplication,
^ for exponents).
```

**To control markdown aggressively:**

```xml
<avoid_excessive_markdown_and_bullet_points>
Write in clear, flowing prose using complete paragraphs. Reserve
markdown for inline code, code blocks, and simple headings. Do NOT
use ordered or unordered lists unless presenting truly discrete items
or the user explicitly requests a list.
</avoid_excessive_markdown_and_bullet_points>
```

Reference: [Anthropic Prompting Best Practices — Verbosity](https://platform.claude.com/docs/en/docs/build-with-claude/prompt-engineering/claude-prompting-best-practices)
