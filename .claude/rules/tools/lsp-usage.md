---
description: LSP decision tree for choosing the right language server feature
---

# LSP Tool Usage

## Decision Tree

| Question | Tool | Why |
|----------|------|-----|
| "What type is this variable?" | `lsp_hover` | Shows inferred type without reading source |
| "Where is this defined?" | `lsp_goto_definition` | Follows imports across files and packages |
| "Who uses this function?" | `lsp_find_references` | All callers across the project |
| "What's in this file?" | `lsp_document_symbols` | Outline of classes, functions, variables |
| "Find symbol across project" | `lsp_workspace_symbols` | Cross-file symbol search |
| "Are there type errors?" | `lsp_diagnostics` | File-level error/warning report |
| "Errors in directory?" | `lsp_diagnostics_directory` | Batch check across files |
| "Can I rename this safely?" | `lsp_prepare_rename` → `lsp_rename` | Cross-file type-aware rename |
| "Auto-fix available?" | `lsp_code_actions` | IDE-style quick fixes |

## When to Use LSP vs Other Tools
- **LSP > Grep** when you need type information or cross-file references
- **Grep > LSP** for text patterns, comments, string literals
- **AST-grep > both** for structural pattern matching without type info

## Tips
- Run `lsp_diagnostics` after editing a file to catch type errors early
- Use `lsp_find_references` before renaming to assess blast radius
- `lsp_hover` on function calls shows parameter types and return type
- Check `lsp_servers` to verify which LSP servers are running
