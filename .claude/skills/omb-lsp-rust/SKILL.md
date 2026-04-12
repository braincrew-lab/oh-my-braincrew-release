---
name: omb-lsp-rust
description: "Rust LSP patterns — rust-analyzer trait checks, lifetime analysis, cargo workspace navigation, and macro expansion."
---

# Rust LSP Guide

## When to Use LSP (vs Grep/Read)

- **Type info needed** → `lsp_hover` on symbol (shows inferred types, lifetimes)
- **Find definition** → `lsp_goto_definition` (follows use/mod paths, enters crates)
- **Impact analysis** → `lsp_find_references` (all usages of a symbol)
- **Compile errors** → `lsp_diagnostics` on file after edit
- **Safe rename** → `lsp_rename` (cross-crate aware)

## Rust-Specific Patterns

- **Trait implementations**: hover on a type to see implemented traits
- **Lifetime inference**: hover shows inferred lifetime parameters
- **Macro expansion**: hover on macro invocation shows expanded code
- **Deref chains**: goto_definition resolves through Deref implementations
- **Cargo workspaces**: goto_definition navigates across workspace crates
- **Feature flags**: diagnostics respects `#[cfg(feature = "...")]`

## Decision Tree

1. "What type is this?" → `lsp_hover` (especially useful for inferred types)
2. "Where is this defined?" → `lsp_goto_definition`
3. "Who uses this?" → `lsp_find_references`
4. "Does this compile?" → `lsp_diagnostics`
5. "Rename safely" → `lsp_prepare_rename` → `lsp_rename`
6. "Auto-fix?" → `lsp_code_actions` (add missing imports, derive macros, match arms)

## Trait Implementation Workflow

1. Implement a trait on a struct
2. Run `lsp_diagnostics` — rust-analyzer reports missing methods
3. Use `lsp_code_actions` to generate method stubs
4. Hover on the impl block to verify trait satisfaction

## Common Pitfalls

- rust-analyzer needs `Cargo.toml` — will not work in standalone `.rs` files
- Proc macros may not expand if the macro crate has compile errors
- Large workspaces may have slow initial indexing — diagnostics may be incomplete
- `#[cfg]`-disabled code is excluded from analysis by default
- Generic type errors can be verbose — hover on sub-expressions to isolate the issue
