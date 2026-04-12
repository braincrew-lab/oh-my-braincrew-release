---
name: omb-interview
description: "Structured requirements interview — pre-searches docs and codebase, asks up to 15 multi-dimensional questions covering tech stack, implementation choices, and design preferences. Saves summary to .omb/interviews/."
user-invocable: true
argument-hint: "[--worktree] [feature or project description]"
allowed-tools: Read, Bash, Grep, Glob, AskUserQuestion, Agent, Write, Skill
---

# Requirements Interview

Gather comprehensive requirements through structured multi-round questioning before planning begins. Covers 12 dimensions: scope, functional requirements, constraints, tech stack, data model, API contracts, error handling, security, UX/UI, testing, implementation approach, and integration points.

## HARD RULES

[HARD] Maximum 15 questions — stop asking after 15 regardless of dimension coverage.
[HARD] One question at a time — never batch questions. Use AskUserQuestion for each.
[HARD] Multiple choice preferred — offer A/B/C/D options with a recommended choice when alternatives can be enumerated. Open-ended only when choices cannot be listed.
[HARD] Silent context gathering — Phase 1 output is internal only, never shown to the user.
[HARD] Save to `.omb/interviews/` — always write the summary file before emitting DONE.
[HARD] English output — all interview content and summaries must be in English.
[HARD] Worktrees at `{project-root}/worktrees/` ONLY — never inside `.omb/` or `.claude/`.
[HARD] Use AskUserQuestion tool — every question to the user MUST go through the AskUserQuestion tool, not plain text output. Map A/B/C/D options to labeled options with descriptions. Rely on the built-in "Other" option for freeform input.

## How to Ask Questions

Every question in Phase 3 MUST use the `AskUserQuestion` tool. Never output questions as plain text.

### Pattern 1: Dimension Question with Options

Map the traditional A/B/C/D choices to AskUserQuestion's structured options:

```
AskUserQuestion:
  question: "For the data ingestion pipeline, which stack should handle this feature?"
  header: "Tech stack"
  options:
    - label: "Python/FastAPI (Recommended)"
      description: "Consistent with existing data processing layer. Reuses SQLAlchemy models."
    - label: "Node.js/Express"
      description: "Better streaming support for real-time ingestion. Requires new ORM setup."
    - label: "New microservice"
      description: "Isolate the pipeline for independent scaling. Higher operational overhead."
```

### Pattern 2: Multi-Dimensional Question with Preview

When comparing complex approaches that span 2+ dimensions, use the `preview` field:

```
AskUserQuestion:
  question: "For the analytics dashboard, which rendering approach should we use?"
  header: "UX + API"
  options:
    - label: "SSR table (Recommended)"
      description: "Server-rendered with pagination. Simpler, faster initial load."
      preview: |
        GET /api/analytics?page=1&limit=50
        → Server renders HTML table
        → Client hydrates sort/filter controls
        Load time: ~200ms | Bundle: +12KB
    - label: "Client-side charts"
      description: "Interactive charts with real-time WebSocket updates. Richer UX."
      preview: |
        WS /api/analytics/stream
        → Client renders Chart.js / Recharts
        → Live updates every 1s
        Load time: ~800ms | Bundle: +95KB
    - label: "Hybrid"
      description: "SSR table with client-side chart overlay. Balanced approach."
      preview: |
        GET /api/analytics?page=1 (table)
        WS /api/analytics/stream (chart)
        → Table loads fast, chart lazy-loads
        Load time: ~300ms | Bundle: +50KB
```

### Pattern 3: Yes/No with Context

For binary decisions, provide descriptions that explain the trade-offs:

```
AskUserQuestion:
  question: "Should we store payment data locally or delegate to Stripe?"
  header: "Data model"
  options:
    - label: "Stripe-only (Recommended)"
      description: "Store only Stripe customer IDs. No PCI compliance burden. Less flexibility for analytics."
    - label: "Local encrypted storage"
      description: "Store encrypted card tokens. Full analytics access. Requires PCI DSS compliance."
```

### Pattern 4: Convergence Check

When you think you have enough information, confirm with the user:

```
AskUserQuestion:
  question: "I believe I have enough information to create a comprehensive summary. Should I proceed?"
  header: "Status"
  options:
    - label: "Yes, create summary"
      description: "Generate the interview summary from what we've discussed so far."
    - label: "I have more to add"
      description: "Continue the interview — I'll explain what's missing."
```

### Pattern 5: Multi-Select for Feature Scoping

When the user needs to select multiple items from a list:

```
AskUserQuestion:
  question: "Which authentication providers should we support in v1?"
  header: "Auth scope"
  multiSelect: true
  options:
    - label: "Google OAuth"
      description: "Most common for consumer apps. Well-documented SDK."
    - label: "GitHub OAuth"
      description: "Best for developer-facing tools. Grants repo/org scoping."
    - label: "Email/password"
      description: "Traditional auth. Requires password hashing, reset flow, and rate limiting."
    - label: "Magic link"
      description: "Passwordless via email. Simpler UX but depends on email delivery."
```

## Argument Parsing

```
omb-interview [--worktree] [feature or project description]
```

1. Check if the argument string contains `--worktree`
2. If yes: set `worktree_mode = true`, strip `--worktree` from the argument string
3. Pass the remaining string as the feature/project description

## Workflow Overview

```
Phase 0: Argument Parsing                  (detect --worktree flag)
Phase 1: Silent Context Gathering          (no user interaction)
Phase 1.5: Worktree Setup                  (conditional — if --worktree)
Phase 2: Intent Clarification              (optional — delegates to omb-brainstorming)
Phase 3: Multi-Dimensional Questioning     (up to 15 questions)
Phase 4: Convergence Detection             (automatic)
Phase 5: Summary Generation + Save         (.omb/interviews/YYYY-MM-DD-slug.md)
Phase 5.5: Worktree Teardown              (conditional — if --worktree)
Phase 6: Suggest Next Step                 (propose /omb-plan)
```

## Phase 1: Silent Context Gathering

Before asking a single question, silently gather codebase context to form better questions:

1. **Project structure**: Scan top-level files and key directories
2. **Existing docs**: Read `docs/` folder structure and key documents if present
3. **Previous interviews**: Check `.omb/interviews/` for prior interview results
4. **Git history**: Recent commits (`git log --oneline -20`) to understand project trajectory
5. **Tech stack detection**: Identify from `package.json`, `pyproject.toml`, `tsconfig.json`, `Cargo.toml`, `go.mod`, `docker-compose.yml`, etc.
6. **Deeper exploration** (optional): Use `Skill("omb-explore")` if the project is large or the feature touches multiple domains

If a previous interview exists for a similar topic, mention it:
"I found a previous interview on a related topic. I'll reference it but start fresh."

This phase is silent — do not output findings to the user. Use them to form informed, context-aware questions.

## Phase 1.5: Worktree Setup (conditional)

**Only execute when `worktree_mode = true`.** Follow `.claude/rules/workflow/07-worktree-protocol.md`.

<execution_order>
1. Derive branch name: `{type}/{slug-from-description}`. Infer type from the feature description (new feature → `feat/`, investigation → `chore/`). Default to `feat/` if ambiguous.
2. Run the worktree setup script:
   ```bash
   bash .claude/hooks/omb/omb-hook.sh WorktreeSetup {type}/{slug}
   ```
3. Enter the worktree and verify `pwd`:
   ```bash
   cd worktrees/{type}/{slug} && pwd
   ```
   Confirm the output matches `{project-root}/worktrees/{type}/{slug}`.
4. If the setup script exits non-zero or `pwd` mismatches: report BLOCKED and stop.
</execution_order>

Record `worktree_active = true`, `worktree_branch`, and `worktree_path` for Phase 5.5.

## Phase 2: Intent Clarification

Evaluate the user's initial description:

- **Clear and specific** (e.g., "Add OAuth2 login with Google and GitHub providers to the existing FastAPI backend"): skip to Phase 3.
- **Vague or exploratory** (e.g., "I want to add authentication" or "make the app better"): invoke `Skill("omb-brainstorming")` to refine intent before proceeding.

**Decision criteria**: Can you enumerate at least 3 concrete functional requirements from the description? If yes, skip brainstorming. If no, brainstorm first.

Brainstorming questions do NOT count toward the 15-question limit. The interview's own Phase 3 questions are counted separately.

## Phase 3: Multi-Dimensional Questioning

Ask up to 15 questions, one at a time. Each question should cover one or more of the 12 interview dimensions. Track which dimensions have been covered and prioritize uncovered ones.

### Interview Dimensions

| # | Dimension | Priority | When to Ask |
|---|-----------|----------|-------------|
| 1 | Scope and Purpose | Always | Early (Q1-Q2) |
| 2 | Functional Requirements | Always | Early (Q2-Q4) |
| 3 | Constraints and Boundaries | Always | Early (Q3-Q5) |
| 4 | Tech Stack Decisions | When multiple viable options | Adaptive |
| 5 | Data Model | When data persistence involved | Adaptive |
| 6 | API Contracts | When APIs exposed/consumed | Adaptive |
| 7 | Error Handling / Edge Cases | After functional reqs clear | Adaptive |
| 8 | Security | When user data / external access | Adaptive |
| 9 | UX/UI Expectations | When frontend component exists | Adaptive |
| 10 | Testing Strategy | After impl approach decided | Adaptive |
| 11 | Implementation Approach | When architectural choices open | Adaptive |
| 12 | Integration Points | When external systems involved | Adaptive |

### Dimension Details

**1. Scope and Purpose**
- What problem are we solving? Who are the users?
- What does "done" look like? What is the success metric?

**2. Functional Requirements**
- Core behaviors and user stories
- Input/output specifications
- Acceptance criteria

**3. Constraints and Boundaries**
- What is explicitly out of scope?
- Timeline pressure? Breaking changes allowed?
- Backward compatibility? Budget/resource limits?

**4. Tech Stack Decisions**
- Which layers? (Python/FastAPI, Node.js/Express, React, Electron, Redis, Postgres, LangGraph)
- Preferred libraries or patterns?
- Integration points with existing systems?

**5. Data Model**
- Entities and data structures needed?
- Storage choice (Postgres, Redis, filesystem, external)?
- Relationships, access patterns, and query requirements?

**6. API Contracts**
- Endpoint design (REST, GraphQL, WebSocket, IPC)?
- Request/response shapes?
- Authentication and authorization requirements?

**7. Error Handling and Edge Cases**
- Known failure modes and recovery strategies?
- What must NOT happen (safety constraints)?
- Retry, fallback, and degraded-mode behavior?

**8. Security Considerations**
- Sensitive data handling?
- Auth/authz model?
- Input validation and rate limiting requirements?

**9. UX/UI Expectations**
- Component patterns and design system preferences?
- Responsive requirements and breakpoints?
- Accessibility standards (WCAG level)?
- Visual design preferences (minimal, rich, dashboard-style)?

**10. Testing Strategy**
- Critical test scenarios and coverage expectations?
- Unit vs integration vs E2E priorities?
- Performance requirements and benchmarks?

**11. Implementation Approach**
- Monolith vs microservice? Sync vs async?
- Batch vs streaming? Event-driven vs request/response?
- Architecture patterns (CQRS, saga, repository)?

**12. Integration Points**
- Third-party services (payment, auth, email, analytics)?
- Webhooks, message queues, or event buses?
- Existing internal services to connect with?

### Question Crafting Rules

- **Reference discovered context**: "I see you're using FastAPI with SQLAlchemy (from `pyproject.toml`). For the new user model, should we..."
- **Offer concrete options**: Use AskUserQuestion with 2-4 labeled choices and a recommendation.
- **Build on prior answers**: "You mentioned real-time updates. That means we should consider WebSocket vs SSE — which do you prefer?"
- **Multi-dimensional**: A single question can span 2+ dimensions. E.g., "For the payment integration (Integration Points), should we use Stripe's embedded checkout (UX) or server-side API (API Contracts)? Option A means less frontend work but less customization."
- **Adaptive depth**: If an answer reveals the feature is simpler than expected, skip irrelevant dimensions. If more complex, allocate more questions.

### Question Examples

All examples below use the `AskUserQuestion` tool. See "How to Ask Questions" above for detailed patterns.

**Tech Stack + Implementation Approach:**
```
AskUserQuestion:
  question: "I see the project uses both FastAPI and Express. Which stack should handle the data ingestion pipeline?"
  header: "Tech stack"
  options:
    - label: "Python/FastAPI (Recommended)"
      description: "Consistent with existing data processing layer. Reuses SQLAlchemy models and pytest fixtures."
    - label: "Node.js/Express"
      description: "Better streaming support for real-time ingestion. Requires new ORM and test setup."
    - label: "New microservice"
      description: "Isolate the pipeline for independent scaling. Higher operational overhead."
```

**UX/UI + API Contracts:**
```
AskUserQuestion:
  question: "The dashboard uses React with Tailwind. For the new analytics view, which rendering approach?"
  header: "UX + API"
  options:
    - label: "SSR table (Recommended)"
      description: "Server-rendered with pagination. Simpler, faster initial load. Lower bundle size."
    - label: "Client-side charts"
      description: "Interactive Chart.js/Recharts with real-time WebSocket updates. Richer UX, larger bundle."
    - label: "Hybrid"
      description: "SSR table loads fast, client-side chart overlay lazy-loads. Balanced approach."
```

**Data Model + Security:**
```
AskUserQuestion:
  question: "For storing user payment information, how should we handle sensitive data?"
  header: "Data + Security"
  options:
    - label: "Stripe-only (Recommended)"
      description: "Store only Stripe customer IDs. No PCI compliance burden. Less flexibility for analytics."
    - label: "Local encrypted storage"
      description: "Store encrypted card tokens with PCI DSS compliance. Full control but high compliance cost."
    - label: "Third-party vault"
      description: "Use Basis Theory or similar. Offload compliance while retaining some data access."
```

## Phase 4: Convergence Detection

After each answer, evaluate whether enough information has been gathered.

**Convergence criteria** (ALL must be true):
- Dimensions 1-3 (Scope, Functional Requirements, Constraints) are fully covered
- At least 2 additional dimensions are covered based on feature type
- No open contradictions or ambiguities remain
- You can write a 1-paragraph summary the user would agree with

**If converged before 15 questions**: announce "I believe I have enough information to create a comprehensive summary" and move to Phase 5.

**If 15 questions reached without full convergence**: move to Phase 5 with remaining uncertainties listed in the Open Questions section.

## Phase 5: Summary Generation + Save

1. Create the interviews directory: `mkdir -p .omb/interviews`
2. Generate the interview summary document (see template below)
3. Present the summary to the user for confirmation before saving
4. On user approval, write to `.omb/interviews/YYYY-MM-DD-slug.md`

### Interview Summary Template

```markdown
---
title: "{Feature/Project Name}"
date: YYYY-MM-DD
status: complete | partial
questions-asked: {N}
dimensions-covered:
  - {dimension 1}
  - {dimension 2}
---

# Interview Summary: {Feature/Project Name}

## Context
{1-2 paragraph summary of what was discussed and the key decisions made}

## Requirements

### Scope and Purpose
- {bullet points}

### Functional Requirements
- {bullet points with acceptance criteria}

### Constraints and Boundaries
- {constraints}
- **Out of scope**: {explicit exclusions}

### Tech Stack Decisions
- {decisions with rationale}

### Data Model
- {entities, relationships, storage patterns}

### API Contracts
- {endpoint structure, auth, formats}

### Error Handling
- {expected failures, recovery strategies}

### Security
- {auth model, validation, sensitive data handling}

### UX/UI Expectations
- {component patterns, design preferences, accessibility}

### Testing Strategy
- {approach, coverage targets, frameworks}

### Implementation Approach
- {architecture decisions, patterns chosen}

### Integration Points
- {external services, internal connections}

## Open Questions
- {any unresolved items from Phase 4}

## Suggested Next Steps
1. Run `/omb-plan` to create an implementation plan from these requirements
2. {any other recommended actions based on the interview}
```

Only include sections that were covered during the interview. Omit sections with no content rather than leaving empty placeholders.

## Phase 5.5: Worktree Teardown (conditional)

**Only execute when `worktree_active = true`.** Follow `.claude/rules/workflow/07-worktree-protocol.md`.

<execution_order>
1. Ask the user via `AskUserQuestion`:
   ```
   Interview complete in worktree branch `{worktree_branch}`.
   The interview summary needs to be in the main tree for /omb-plan to find it.
   Recommended action: Merge
   Options:
   1. Merge — merge changes into the original branch, then remove worktree
   2. Keep — keep worktree for manual review
   3. Discard — remove worktree and delete branch
   ```
2. Execute chosen action:
   - **Merge**: `cd {project-root} && git merge {worktree_branch}` then `bash .claude/hooks/omb/omb-hook.sh WorktreeTeardown {worktree_branch} --delete-branch`
   - **Keep**: `cd {project-root}`
   - **Discard**: `cd {project-root} && bash .claude/hooks/omb/omb-hook.sh WorktreeTeardown {worktree_branch} --delete-branch`
3. Verify return: run `pwd` and confirm CWD is back at the original project root.
</execution_order>

## Phase 6: Suggest Next Step

After saving the summary, suggest the next action:

"The interview is complete and saved to `.omb/interviews/{filename}`. To create an implementation plan from these requirements, run `/omb-plan`."

Do not auto-invoke omb-plan. Let the user decide when to proceed.

## Escape Hatch

If the user says "skip interview", "just plan it", or "no questions":
1. Save a minimal summary noting the interview was skipped
2. Include whatever context was provided in the initial description
3. Emit the DONE status immediately

## Output Contract

On successful completion:

```
<omb>DONE</omb>
```

```result
verdict: Interview complete
summary: {1-3 sentence summary of gathered requirements}
artifacts:
  - .omb/interviews/YYYY-MM-DD-slug.md
changed_files:
  - .omb/interviews/YYYY-MM-DD-slug.md
concerns:
  - {concerns if any, empty list if none}
blockers: []
retryable: false
next_step_hint: invoke /omb-plan for implementation planning
```

On blocked (user refuses critical questions, contradictory requirements unresolvable):

```
<omb>BLOCKED</omb>
```

```result
verdict: Interview blocked
summary: {description of what is blocking}
artifacts: []
changed_files: []
concerns: []
blockers:
  - {blocking issue description}
retryable: true
next_step_hint: resolve the blocking issue and re-invoke omb-interview
```
