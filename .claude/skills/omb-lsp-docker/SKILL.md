---
name: omb-lsp-docker
description: "Dockerfile LSP patterns — dockerfile-language-server validation, hadolint integration, and multi-stage build navigation."
---

# Dockerfile LSP Guide

## When to Use LSP (vs Grep/Read)

- **Instruction validation** → `lsp_diagnostics` on Dockerfile (syntax + best practices)
- **Instruction info** → `lsp_hover` on directive (shows usage docs)
- **Stage navigation** → `lsp_goto_definition` on `COPY --from=stage` references
- **Quick fixes** → `lsp_code_actions` for common Dockerfile improvements

## Dockerfile-Specific Patterns

- **Multi-stage builds**: goto_definition on `--from=builder` jumps to the named stage
- **Base image info**: hover on `FROM` line shows image details
- **Hadolint rules**: diagnostics surfaces lint warnings (pin versions, use COPY not ADD)
- **ARG/ENV resolution**: hover on `$VAR` references shows where defined
- **HEALTHCHECK**: diagnostics flags missing healthcheck in production images

## Decision Tree

1. "Is this Dockerfile valid?" → `lsp_diagnostics`
2. "What does this instruction do?" → `lsp_hover`
3. "Where is this build stage defined?" → `lsp_goto_definition` on `--from=`
4. "Best practice violations?" → `lsp_diagnostics` (hadolint rules)
5. "Auto-fix available?" → `lsp_code_actions`

## Multi-Stage Build Workflow

1. Use `lsp_goto_definition` on `COPY --from=stage_name` to navigate between stages
2. Run `lsp_diagnostics` to verify each stage is valid
3. Hover on `FROM` lines to check base image details
4. Use find_references on a stage name to see all `--from=` references to it

## Common Best Practices (flagged by diagnostics)

- Use specific image tags, not `latest`
- Prefer `COPY` over `ADD` unless extracting archives
- Combine `RUN` commands to reduce layers
- Set `WORKDIR` instead of `cd` in RUN
- Use `.dockerignore` to exclude unnecessary files

## Common Pitfalls

- dockerfile-language-server only analyzes Dockerfiles, not docker-compose
- Hadolint integration depends on server configuration
- Build args from `docker build --build-arg` are not visible to the LSP
- Syntax highlighting for heredocs (`<<EOF`) may not be supported
