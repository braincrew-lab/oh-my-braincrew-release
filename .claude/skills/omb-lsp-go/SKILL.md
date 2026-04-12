---
name: omb-lsp-go
description: "Go LSP patterns — gopls interface checks, module resolution, struct tag validation, and refactoring workflows."
---

# Go LSP Guide

## When to Use LSP (vs Grep/Read)

- **Type info needed** → `lsp_hover` on symbol (shows type signature, doc comments)
- **Find definition** → `lsp_goto_definition` (follows imports across modules)
- **Impact analysis** → `lsp_find_references` (all callers of a function)
- **Compile errors** → `lsp_diagnostics` on file after edit
- **Safe rename** → `lsp_rename` (cross-package, interface-aware)

## Go-Specific Patterns

- **Interface satisfaction**: hover on a type to see which interfaces it implements
- **Struct tags**: diagnostics flags malformed json/yaml struct tags
- **Module resolution**: goto_definition follows imports into `vendor/` or module cache
- **Embedding**: hover on embedded field shows promoted methods
- **Error handling**: diagnostics flags unused error returns
- **Goroutine safety**: use find_references to trace shared variable access

## Decision Tree

1. "What type/signature is this?" → `lsp_hover`
2. "Where is this defined?" → `lsp_goto_definition`
3. "Who calls this?" → `lsp_find_references`
4. "Does this compile?" → `lsp_diagnostics`
5. "Rename safely" → `lsp_prepare_rename` → `lsp_rename`
6. "Auto-fix?" → `lsp_code_actions` (add missing imports, fill struct fields)

## Interface Implementation Workflow

1. Define or modify an interface
2. Hover on the implementing struct — check if it still satisfies the interface
3. Run `lsp_diagnostics` — gopls reports missing method implementations
4. Use `lsp_code_actions` to stub missing methods

## Common Pitfalls

- gopls requires `go.mod` at workspace root — multi-module repos need gopls workspaces
- Vendored dependencies may not be indexed if `GOFLAGS=-mod=vendor` is not set
- Generated code (protobuf, ent) may not be indexed until `go generate` runs
- Build tags (e.g., `//go:build integration`) may exclude files from analysis
