---
title: Include Relevant Conversation History
impact: MEDIUM
impactDescription: Maintains coherence in multi-turn workflows
tags: history, conversation, continuity
---

## Include Relevant Conversation History

When resuming a task or providing follow-up context, include a summary of relevant prior conversation. For long conversations, summarize rather than including the full transcript. If using injected context reminders, place them in user turns rather than assistant turns.

**Incorrect (no context about prior work):**

```text
Continue where we left off.
```

**Correct (summarized prior context with clear resume point):**

```text
In our previous conversation, we:
1. Designed the user authentication schema (3 tables)
2. Implemented the login endpoint
3. Got stuck on token refresh — the issue was race conditions
   in concurrent refresh requests

Continue from step 3: implement the token refresh with proper
locking.
```
