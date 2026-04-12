---
name: omb-lsp-css
description: "CSS/Tailwind LSP patterns — tailwindcss-language-server class resolution, design token lookup, and @apply navigation."
---

# CSS / Tailwind LSP Guide

## When to Use LSP (vs Grep/Read)

- **Class info** → `lsp_hover` on Tailwind class (shows generated CSS)
- **Find definition** → `lsp_goto_definition` on custom properties or @apply classes
- **Impact analysis** → `lsp_find_references` on CSS custom properties
- **Validation** → `lsp_diagnostics` (invalid classes, syntax errors)
- **Quick fixes** → `lsp_code_actions` for class suggestions

## CSS-Specific Patterns

- **Tailwind classes**: hover on `bg-blue-500` shows the generated CSS rules
- **Design tokens**: hover on `var(--color-primary)` shows resolved value
- **@apply resolution**: goto_definition on `@apply flex` jumps to utility definition
- **Custom properties**: find_references on `--spacing-lg` shows all usage sites
- **Theme values**: hover on theme function `theme('colors.blue.500')` shows value
- **Class conflicts**: diagnostics flags conflicting Tailwind utilities

## Decision Tree

1. "What CSS does this class generate?" → `lsp_hover`
2. "Where is this custom property defined?" → `lsp_goto_definition`
3. "Who uses this CSS variable?" → `lsp_find_references`
4. "Is this class valid?" → `lsp_diagnostics`
5. "Fix invalid class?" → `lsp_code_actions`

## Tailwind Workflow

1. Write Tailwind classes in JSX/HTML
2. Hover on classes to verify generated CSS matches intent
3. Run `lsp_diagnostics` to catch invalid or misspelled classes
4. Use code_actions for class sorting and conflict resolution

## Design Token Workflow

1. Define tokens as CSS custom properties in `:root` or theme config
2. Use `lsp_find_references` on a token to audit usage across files
3. Hover on `var()` references to check resolved values
4. Rename tokens with `lsp_rename` for safe cross-file updates

## Common Pitfalls

- tailwindcss-language-server needs `tailwind.config.js/ts` at workspace root
- Custom plugins and dynamic classes may not be recognized by the LSP
- CSS modules (`.module.css`) scoping can confuse find_references
- `@apply` with complex selectors may not resolve correctly
- Hover in JSX requires the server to understand the `className` prop context
