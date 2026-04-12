---
title: Use Quoting and Grounding for Large Inputs
impact: MEDIUM
impactDescription: Reduces hallucination in document-heavy tasks
tags: quoting, grounding, large-documents
---

## Use Quoting and Grounding for Large Inputs

For long document analysis, ask Claude to first extract relevant quotes, then reason from those quotes. This forces grounding in the actual text and reduces hallucination. Wrap the reasoning chain: find quotes first, then analyze.

**Incorrect (direct question with no grounding):**

```text
Based on the 50-page report, what are the key financial risks?
```

**Correct (quote-then-analyze chain):**

```text
First, find and quote the specific passages from the report that
discuss financial risks. Place them in <quotes> tags. Then, based
only on those quotes, analyze the key financial risks in
<analysis> tags.
```
