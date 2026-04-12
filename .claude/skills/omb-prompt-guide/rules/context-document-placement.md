---
title: Place Long Documents Before Instructions
impact: MEDIUM
impactDescription: Up to 30% quality improvement on complex inputs
tags: document-placement, ordering, long-context
---

## Place Long Documents Before Instructions

When working with large documents or data, place them at the top of the prompt before your query and instructions. Use XML tags to wrap each document with metadata (source, index). End with your question or task. This ordering significantly improves retrieval accuracy.

**Incorrect (instructions before document):**

```text
Summarize the key risks and compliance issues.

<document>... 200 pages ...</document>
```

**Correct (document first, then instructions):**

```text
<documents>
<document index="1">
<source>annual_report_2024.pdf</source>
<document_content>{{REPORT}}</document_content>
</document>
</documents>

Summarize the key risks and compliance issues from the report above.
```
