# oh-my-braincrew (omb)

[![Release](https://img.shields.io/github/v/release/braincrew-lab/oh-my-braincrew-release?style=flat-square)](https://github.com/braincrew-lab/oh-my-braincrew-release/releases/latest)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20Windows-blue?style=flat-square)](https://github.com/braincrew-lab/oh-my-braincrew-release/releases/latest)
[![Python](https://img.shields.io/badge/python-%3E%3D3.12-3776AB?style=flat-square&logo=python&logoColor=white)](https://python.org)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-harness-cc785c?style=flat-square&logo=anthropic&logoColor=white)](https://docs.anthropic.com/en/docs/claude-code)
[![License](https://img.shields.io/badge/license-Braincrew%20Internal%20Use%20Only-red?style=flat-square)](#license)

**[English](README.md)** | **[한국어](README-ko.md)**

Multi-agent orchestration harness for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

> Delegate, orchestrate, verify — never implement directly.

This repository is the **public distribution channel**: prebuilt binaries, the harness
tarball, and the install scripts. Source lives in the private `braincrew-lab/oh-my-braincrew`
repository.

## What is oh-my-braincrew?

Claude Code on its own is one agent doing everything in one context. `omb` turns it into a
team with a process. You describe what you want; the harness decides which specialists to
involve, makes them work in parallel, has them review each other, and refuses to call the
work done until the type checker, linter, and tests actually pass.

What it installs into a project:

- **59 specialized agents** — design, implement, verify, explore, and review agents across
  API, DB, UI, AI/ML, Electron, Infra, Security, Harness, Docs, and Wiki domains
- **67 skills** — the `/omb:*` workflows below, plus internal rubrics and reference guides
  loaded on demand
- **117 rule files** — conventions loaded progressively, so an agent editing a FastAPI route
  gets FastAPI rules and nothing else
- **Lifecycle hooks** — a Python hook package that runs on session start, before and after
  tool use, and when a sub-agent finishes. It gates secrets, out-of-scope writes, missing
  pytest timeouts, raw SQL, and the sub-agent output contract.
- **Worktree isolation** — parallel feature branches in separate git worktrees with SQLite
  state tracking, so two workstreams never fight over the same tree

## Install

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/braincrew-lab/oh-my-braincrew-release/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/braincrew-lab/oh-my-braincrew-release/main/install.ps1 | iex
```

### Manual Download

| Platform | Architecture | Binary |
|----------|-------------|--------|
| macOS | Apple Silicon (arm64) | [`oh-my-braincrew-vX.Y.Z-darwin-arm64`](https://github.com/braincrew-lab/oh-my-braincrew-release/releases/latest) |
| Linux | x86_64 | [`oh-my-braincrew-vX.Y.Z-linux-amd64`](https://github.com/braincrew-lab/oh-my-braincrew-release/releases/latest) |
| Windows | x86_64 | [`oh-my-braincrew-vX.Y.Z-windows-amd64.exe`](https://github.com/braincrew-lab/oh-my-braincrew-release/releases/latest) |

Every release also ships `harness-vX.Y.Z.tar.gz` (the `.claude/` harness that `omb init`
installs), a matching `.sha256` sidecar, and `checksums-sha256.txt`.

### CLI Commands

| Command | Description |
|---------|-------------|
| `omb init [path]` | Install harness files (`.claude/`, `.omb/`) from the latest release |
| `omb update [path]` | Update the binary and refresh harness files |
| `omb uninstall` | Remove the installed binary and harness files |
| `omb update-gitignore` | Re-apply the harness `.gitignore` block |
| `omb version` | Print the installed version |
| `omb env <sub>` | Read harness environment settings (used by skill preflights) |
| `omb hook-stats` | Hook execution timing and failure statistics |
| `omb wiki-runtime <sub>` | Wiki search / frontmatter / summary runtime queries |

## Setup

```bash
cd /path/to/your/project
omb init
```

Then, inside Claude Code:

```
> /omb:setup
```

`omb init` installs the harness and creates the `.omb/` working directories. It updates only
harness-owned paths — `.claude/skills/omb-*`, `.claude/agents/omb/`, `.claude/hooks/omb/`,
`.claude/commands/omb/`, and `.claude/rules/**` — and never touches your own agents, skills,
commands, `CLAUDE.md`, `.claude/settings.json`, or `.claude/rules/custom/`. Installed harness
files are added to `.gitignore` automatically.

`/omb:setup` then scans the codebase, generates a `CLAUDE.md` tailored to it, and configures
`settings.json` hooks, permissions, and environment variables.

## Recommended Workflow

Run the cycle end to end, or invoke any step on its own.

```
> /omb:interview      # 1. gather requirements
> /omb:plan           # 2. write an implementation plan
> /omb:plan-review    # 3. review and score the plan
> /omb:run            # 4. execute it with TDD agents
> /omb:verify         # 5. verify the implementation
> /omb:doc            # 6. update documentation
> /omb:pr             # 7. open a pull request
> /omb:release        # 8. cut a release
```

| # | Command | What it does |
|---|---------|--------------|
| 1 | `/omb:interview` | Structured requirements interview → `.omb/interviews/` |
| 2 | `/omb:plan` | Code-location-first plan with an evaluate-improve loop → `.omb/plans/` |
| 3 | `/omb:plan-review` | Parallel multi-agent review with P0-P3 scoring |
| 4 | `/omb:run` | Executes the plan through domain agents → `.omb/todo/` |
| 5 | `/omb:verify` | Parallel verifiers + consensus verdict |
| 6 | `/omb:doc` | Generates or updates `docs/` |
| 7 | `/omb:pr` | Lint gate → commit → push → GitHub PR |
| 8 | `/omb:release` | Version bump, changelog, tag, GitHub Release |

## Commands

### Planning and execution

#### `/omb:interview` — Requirements interview

Asks up to 15 questions covering tech stack, implementation choices, and design preferences,
pre-searching your docs first so it does not ask what the repository already answers.

#### `/omb:plan` — Implementation plan

Explores the codebase, writes a plan anchored to real file paths and line ranges, then loops
evaluate → improve until it clears the quality gate. A necessity gate up front decides whether
the request needs the full treatment or a lighter pass, so a one-file edit does not summon
twelve reviewers.

```
> /omb:plan add OAuth login
# Output: .omb/plans/2026-08-08-oauth-login.md
```

#### `/omb:plan-review` — Plan review

Runs 3-12 domain reviewers in parallel, then synthesizes their findings into one consensus
list with P0-P3 priorities. A finding several reviewers raise independently outranks one only
a single reviewer saw.

#### `/omb:run` — Execute a plan

Reads the plan's task list, delegates each task to the right domain agent, and enforces the
RED-GREEN-IMPROVE cycle. Progress is tracked in `.omb/todo/`.

#### `/omb:verify` — Post-implementation verification

Runs the real checks (`tsc`, `ruff`, `pytest`, `eslint`), has domain agents review the diff,
and returns one verdict. Claims are backed by command output, not by assertion.

#### `/omb:fix` — Bug-fix plan

Git-history forensics, a reproduction procedure, and the smallest patch that fixes the cause
rather than the symptom — plus whatever rule or wiki entry keeps it from recurring.

#### `/omb:refactoring` — Refactoring plan

Goal refinement, then parallel analysis for latent bugs, modularization, design patterns, and
source-of-truth drift, ending in a behavior-preserving TDD plan.

#### `/omb:resolve-issue` — Resolve a GitHub issue

Takes an issue end to end: validity check → plan → implement → verify → PR with an auto-close
link.

#### `/omb:issue` — Issue scanner

Scans the codebase with parallel explorers, votes on what they found, and files GitHub issues
for the survivors.

### Documentation and knowledge

#### `/omb:doc` — Service documentation

Creates and updates documents under `docs/` following the project's category structure,
naming conventions, and templates.

#### `/omb:wiki` — Project blueprint wiki

Read, validate, stage, review, and transactionally publish `docs/wiki/` notes — the project's
durable memory for lessons, constraints, and decisions.

#### `/omb:explain` — Explanation contract

Re-explains work for a reader who did not write the code: noun-phrase sections, plain spoken
register, and evidence attached to each claim. `--page` renders the explanation to HTML.

#### `/omb:mermaid` — Diagrams

Generates Mermaid diagrams across 22 types, including LangGraph state-graph visualizations.

### Quality and prompts

#### `/omb:lint-check` — Lint gate

Detects the stack from the changed files and runs the matching linters. Required before a PR.

#### `/omb:prompt-guide` — Prompt engineering reference

Loads a 72-rule guide across 15 categories for writing system prompts, agent instructions,
and `CLAUDE.md`.

#### `/omb:prompt-review` — Prompt review

Scores a prompt against a rubric, fixes the P0/P1 findings, and re-scores until it passes.

#### `/omb:brainstorming` — Idea exploration

One question at a time, to sharpen intent and constraints before any design is committed.

### Project and repo management

#### `/omb:setup` — Project setup

Scaffolds the directory structure, generates `CLAUDE.md`, and configures hooks and
environment variables in `settings.json`.

#### `/omb:harness` — Harness configuration

Create, verify, fix, or design agents, skills, hooks, rules, and `settings.json`.

```
> /omb:harness --verify    # check configuration health
> /omb:harness --fix       # auto-fix what it finds
```

#### `/omb:worktree` — Worktree management

Isolated git worktrees with persistent SQLite state.

```
> /omb:worktree create feat/add-auth
> /omb:worktree status
> /omb:worktree resume feat/add-auth
```

#### `/omb:clean` — Cleanup

Removes finished worktrees, marks them DONE in the database, and deletes merged branches when
there is merge evidence to justify it.

#### `/omb:pr` — Pull request

Validates the branch name, runs the lint gate, commits, pushes, and opens a PR from a
structured template.

#### `/omb:release` — Release

Version bump, changelog and README sync, commit, push, tag, and a GitHub Release with build
assets. Usable in any repository, not just this one.

```
> /omb:release patch
> /omb:release minor
> /omb:release 2.0.0
> /omb:release --dry-run     # preview only; writes nothing
```

#### `/omb:cron` — Scheduled tasks

Schedule, list, and stop recurring Claude Code runs through the system crontab.

### Codex integration

Optional integration with the [OpenAI Codex CLI](https://github.com/openai/codex) for a
second opinion from a different model.

| Command | What it does |
|---------|--------------|
| `/omb:codex` | Dispatcher — routes to the subcommands below |
| `/omb:codex-review` | Code review of the local git state |
| `/omb:codex-adv-review` | Adversarial review: assumptions, failure modes, edge cases |
| `/omb:codex-run <task>` | Delegates a task to Codex CLI |

## Update / Uninstall

```bash
omb update      # update the binary and refresh harness files
omb init        # reinstall harness files only
omb uninstall   # remove the binary and harness files
```

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- Python 3.12+
- macOS, Linux, or Windows
- `git`, and `gh` for the PR, issue, and release workflows

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for release history.

## License

Braincrew Internal Use Only.
