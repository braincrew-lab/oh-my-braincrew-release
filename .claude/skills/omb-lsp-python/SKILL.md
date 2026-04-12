---
name: omb-lsp-python
description: "Python LSP patterns — pyright/pylsp type checking, import resolution, and refactoring workflows."
---

# Python LSP Guide

## When to Use LSP (vs Grep/Read)

- **Type info needed** → `lsp_hover` on symbol (faster than reading source)
- **Find definition** → `lsp_goto_definition` (follows imports across packages)
- **Impact analysis** → `lsp_find_references` (all callers of a function)
- **Type errors** → `lsp_diagnostics` on file after edit
- **Safe rename** → `lsp_rename` (cross-file, type-aware)

## Python-Specific Patterns

- **Pydantic models**: hover on model class to see all fields with types
- **FastAPI deps**: goto_definition on `Depends()` argument to trace injection
- **async/await**: diagnostics will flag missing await on coroutines
- **Import resolution**: goto_definition follows relative and absolute imports through virtualenv
- **Type narrowing**: hover after `isinstance()` checks shows narrowed type
- **Overloaded functions**: hover shows all overload signatures

## Decision Tree

1. "What type is this?" → `lsp_hover`
2. "Where is this defined?" → `lsp_goto_definition`
3. "Who uses this?" → `lsp_find_references`
4. "Is this file valid?" → `lsp_diagnostics`
5. "Rename safely" → `lsp_prepare_rename` → `lsp_rename`
6. "Auto-fix available?" → `lsp_code_actions`

## Type Checking Workflow

1. Edit the file
2. Run `lsp_diagnostics` — pyright reports type errors immediately
3. If errors found → fix them, then re-run diagnostics
4. Use `lsp_hover` on complex expressions to verify inferred types

## Common Pitfalls

- Pyright may not detect virtualenv if `pyrightconfig.json` is missing `venvPath`
- `Any` types propagate silently — hover to check if a symbol resolved to `Any`
- Third-party stubs may be missing — diagnostics will show `reportMissingTypeStubs`
- Re-exports via `__init__.py` may confuse goto_definition — check `__all__`
