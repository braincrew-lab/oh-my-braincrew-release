# Sections

This file defines all sections, their ordering, impact levels, and descriptions.
The section ID (in parentheses) is the filename prefix used to group rules.

---

## 1. Foundations (foundation)

**Impact:** CRITICAL
**Description:** The absolute basics every prompt must get right. Clarity, specificity, and context are the highest-leverage improvements you can make to any prompt.

## 2. Structure (structure)

**Impact:** CRITICAL
**Description:** How a prompt is organized determines how well Claude parses and follows it. XML tags and component ordering prevent misinterpretation in complex prompts.

## 3. Role & Identity (role)

**Impact:** HIGH
**Description:** Defining who Claude is sets the foundation for tone, expertise level, and behavioral boundaries. A well-defined role improves relevance and consistency.

## 4. Examples & Demonstrations (example)

**Impact:** HIGH
**Description:** Examples are the most reliable way to steer output format, tone, and structure. Few-shot prompting consistently outperforms instruction-only approaches.

## 5. Reasoning & Thinking (reasoning)

**Impact:** HIGH
**Description:** Guiding Claude's reasoning process improves accuracy on complex problems. Chain-of-thought and extended thinking can yield up to 39% quality improvement.

## 6. Output Control (output)

**Impact:** MEDIUM-HIGH
**Description:** Explicitly controlling output format, length, and structure prevents verbose or off-format responses. Tell Claude what to produce, not just what to think about.

## 7. Tool & Agent Prompting (tool)

**Impact:** MEDIUM-HIGH
**Description:** Agent and tool-use prompts require explicit instructions about when, how, and whether to use tools. Claude follows literal instructions in tool-use contexts.

## 8. Long Context & Multi-Turn (context)

**Impact:** MEDIUM
**Description:** Large documents and multi-turn conversations require careful placement and management to maintain Claude's attention and accuracy.

## 9. Safety & Guardrails (safety)

**Impact:** MEDIUM
**Description:** Guardrails prevent hallucination, overreach, and unintended behavior. Especially important for agent systems where Claude acts autonomously.

## 10. Claude Code Specific (claude-code)

**Impact:** HIGH
**Description:** Patterns specific to Claude Code as an agentic coding environment. Covers verification, CLAUDE.md authoring, context window management, subagent delegation, and autonomy/safety calibration. Based on Anthropic's official Claude Code best practices.

## 11. Context Engineering (context-eng)

**Impact:** MEDIUM-HIGH
**Description:** Designing prompts for systems that span multiple context windows or sessions. Covers multi-window workflows, structured state persistence, and token budget optimization. Critical for long-horizon autonomous tasks.
