---
name: omb-lsp-common
description: "Common LSP tool decision tree — when to use hover, goto_definition, find_references, diagnostics, rename, and code_actions across any language."
---

# Common LSP Decision Tree

## When to Use LSP (vs Grep/Read)

- **Type info needed** → `lsp_hover` on symbol (faster than reading source)
- **Find definition** → `lsp_goto_definition` (follows imports, jumps to source)
- **Impact analysis** → `lsp_find_references` (all callers/usages of a symbol)
- **Validation after edit** → `lsp_diagnostics` on file (type errors, lint issues)
- **Safe rename** → `lsp_prepare_rename` then `lsp_rename` (cross-file, type-aware)
- **Quick fixes** → `lsp_code_actions` (auto-imports, extract function, etc.)

## When NOT to Use LSP

- Searching for string patterns across files → use Grep
- Reading file structure/layout → use Read
- Finding files by name → use Glob
- No LSP server running for the language → fall back to Grep + Read

## Decision Tree

1. "What type/signature is this?" → `lsp_hover`
2. "Where is this defined?" → `lsp_goto_definition`
3. "Who calls/uses this?" → `lsp_find_references`
4. "Did my edit break anything?" → `lsp_diagnostics`
5. "Rename this symbol safely" → `lsp_prepare_rename` → `lsp_rename`
6. "Fix this error automatically" → `lsp_code_actions`

## Best Practices

- Always run `lsp_diagnostics` after editing a file to catch regressions
- Use `lsp_hover` before `lsp_goto_definition` — hover often gives enough info
- Prefer `lsp_find_references` over Grep for symbol usage — Grep finds string matches, LSP finds semantic references
- Chain: `lsp_goto_definition` → `lsp_hover` at target to understand both location and type
- Use `lsp_code_actions` on diagnostic errors — LSP often has auto-fixes available

## Common Pitfalls

- LSP may not index files outside the workspace root
- Diagnostics may lag after rapid edits — re-request if results seem stale
- Some servers require the file to be saved before diagnostics update
