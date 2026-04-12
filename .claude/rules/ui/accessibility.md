---
paths: ["src/components/**", "src/pages/**"]
---

# Accessibility (a11y) Rules

## Semantic HTML
- Use semantic elements: `<nav>`, `<main>`, `<article>`, `<section>`, `<aside>`
- Use heading hierarchy (`h1` > `h2` > `h3`) — never skip levels
- Use `<button>` for actions, `<a>` for navigation — never the reverse
- Use `<ul>`/`<ol>` for lists, `<table>` for tabular data

## ARIA Labels
- Every interactive element must have an accessible name
- Use `aria-label` when visible text is insufficient
- Use `aria-labelledby` to reference existing visible text
- Use `aria-describedby` for supplementary descriptions
- Use `role` only when no semantic HTML element fits

## Keyboard Navigation
- All interactive elements must be reachable via Tab key
- Logical tab order — follows visual layout (avoid positive `tabindex`)
- Custom widgets must implement arrow-key navigation per WAI-ARIA patterns
- Escape key must close modals, dropdowns, and popovers

## Focus Management
- Visible focus indicator on all interactive elements (never `outline: none`)
- Trap focus inside modals while open
- Return focus to trigger element when modal/dialog closes
- Use `aria-live` regions for dynamic content updates

## Color and Contrast
- Minimum contrast ratio: 4.5:1 for normal text, 3:1 for large text
- Never convey information by color alone — use icons, text, or patterns
- Test with color blindness simulators

## Testing
- Run axe-core or Lighthouse accessibility audit
- Test with screen reader (VoiceOver, NVDA)
- Test with keyboard-only navigation
- Verify focus order matches visual order
