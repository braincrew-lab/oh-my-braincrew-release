---
title: Give Claude a Way to Verify Its Work
impact: CRITICAL
impactDescription: Single highest-leverage practice for Claude Code quality
tags: claude-code, verification, testing, self-check
---

## Give Claude a Way to Verify Its Work

Claude performs dramatically better when it can verify its own work — run tests, compare screenshots, validate outputs. Without clear success criteria, Claude produces output that looks right but may not work, making you the only feedback loop.

Provide verification criteria alongside implementation requests: test cases, expected outputs, linting commands, or screenshot comparisons. Investment in verification tools compounds across sessions.

**Incorrect (no verification criteria):**

```text
Implement a function that validates email addresses.
```

**Correct (verification built into the request):**

```text
Write a validateEmail function. Test cases:
- user@example.com → true
- invalid → false
- user@.com → false

Run the tests after implementing. Fix any failures before reporting done.
```

**For UI changes:**

```text
[paste screenshot] Implement this design. Take a screenshot of the result
and compare it to the original. List differences and fix them.
```

**For bug fixes:**

```text
The build fails with this error: [paste error]. Fix it and verify the
build succeeds. Address the root cause, don't suppress the error.
```

Reference: [Claude Code Best Practices — Verification](https://code.claude.com/docs/en/best-practices)
