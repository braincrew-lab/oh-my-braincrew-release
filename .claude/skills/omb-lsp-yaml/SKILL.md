---
name: omb-lsp-yaml
description: "YAML LSP patterns — yaml-language-server JSON schema validation for docker-compose, k8s manifests, and GitHub Actions workflows."
---

# YAML LSP Guide

## When to Use LSP (vs Grep/Read)

- **Schema validation** → `lsp_diagnostics` on file (validates against JSON Schema)
- **Field info** → `lsp_hover` on key (shows description from schema)
- **Completion context** → `lsp_hover` to understand valid values for a field
- **Quick fixes** → `lsp_code_actions` for schema-suggested corrections

## YAML-Specific Patterns

- **docker-compose.yml**: diagnostics validates service config, volume mounts, network names
- **k8s manifests**: hover on fields like `spec.containers[].resources` shows allowed structure
- **GitHub Actions**: diagnostics validates workflow syntax, step inputs, action versions
- **Helm charts**: goto_definition on template references (limited, depends on server)
- **OpenAPI/Swagger**: diagnostics validates endpoint definitions against spec

## Decision Tree

1. "Is this YAML valid against its schema?" → `lsp_diagnostics`
2. "What does this field mean?" → `lsp_hover`
3. "What values are allowed here?" → `lsp_hover` (shows enum/type from schema)
4. "Fix this validation error" → `lsp_code_actions`

## Schema Detection

- yaml-language-server uses modeline comments: `# yaml-language-server: $schema=...`
- Auto-detects by filename: `docker-compose.yml`, `.github/workflows/*.yml`
- SchemaStore.org provides schemas for 500+ YAML formats
- Custom schemas can be configured in server settings

## Validation Workflow

1. Edit the YAML file
2. Run `lsp_diagnostics` — reports schema violations immediately
3. Hover on flagged fields to understand expected structure
4. Use code_actions for auto-fixes when available

## Common Pitfalls

- Schema must be configured — without it, yaml-language-server only checks syntax
- Anchors and aliases (`&`/`*`) are resolved before schema validation
- Multi-document YAML (`---` separators) may confuse some servers
- Custom CRDs in k8s need their schemas registered for validation
- Indentation errors often produce misleading schema validation messages
