---
title: Define Failure Behavior for Tool Calls
impact: MEDIUM
impactDescription: Prevents silent failures and infinite loops
tags: errors, failure, recovery
---

## Define Failure Behavior for Tool Calls

Specify what Claude should do when a tool call fails. Should it retry? Ask the user? Fall back to an alternative? Without explicit guidance, Claude may retry indefinitely or silently skip the failed operation.

**Incorrect (what's wrong):**

```text
Search for the configuration file and update it.
```

**Correct (what's right):**

```text
Search for the configuration file. If not found, check these alternative locations: ~/.config/app/, /etc/app/. If still not found, ask the user for the correct path. Do not create a new config file without confirmation.
```
