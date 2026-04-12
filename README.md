# oh-my-braincrew (omb)

Multi-agent orchestration harness for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

> Delegate, orchestrate, verify — never implement directly.

## Install

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/teddynote-lab/oh-my-braincrew-release/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/teddynote-lab/oh-my-braincrew-release/main/install.ps1 | iex
```

### Manual Download

| Platform | Architecture | Binary |
|----------|-------------|--------|
| macOS | Apple Silicon (arm64) | [`oh-my-braincrew-v0.1.5-darwin-arm64`](https://github.com/teddynote-lab/oh-my-braincrew-release/releases/latest) |
| Linux | x86_64 | [`oh-my-braincrew-v0.1.5-linux-amd64`](https://github.com/teddynote-lab/oh-my-braincrew-release/releases/latest) |
| Windows | x86_64 | [`oh-my-braincrew-v0.1.5-windows-amd64.exe`](https://github.com/teddynote-lab/oh-my-braincrew-release/releases/latest) |

### Update / Uninstall

```bash
omb update                    # update binary and harness files
omb init                      # re-install harness files only
```

```bash
rm ~/.local/bin/oh-my-braincrew ~/.local/bin/omb   # uninstall binary
```

### CLI Commands

| Command | Description |
|---------|-------------|
| `omb init [path]` | Download and install harness files from latest release |
| `omb update [path]` | Update binary and refresh harness files |
| `omb version` | Print installed version |

## Setup

After installing, initialize in your project:

```bash
cd /path/to/your/project
omb init
```

Then start Claude Code and run the setup wizard:

```
/omb:setup
```

This will:
- Scaffold `.omb/` directory structure (plans, todo, interviews)
- Generate `CLAUDE.md` tailored to your project
- Configure `.claude/settings.json` with hooks and permissions

## Recommended Workflow

Run step-by-step for a complete development cycle, or invoke individually:

| # | Command | Description |
|---|---------|-------------|
| 1 | `/omb:interview` | Requirements interview. Saves to `.omb/interviews/` |
| 2 | `/omb:plan` | Generate implementation plan. Saves to `.omb/plans/` |
| 3 | `/omb:plan-review` | Multi-agent plan review with scoring |
| 4 | `/omb:run [plan]` | Execute plan with TDD agents. Tracks in `.omb/todo/` |
| 5 | `/omb:verify [plan]` | Post-implementation verification with parallel verifiers |
| 6 | `/omb:doc` | Generate or update documentation |
| 7 | `/omb:pr` | Create GitHub PR with lint gate |
| 8 | `/omb:release` | Version release with changelog and binary builds |

## Commands

### Workflow Commands

| Command | Description |
|---------|-------------|
| `/omb:interview` | Structured requirements interview |
| `/omb:plan` | Implementation plan with evaluate-improve loop |
| `/omb:plan-review` | Multi-agent plan review with quantitative scoring |
| `/omb:run` | Execute plan — domain agent delegation, TDD enforcement |
| `/omb:verify` | Post-implementation verification — multi-agent consensus |
| `/omb:doc` | Generate or update service documentation |
| `/omb:pr` | Create GitHub PR — branch validation, lint gate, structured template |
| `/omb:release` | Version bump, changelog, git tag, GitHub Release, CI publish |
| `/omb:harness` | Harness configuration — agents, skills, hooks, rules, settings |

### Utilities

| Command | Description |
|---------|-------------|
| `/omb:setup` | Project scaffolding and configuration |
| `/omb:lint-check` | Stack-aware linter (must pass before PR) |
| `/omb:prompt-guide` | Prompt engineering reference |
| `/omb:prompt-review` | Iterative prompt scoring and improvement |
| `/omb:brainstorming` | Collaborative idea exploration |
| `/omb:mermaid` | Mermaid diagram generation (22 diagram types) |
| `/omb:worktree` | Worktree management (create, status, clean, resume) |
| `/omb:clean` | Worktree cleanup and completion |
| `/omb:issue` | Codebase issue scanning and GitHub issue creation |
| `/omb:git-setup` | Git hooks, `.gitignore` review, GitHub Actions CI |

### Codex Integration

| Command | Description |
|---------|-------------|
| `/omb:codex` | Codex CLI dispatcher — routes to review, adv-review, run, setup |
| `/omb:codex-review` | Run Codex code review on local git state |
| `/omb:codex-adv-review` | Adversarial review — challenges assumptions, finds failure modes |
| `/omb:codex-run` | Delegate a coding task to Codex CLI |
| `/omb:codex-setup` | Verify Codex CLI installation and auth status |

## What is oh-my-braincrew?

A multi-agent orchestration harness that extends Claude Code with:

- **20+ specialized agents** — design, implement, verify, review across 10 domains
- **Structured workflows** — plan → review → execute (TDD) → verify → document → PR
- **Quality gates** — automated lint, type check, and test verification
- **Domain routing** — API, DB, UI, AI/ML, Infra, Security, Electron, Harness
- **Worktree isolation** — parallel feature development with SQLite state tracking

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for release history.

## License

Apache-2.0
