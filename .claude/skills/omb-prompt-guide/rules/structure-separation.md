---
title: Separate Role, Task, Rules, and Format
impact: HIGH
impactDescription: Reduces instruction blending
tags: separation, concerns, clarity
---

## Separate Role, Task, Rules, and Format

Do not mix identity, instructions, constraints, and output format in the same block. Each concern gets its own section. This prevents Claude from confusing a constraint with a task step or a format requirement with a rule.

**Incorrect (what's wrong):**

```text
You are a code reviewer who should output markdown and never approve
code with security issues. Review this code and list the bugs.
```

**Correct (what's right):**

```text
<system_prompt>You are a senior code reviewer.</system_prompt>
<task>Review this code for bugs and security issues.</task>
<rules>
- Never approve code with unpatched security vulnerabilities
- Flag all SQL injection risks as CRITICAL
</rules>
<format>List findings as markdown with severity labels.</format>
```
