---
title: Break Complex Tasks into Sequential Steps
impact: HIGH
impactDescription: Improves task completion reliability
tags: sequential, steps, decomposition
---

## Break Complex Tasks into Sequential Steps

Claude follows numbered sequential steps reliably. For multi-part tasks, break them into explicit ordered steps. This prevents skipping steps or conflating instructions.

**Incorrect (multiple tasks conflated into one sentence):**

```text
Set up the project with linting, testing, CI/CD, and deploy it.
```

**Correct (explicit numbered steps):**

```text
Set up the project:
1. Initialize the repository with package.json
2. Configure ESLint with the TypeScript strict preset
3. Add vitest with a sample test
4. Create a GitHub Actions workflow for CI
5. Deploy to Vercel with preview URLs enabled
```
