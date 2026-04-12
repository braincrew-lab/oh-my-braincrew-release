# Sections

This file defines all sections, their ordering, impact levels, and descriptions.
The section ID (in parentheses) is the filename prefix used to group rules.

---

## 1. Foundation (foundation)

**Impact:** CRITICAL
**Description:** Core rules that apply to every diagram regardless of type. Type selection decision matrix, common syntax patterns, style conventions for consistent output, and validation approaches to prevent rendering errors. Every agent creating Mermaid diagrams must follow these rules.

## 2. Structure Diagrams (structure)

**Impact:** HIGH
**Description:** Diagrams for static relationships — system architecture, component dependencies, class/module hierarchies, database schemas, and layered architectures. The most commonly used diagram category. Graph and flowchart types are the workhorses of technical documentation.

## 3. Behavior Diagrams (behavior)

**Impact:** HIGH
**Description:** Diagrams for dynamic interactions — API call sequences between services, state machine transitions, and user journey flows. Use when showing how things communicate or change over time rather than how they are structured.

## 4. Planning Diagrams (planning)

**Impact:** MEDIUM
**Description:** Diagrams for project planning — implementation phase timelines with task dependencies (Gantt), milestone timelines, and topic hierarchy brainstorming (mindmap). Use for documenting schedules, phases, and decomposing complex topics.

## 5. AI/Agent Diagrams (ai)

**Impact:** HIGH
**Description:** Specialized diagrams for LangGraph and LangChain agent workflows. Covers native `draw_mermaid()` export, manual graph composition for ReAct agents, multi-agent supervisors, and human-in-the-loop interrupt patterns. Essential for AI-domain documentation.

## 6. Architecture & Infra Diagrams (infra)

**Impact:** MEDIUM-HIGH
**Description:** Specialized infrastructure diagrams — C4 model views (context, container, component, deployment), cloud topology with service icons, and Sankey flow diagrams for data volume or cost distribution. Use for infrastructure and DevOps documentation.

## 7. Analytics & Metrics Diagrams (analytics)

**Impact:** MEDIUM
**Description:** Diagrams for data visualization — pie charts for distributions, quadrant charts for priority matrices, XY charts for metrics/latency, and requirement diagrams for compliance tracing. Use when presenting quantitative data or mapping requirements.

## 8. Advanced Diagrams (advanced)

**Impact:** LOW-MEDIUM
**Description:** Specialized niche diagrams — GitGraph for branching strategies, Kanban for task boards, and packet diagrams for protocol/binary format documentation. Use when the specific diagram type precisely matches the content being documented.

## 9. Composition (composition)

**Impact:** MEDIUM-HIGH
**Description:** Cross-cutting rules for combining and organizing diagram elements — subgraph nesting patterns, styling directives (classDef, themes), and detail level guidelines (Context/Container/Component splitting). Apply these rules on top of any diagram type when complexity requires structure.
