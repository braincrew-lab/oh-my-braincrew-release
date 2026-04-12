---
title: Provide Context Before Instructions
impact: CRITICAL
impactDescription: Up to 30% quality improvement on complex inputs
tags: context, ordering, comprehension
---

## Provide Context Before Instructions

Place all relevant context, documents, and background information before your instructions. Claude processes sequentially; context placed after the task may be under-weighted. For multi-document inputs, use XML tags to structure each document.

**Incorrect (what's wrong):**

```text
Summarize the key risks.

<document>... 50 pages ...</document>
```

**Correct (what's right):**

```text
<document>... 50 pages ...</document>

Summarize the key risks from the document above, focusing on financial and regulatory concerns.
```
