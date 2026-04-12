---
title: Control Markdown and Formatting Usage
impact: MEDIUM
impactDescription: Matches output to consumption context
tags: markdown, formatting, prose
---

## Control Markdown and Formatting Usage

Claude defaults to markdown with headers and bullet points. If the output will be read as plain text, consumed by a TTS engine, or embedded in a non-markdown context, explicitly request the format you need. Match your prompt style to the desired output style.

**Incorrect (what's wrong):**

```text
Write a summary.
```

**Correct (what's right):**

```text
Write a summary in flowing prose paragraphs. Do not use markdown headers, bullet points, or bold text. Use plain paragraph breaks for structure.
```
