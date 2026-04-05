# oh-my-braincrew

Multi-agent orchestration harness for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

> Delegate, orchestrate, verify — never implement directly.

## Installation

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/teddynote-lab/oh-my-braincrew-release/main/install.sh | sh
```

Or with a custom install directory:

```bash
OMB_INSTALL_DIR=~/.local/bin curl -fsSL https://raw.githubusercontent.com/teddynote-lab/oh-my-braincrew-release/main/install.sh | sh
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/teddynote-lab/oh-my-braincrew-release/main/install.ps1 | iex
```

### pip / uv (alternative)

```bash
pip install oh-my-braincrew
# or
uv tool install oh-my-braincrew
```

### Manual Download

Download the binary for your platform from the [latest release](https://github.com/teddynote-lab/oh-my-braincrew-release/releases/latest).

| Platform | Architecture | Binary |
|----------|-------------|--------|
| macOS | Apple Silicon (arm64) | `omb-v0.2.6-darwin-arm64` |
| macOS | Intel (amd64) | `omb-v0.2.6-darwin-amd64` |
| Linux | x86_64 | `omb-v0.2.6-linux-amd64` |
| Windows | x86_64 | `omb-v0.2.6-windows-amd64.exe` |

## Quick Start

```bash
# Initialize in your project
cd /path/to/your/project
omb init

# Start Claude Code with the harness
claude --plugin-dir ~/.omb

# Check version
omb version
```

## Update

```bash
omb update
```

The `omb update` command auto-detects your install method (binary, pip, uv tool) and updates accordingly.

## What is oh-my-braincrew?

oh-my-braincrew is a multi-agent orchestration harness that extends Claude Code with:

- **Specialized agent teams** — executor, reviewer, critic, and 15+ domain specialists
- **Structured workflows** — plan, review, execute (TDD), verify, document, PR
- **Pipeline orchestration** — dependency-aware task scheduling with parallel execution
- **Quality gates** — no completion claims without verification evidence
- **Tech stack awareness** — Python, TypeScript, React, FastAPI, LangChain/LangGraph, and more

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for release history.

## License

Apache-2.0
