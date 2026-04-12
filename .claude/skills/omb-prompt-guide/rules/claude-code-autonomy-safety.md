---
title: Balance Autonomy and Safety
impact: MEDIUM
impactDescription: Prevents irreversible damage in agentic coding
tags: claude-code, autonomy, safety, reversibility, destructive-actions
---

## Balance Autonomy and Safety

Without guidance, Claude Opus 4.6 may take hard-to-reverse actions: deleting files, force-pushing, posting to external services. Use a reversibility framework to calibrate autonomy. Local, reversible actions (edits, tests) can proceed freely. Shared or destructive actions need confirmation.

**Incorrect (no autonomy guidance — Claude guesses):**

```text
Fix all the issues in this codebase.
```

**Correct (reversibility framework):**

```text
Consider the reversibility and potential impact of your actions.

FREELY proceed with:
- Editing local files
- Running tests and linters
- Reading files and exploring code
- Creating local branches

ASK BEFORE:
- Destructive operations (delete files/branches, rm -rf)
- Hard-to-reverse operations (git push --force, git reset --hard)
- Actions visible to others (push code, comment on PRs, send messages)

When encountering obstacles, do not use destructive actions as a
shortcut. Don't bypass safety checks (e.g. --no-verify) or discard
unfamiliar files that may be in-progress work.
```

**Overeagerness control (Claude 4.6 specific):**

```text
Avoid over-engineering. Only make changes that are directly requested.
- Don't add features beyond what was asked
- Don't refactor unrelated code
- Don't add docstrings to code you didn't change
- Don't add error handling for impossible scenarios
```

Reference: [Claude Code Best Practices — Autonomy and Safety](https://code.claude.com/docs/en/best-practices)
