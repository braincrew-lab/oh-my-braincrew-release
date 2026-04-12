---
title: "Example: Full System Architecture"
diagram-type: graph TB
complexity: high
nodes: 28
---

## Context

Produce this diagram when you need a single authoritative view of every service, database, and traffic path in a deployed system. It belongs in the top-level architecture document (e.g., `docs/architecture/README.md` or an ADR) and is the first diagram a new engineer should read. Because it contains every major subsystem in one view, it deliberately trades implementation detail for breadth — individual services get their own diagrams at lower levels of the composition hierarchy (see `composition-detail-levels.md`).

Trigger conditions:

- A new engineer asks "how does the whole system fit together?"
- You are writing the architecture section of a design document.
- You need to show traffic paths across all service boundaries simultaneously.
- You are documenting an existing system before a refactor so reviewers can see the before state.

## Diagram

```mermaid
%% Title: Full System Architecture
graph TB
    subgraph "Client"
        FE["Frontend :3000"]
        ADMIN["Admin :3001"]
    end

    subgraph "Nginx (path-based routing)"
        NG["Reverse Proxy"]
    end

    subgraph "API Server :8000 (main_api.py)"
        direction TB
        API_AUTH["Auth / Token Exchange<br/>(control-plane)"]
        API_WS["Workspace Context / Membership<br/>(control-plane)"]
        API_CRUD["CRUD / Agent / Asset Metadata APIs"]
        API_THREAD["Thread Router<br/>(read-only checkpointer)"]
    end

    subgraph "Permission Server :8200 (main_permission.py)"
        direction TB
        PERM_API["Permission / Materialization API"]
        PERM_GATE["Policy Engine + Admin Override Engine"]
        PERM_AUDIT["Audit / Forced Action Log"]
    end

    subgraph "Runtime Server :8100 (main_executor.py, HPA target)"
        direction TB
        EXEC_R["Execution Routers<br/>(invoke, stream, resume,<br/>OpenAI compat, eval)"]
        EXEC_INT["Runtime Internal Router<br/>(service token only)"]

        subgraph "core/asset/ (NEW)"
            RESOLVER["AssetResolver<br/>(resolver.py)"]
            SECRET["SecretHandler<br/>(secret_handler.py)"]
            TOOLS["ToolHandler<br/>(tool_handler.py)"]
            MODELS["ModelHandler<br/>(model_handler.py)"]
        end

        subgraph "core/observability/ (NEW)"
            OBS["TraceCallback<br/>(langfuse_handler.py)"]
        end

        BUILD["AgentBuildService"]
        EXECUTE["AgentExecutionService"]
    end

    subgraph "Queue / Maintenance Lane"
        ARQ["Background Jobs<br/>→ runtime-internal router"]
        MAINT["Singleton maintenance<br/>(cron, sweeper, heartbeat)"]
    end

    subgraph "Sidecar"
        MCP["MCP Proxy :8001"]
        SANDBOX["Code Sandbox :8080"]
    end

    subgraph "Data Plane"
        PG_OPS[("PostgreSQL (Ops)<br/>users, agents, workspace metadata")]
        PG_CP[("PostgreSQL (Checkpointer)<br/>thread history, checkpoints")]
        PG_AUTHZ[("PostgreSQL (Permission DB)<br/>policy, grants, materialization,<br/>admin actions, audit")]
        REDIS[("Redis 7")]
        FS["agent_database/<br/>GlobalStore / WorkspaceStore"]
    end

    subgraph "Langfuse Stack"
        LF["Langfuse (self-hosted)"]
    end

    FE & ADMIN --> NG
    NG -->|"/api/auth/*"| API_AUTH
    NG -->|"/api/workspaces/*"| API_WS
    NG -->|"/api/* (CRUD/metadata)"| API_CRUD
    NG -->|"/api/permissions/*"| PERM_API
    NG -->|"/api/agents/*/invoke,stream<br/>/v1/chat/completions"| EXEC_R

    API_AUTH --> PERM_API
    API_WS --> PERM_API
    API_CRUD --> PERM_API
    API_AUTH --> PG_OPS & REDIS
    API_WS --> PG_OPS
    API_CRUD --> PG_OPS & REDIS & FS
    API_THREAD --> PG_CP

    PERM_API --> PERM_GATE --> PG_AUTHZ
    PERM_GATE --> PERM_AUDIT --> PG_AUTHZ
    PERM_GATE --> FS

    EXEC_R --> RESOLVER
    EXEC_INT --> RESOLVER
    RESOLVER --> SECRET --> PG_OPS
    RESOLVER --> TOOLS --> FS
    RESOLVER --> MODELS --> FS
    RESOLVER -.->|"permission snapshot"| PERM_API

    RESOLVER --> BUILD --> EXECUTE
    EXECUTE --> PG_CP & REDIS
    EXECUTE --> OBS --> LF
    EXECUTE --> MCP & SANDBOX

    ARQ -->|"service token + internal route"| EXEC_INT
    ARQ --> REDIS
    MAINT --> REDIS & PG_OPS & PG_CP & PG_AUTHZ

    classDef client fill:#f3e5f5,stroke:#7b1fa2
    classDef proxy fill:#e8eaf6,stroke:#3949ab
    classDef api fill:#e3f2fd,stroke:#1565c0
    classDef runtime fill:#e8f5e9,stroke:#2e7d32
    classDef data fill:#fff3e0,stroke:#ef6c00
    classDef external fill:#fce4ec,stroke:#c62828
    class FE,ADMIN client
    class NG proxy
    class API_AUTH,API_WS,API_CRUD,API_THREAD api
    class PERM_API,PERM_GATE,PERM_AUDIT api
    class EXEC_R,EXEC_INT,RESOLVER,SECRET,TOOLS,MODELS,OBS,BUILD,EXECUTE runtime
    class PG_OPS,PG_CP,PG_AUTHZ,REDIS,FS data
    class LF,MCP,SANDBOX external
```

## Annotations

**Subgraph nesting strategy.** The Runtime Server subgraph nests two inner subgraphs (`core/asset/` and `core/observability/`) to show that these are implementation modules inside a single process, not separate deployments. The nesting depth is 2 (system → server → module), which stays within the 3-level limit. The `(NEW)` annotation on those subgraphs communicates change status without a separate legend — reviewers immediately know these are additions to the existing runtime.

**Port numbers and entry-point files in subgraph titles.** Each server subgraph includes its bind port (`:8000`, `:8100`, `:8200`) and the entry-point filename in its title. This makes the diagram useful for operations work — a reader can correlate a log line's port number directly to the subgraph without reading source code. The `(HPA target)` annotation on the runtime server flags it as the autoscaling boundary, which is architecturally significant.

**Route-based arrow labels on Nginx edges.** The edges from Nginx include the actual URL path prefixes (`/api/auth/*`, `/v1/chat/completions`). This is the single most useful thing a routing diagram can show — it tells the reader exactly which requests go where without requiring them to read nginx.conf.

**Dashed arrow for optional/snapshot flow.** The `RESOLVER -.->|"permission snapshot"| PERM_API` edge uses a dashed arrow because this call is conditional — the resolver checks permissions only when evaluating an execution request, not on every resolution. Dashed arrows (`-.->`) consistently mean "asynchronous or conditional" throughout the harness style conventions.

**Node count.** This diagram has 28 nodes, approaching the 30-node limit. The `core/asset/` module shows only 4 of the 6 handlers (SkillHandler and MiddlewareHandler are omitted) to stay under the limit. For full handler detail, see `module-code-level.md`.

**`classDef` color assignment.** Colors follow semantic roles: purple for clients (origin of traffic), indigo for the proxy, blue for API/permission servers, green for runtime, orange for data plane, red for external services. This scheme is consistent with the harness-wide `foundation-style-conventions.md` palette extended with domain-specific roles.
