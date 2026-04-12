---
name: omb-lsp-typescript
description: "TypeScript LSP patterns — tsserver type checking, path alias resolution, .d.ts navigation, and type narrowing."
---

# TypeScript LSP Guide

## When to Use LSP (vs Grep/Read)

- **Type info needed** → `lsp_hover` on symbol (shows inferred/declared types)
- **Find definition** → `lsp_goto_definition` (follows imports, resolves aliases)
- **Impact analysis** → `lsp_find_references` (all usages across the project)
- **Type errors** → `lsp_diagnostics` on file after edit
- **Safe rename** → `lsp_rename` (cross-file, handles re-exports)

## TypeScript-Specific Patterns

- **Path aliases**: goto_definition resolves `@/` and `~` paths from tsconfig
- **Type narrowing**: hover after type guards shows narrowed union types
- **.d.ts files**: goto_definition jumps into declaration files for external libs
- **Generic inference**: hover on generic call sites shows resolved type params
- **Discriminated unions**: hover after switch/if shows narrowed variant
- **JSX props**: hover on component to see full props interface

## Decision Tree

1. "What type is this?" → `lsp_hover`
2. "Where is this defined?" → `lsp_goto_definition`
3. "Who uses this?" → `lsp_find_references`
4. "Is this file valid?" → `lsp_diagnostics`
5. "Rename safely" → `lsp_prepare_rename` → `lsp_rename`
6. "Auto-import / quick fix?" → `lsp_code_actions`

## Type Checking Workflow

1. Edit the file
2. Run `lsp_diagnostics` — tsserver reports errors immediately
3. If errors found → check hover on flagged expressions for expected vs actual type
4. Use `lsp_code_actions` for auto-imports and quick fixes

## Common Pitfalls

- `any` silently suppresses errors — hover to verify symbols are not `any`
- Path alias resolution requires tsconfig `paths` to be configured
- Monorepo projects may need project references for cross-package navigation
- `.d.ts` files may show outdated types if not regenerated after source changes
- `as` casts hide type errors — diagnostics will not flag incorrect casts
