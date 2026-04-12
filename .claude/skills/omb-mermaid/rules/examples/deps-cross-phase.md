---
title: "Example: Cross-Phase Dependency Graph"
diagram-type: graph LR
complexity: high
nodes: 22
---

## Context

Produce this diagram when a plan has multiple phases and you need to show not just ordering within a phase but the dependencies *between* phases. A Gantt chart is the right tool for within-phase ordering, but it does not communicate inter-phase relationships well — a `graph LR` with subgraphs makes inter-phase edges explicit and shows which phases can run in parallel.

This diagram sits at a higher level of abstraction than a per-phase Gantt. Each node represents an entire phase or a major deliverable within a phase, not an individual task. Readers use it to understand the project's critical path and to identify where parallel tracks are possible before drilling into per-phase Gantt charts.

Trigger conditions:

- A multi-phase implementation plan where some later phases depend on specific earlier phases but others can run in parallel.
- A design document that needs to show the total ordering of work across a large refactor.
- A project kickoff where engineers need to see the full dependency graph before phase assignments are made.
- Identifying which phases share no dependencies and can be assigned to separate teams.

## Diagram

```mermaid
%% Title: Cross-Phase Implementation Dependencies
graph LR
    subgraph "Phase 0: Handler Modularization"
        P0_SECRET["SecretHandler<br/>(secret_handler.py)"]
        P0_TOOLS["ToolHandler<br/>(tool_handler.py)"]
        P0_MODEL["ModelHandler<br/>(model_handler.py)"]
        P0_MWS["MiddlewareHandler<br/>(middleware_handler.py)"]
        P0_SKILL["SkillHandler<br/>(skill_handler.py)"]
        P0_RESOLVER["AssetResolver<br/>(resolver.py)"]
        P0_DB["Checkpointer DB<br/>(migrations)"]

        P0_SECRET --> P0_TOOLS & P0_MODEL & P0_MWS & P0_SKILL
        P0_TOOLS & P0_MODEL & P0_MWS & P0_SKILL --> P0_RESOLVER
    end

    subgraph "Phase 1: API / Runtime / Permission Separation"
        P1_API["API Server split<br/>(main_api.py)"]
        P1_RUNTIME["Runtime Server split<br/>(main_executor.py)"]
        P1_PERM["Permission Server split<br/>(main_permission.py)"]
    end

    subgraph "Phase 2: Observability (parallel with Phase 1)"
        P2_TRACE["TraceCallback protocol<br/>(trace_callback.py)"]
        P2_LF["LangfuseTraceCallback<br/>(langfuse_handler.py)"]
        P2_NOOP["NoopTraceCallback<br/>(noop.py)"]

        P2_TRACE --> P2_LF & P2_NOOP
    end

    subgraph "Phase 3: Auth / Session Control Plane"
        P3_AUTH["Auth middleware<br/>(auth.py)"]
        P3_SESSION["Session management<br/>(session.py)"]
    end

    subgraph "Phase 4: Workspace / Permission Distribution"
        P4_WS["Workspace distribution<br/>(workspace.py)"]
        P4_MAT["Permission materialization<br/>(materialization.py)"]
    end

    subgraph "Phase 5: Sub-Agent Config"
        P5_CFG["Sub-agent config resolver<br/>(sub_agent_config.py)"]
    end

    subgraph "Phase 6: Review"
        P6_REV["Integration review<br/>and sign-off"]
    end

    P0_RESOLVER ==>|"AssetResolver complete"| P1_API
    P0_RESOLVER ==>|"AssetResolver complete"| P1_RUNTIME
    P0_RESOLVER ==>|"AssetResolver complete"| P1_PERM
    P0_DB -.->|"parallel possible"| P1_RUNTIME

    P0_RESOLVER -.->|"parallel possible"| P2_TRACE

    P1_API ==>|"auth boundary defined"| P3_AUTH
    P1_PERM ==>|"permission API stable"| P3_AUTH

    P1_PERM ==>|"permission API stable"| P4_WS
    P3_SESSION -.->|"parallel possible"| P4_MAT

    P1_RUNTIME ==>|"runtime stable"| P5_CFG
    P4_MAT ==>|"materialization ready"| P5_CFG

    P1_API & P1_RUNTIME & P1_PERM & P2_LF & P3_AUTH & P3_SESSION & P4_WS & P4_MAT & P5_CFG ==>|"all phases complete"| P6_REV

    classDef phase0 fill:#e3f2fd,stroke:#1565c0
    classDef phase1 fill:#e8f5e9,stroke:#2e7d32
    classDef phase2 fill:#f3e5f5,stroke:#7b1fa2
    classDef phase3 fill:#fff3e0,stroke:#ef6c00
    classDef phase4 fill:#fce4ec,stroke:#c62828
    classDef phase5 fill:#e0f7fa,stroke:#00695c
    classDef review fill:#fff9c4,stroke:#f9a825
    class P0_SECRET,P0_TOOLS,P0_MODEL,P0_MWS,P0_SKILL,P0_RESOLVER,P0_DB phase0
    class P1_API,P1_RUNTIME,P1_PERM phase1
    class P2_TRACE,P2_LF,P2_NOOP phase2
    class P3_AUTH,P3_SESSION phase3
    class P4_WS,P4_MAT phase4
    class P5_CFG phase5
    class P6_REV review
```

## Annotations

**`graph LR` for a dependency chain that flows left to right.** Left-to-right layout is the natural reading direction for a dependency chain: foundations on the left, integration on the right, review at the far right. `graph TB` would stack the phases vertically, which makes the parallel tracks (Phase 1 + Phase 2) harder to see at a glance.

**Solid `==>` for strict dependencies, dashed `-.->` for parallel-possible edges.** The thick arrows (`==>`) mean "this phase cannot start until the source phase is complete." The dashed arrows (`-.->`) mean "this phase can start before the source completes, but they share a dependency — coordinate to avoid conflicts." The distinction is load-bearing: misreading a dashed arrow as a strict dependency would serialize work that can be done in parallel.

**Arrow labels name the specific deliverable that unlocks the next phase.** Each cross-phase edge label states exactly what artifact or condition gates the dependency: `"AssetResolver complete"`, `"permission API stable"`, `"auth boundary defined"`. Vague labels like `"depends on"` or `"after"` require the reader to infer the gating condition from context.

**Per-phase color coding.** Each subgraph's nodes share a distinct fill color. This makes subgraph membership legible even when cross-phase edges visually cross subgraph boundaries — a reader can trace a cross-phase edge to its source phase by color without reading node labels.

**Intra-phase edges inside subgraphs.** Phase 0 and Phase 2 show intra-phase dependencies (`P0_SECRET --> P0_TOOLS`, `P2_TRACE --> P2_LF & P2_NOOP`) directly inside their subgraph blocks. These are not duplicating the per-phase Gantt charts — they are showing only the within-phase dependencies that are relevant to understanding cross-phase blocking. A reader who needs full within-phase detail should consult the corresponding Gantt chart.

**Fan-in edge to Phase 6.** The final review node receives edges from every preceding phase using a single compound fan-in declaration (`P1_API & P1_RUNTIME & ... & P5_CFG ==>|"all phases complete"| P6_REV`). This communicates that review is gated on the entire system being complete, not just one phase.
