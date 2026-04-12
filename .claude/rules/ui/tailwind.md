---
paths: ["**/*.tsx", "**/*.css", "tailwind.config.*"]
---

# Tailwind CSS Conventions

## Utility-First
- Use Tailwind utility classes as the primary styling method
- No inline `style` attributes — use utilities or custom classes
- Extract repeated patterns into components, not CSS classes
- Use `@apply` sparingly — only in base/component layers for truly global styles

## Design Tokens
- Define colors, spacing, fonts in `tailwind.config` — never use arbitrary values
- Use semantic color names (`primary`, `destructive`) not raw colors (`blue-500`)
- Extend the default theme rather than overriding it entirely
- Keep custom values in the theme config, not as arbitrary `[values]`

## Responsive Design
- Mobile-first: base styles for mobile, then `sm:`, `md:`, `lg:`, `xl:`
- Breakpoints: `sm` (640px), `md` (768px), `lg` (1024px), `xl` (1280px)
- Test all breakpoints — do not assume desktop-only usage
- Use container queries (`@container`) for component-level responsiveness

## Dark Mode
- Use `dark:` variant for dark mode styles
- Define dark mode colors in the theme config
- Test both modes — never leave dark mode unstyled
- Prefer CSS variables for theme switching

## Class Organization
- Order: layout > sizing > spacing > typography > colors > effects > states
- Use `clsx` or `cn` utility for conditional classes
- Keep class strings readable — break long lists across lines
- Group related utilities with comments if the list exceeds 10 classes
