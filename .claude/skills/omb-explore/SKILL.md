---
name: omb-explore
description: "Codebase exploration router — analyzes requirements to detect relevant domains, then dispatches domain-specific explorers in parallel and aggregates findings."
user-invocable: true
argument-hint: "[search query or feature description]"
---

# Codebase Exploration Router

Analyzes the user's query or feature description to detect relevant technical domains, then dispatches domain-specific explorer agents in parallel and aggregates their findings into a unified report.

## When to Apply

- Before planning a new feature (called by `omb-plan`)
- When the user asks "where is X?" or "find all Y" across the codebase
- Before any multi-domain implementation to gather context
- When existing `core-explore` is insufficient for domain-specific depth

## Explorer Agent Inventory

| Agent | Domain | File Patterns | Skills |
|-------|--------|---------------|--------|
| @general-explorer | Project-wide | `*` (structure, config, entry points) | omb-lsp-common |
| @api-explorer | API/Backend | `**/routes/**`, `**/api/**`, `**/middleware/**` | omb-lsp-common, omb-lsp-python, omb-lsp-typescript |
| @db-explorer | Database | `**/models/**`, `**/migrations/**`, `alembic/**` | omb-lsp-common, omb-lsp-python |
| @ui-explorer | UI/Frontend | `**/*.tsx`, `**/components/**`, `**/hooks/**` | omb-lsp-common, omb-lsp-typescript, omb-lsp-css |
| @ai-explorer | AI/ML | `**/graphs/**`, `**/tools/**`, `**/prompts/**` | omb-lsp-common, omb-lsp-python |
| @electron-explorer | Electron | `**/main/**`, `**/preload/**`, `**/ipc/**` | omb-lsp-common, omb-lsp-typescript |
| @infra-explorer | Infrastructure | `Dockerfile*`, `*.yml`, `*.tf`, `.github/**` | omb-lsp-common, omb-lsp-docker, omb-lsp-terraform, omb-lsp-yaml |
| @doc-explorer | Documentation | `docs/**/*.md`, `README.md`, `CLAUDE.md` | omb-lsp-common |

## Domain Detection

Analyze the query for domain signals and route to the appropriate explorers:

| Signal Keywords | Domain | Explorer |
|----------------|--------|----------|
| FastAPI, Express, routes, endpoints, REST, GraphQL, middleware, auth | API | @api-explorer |
| SQLAlchemy, Prisma, Alembic, migrations, models, queries, schema, database | DB | @db-explorer |
| React, components, hooks, Tailwind, Vite, pages, frontend, CSS, UI | UI | @ui-explorer |
| LangGraph, LangChain, agents, prompts, RAG, embeddings, tools, AI | AI | @ai-explorer |
| Electron, IPC, preload, BrowserWindow, desktop, main process | Electron | @electron-explorer |
| Docker, GitHub Actions, K8s, Terraform, CI/CD, deploy, infra | Infra | @infra-explorer |
| docs, documentation, architecture, API docs, ADR, README | Docs | @doc-explorer |

## Orchestration Steps

### Step 1: Analyze Query

Parse the user's query to identify:
- Which technical domains are involved
- What specific information is needed
- Whether this is a broad exploration or targeted search

### Step 2: Select Explorers

Based on domain detection:
- **Always include:** @general-explorer (project-wide context) + @doc-explorer (reference docs)
- **Add domain-specific:** based on signal keywords detected
- **Minimum 3 explorers** per query (general + doc + at least 1 domain)
- **Maximum 5 explorers** per query (to avoid context overflow)

### Step 3: Dispatch in Parallel

Spawn selected explorers **simultaneously** using multiple Agent() calls in a single message:

```
Agent({ subagent_type: "general-explorer", prompt: "..." })
Agent({ subagent_type: "doc-explorer", prompt: "..." })
Agent({ subagent_type: "api-explorer", prompt: "..." })
```

Each explorer receives:
- The original query/feature description
- Domain-specific focus instructions
- Expected output format (file:line with purpose annotations)

### Step 4: Aggregate Results

After all explorers return:
1. **Deduplicate** — Remove duplicate file references across explorers
2. **Organize by domain** — Group findings under domain headers
3. **Annotate relevance** — Mark each finding's relevance to the original query
4. **Identify gaps** — Note domains where no relevant code was found
5. **Compile unified report** — Structured findings report for downstream consumers

### Step 5: Deliver Findings

Output the aggregated findings in a structured format:

```
## Exploration Summary
Query: {original query}
Explorers dispatched: {list}
Domains covered: {list}

## Findings by Domain

### Project Structure (@general-explorer)
- {finding}: `file:line` — {purpose}

### API (@api-explorer)
- {finding}: `file:line` — {purpose}

### Database (@db-explorer)
- {finding}: `file:line` — {purpose}

...

## Documentation References (@doc-explorer)
- {doc}: `file:line` — {relevance to query}

## Gaps Identified
- {domain with no relevant findings}
- {missing documentation}
```

## Rules

- **Always parallel dispatch** — Never spawn explorers sequentially. Use multiple Agent() calls in one message.
- **Always include general + doc** — These provide essential project context for any query.
- **Cap at 5 explorers** — More than 5 risks context overflow without proportional value.
- **Domain-specific prompts** — Each explorer gets a tailored prompt, not a generic one. Include the query plus domain-specific focus.
- **Structured aggregation** — Findings must be organized by domain with file:line references. Raw tool output is not acceptable.
- **Purpose annotations** — Every file:line reference must explain WHY this file is relevant to the query.
