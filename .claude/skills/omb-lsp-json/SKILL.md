---
name: omb-lsp-json
description: "JSON LSP patterns — vscode-json-languageserver schema validation for tsconfig, package.json, and settings files."
---

# JSON LSP Guide

## When to Use LSP (vs Grep/Read)

- **Schema validation** → `lsp_diagnostics` on file (validates against JSON Schema)
- **Field info** → `lsp_hover` on key (shows description from schema)
- **Value constraints** → `lsp_hover` on value (shows allowed types/enums)
- **Quick fixes** → `lsp_code_actions` for schema-suggested corrections

## JSON-Specific Patterns

- **tsconfig.json**: diagnostics validates compiler options, hover shows option descriptions
- **package.json**: hover on dependency shows version range meaning, diagnostics flags invalid fields
- **settings files**: diagnostics validates against tool-specific schemas (eslint, prettier, etc.)
- **.vscode/launch.json**: hover on properties shows debug config options
- **Schema Store**: auto-detects schemas for 400+ known JSON files by filename

## Decision Tree

1. "Is this JSON valid against its schema?" → `lsp_diagnostics`
2. "What does this field do?" → `lsp_hover`
3. "What values are allowed?" → `lsp_hover` (shows enum options, types)
4. "Fix this validation error" → `lsp_code_actions`

## Schema Detection

- Auto-detected by filename: `tsconfig.json`, `package.json`, `.eslintrc.json`
- Configurable via `$schema` property in the JSON file itself
- SchemaStore.org provides schemas for common config files
- Custom schemas can be mapped via server settings

## Validation Workflow

1. Edit the JSON file
2. Run `lsp_diagnostics` — reports schema violations and syntax errors
3. Hover on flagged keys to understand expected structure
4. Use code_actions for auto-fixes when available

## Common Use Cases

- **tsconfig.json**: verify `compilerOptions` are valid, hover for option docs
- **package.json**: validate scripts, engines, and dependency format
- **eslintrc/prettierrc**: ensure config keys match tool schema
- **turbo.json**: validate pipeline/task configuration

## Common Pitfalls

- Without a schema, JSON LSP only checks syntax (valid JSON), not semantics
- JSON with comments (JSONC) used by tsconfig needs the server to support it
- Trailing commas in JSONC are valid but JSON LSP may flag them without JSONC mode
- Large JSON data files may slow down the language server
- `$ref` in JSON Schema files may not resolve if the referenced schema is remote
