---
title: Ask Claude to Verify Its Own Output
impact: MEDIUM-HIGH
impactDescription: Catches errors before final output
tags: self-check, verification, quality
---

## Ask Claude to Verify Its Own Output

Adding a verification step ("Before finishing, check your answer against X criteria") reliably catches errors, especially in code and math. This is a lightweight form of chain-of-thought that focuses on output validation.

**Incorrect (no self-verification):**

```text
Generate the SQL migration for adding the users table.
```

**Correct (explicit verification checklist):**

```text
Generate the SQL migration for adding the users table.

Before finalizing, verify:
- All columns have appropriate types and constraints
- Foreign keys reference existing tables
- The migration is reversible (include DOWN migration)
- No reserved SQL keywords are used as column names
```
