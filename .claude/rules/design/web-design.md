---
paths: ["src/components/**", "src/pages/**", "src/styles/**"]
---

# Web Design Conventions

## Visual Hierarchy
- Size and weight establish primary → secondary → tertiary content
- Limit to 2-3 font sizes per view
- Use whitespace to group related elements

## Spacing Scale
- Use Tailwind's spacing scale (4px base): 1, 2, 3, 4, 6, 8, 12, 16
- Consistent padding within components
- Larger margins between sections than within sections

## Color System
- Primary: brand actions (buttons, links, focus rings)
- Neutral: text, borders, backgrounds (gray scale)
- Semantic: success (green), warning (amber), error (red), info (blue)
- Max 2 accent colors beyond neutral
- Ensure WCAG AA contrast (4.5:1 for text, 3:1 for large text)

## Typography
- System font stack for body, monospace for code
- Max 3 font weights per page (regular, medium, bold)
- Line height: 1.5 for body text, 1.2 for headings

## Responsive Breakpoints
- Mobile-first: design for small screens, enhance for larger
- Tailwind breakpoints: sm (640px), md (768px), lg (1024px), xl (1280px)
- Test at each breakpoint, not just desktop

## Motion
- Transitions: 150-200ms for micro-interactions
- Ease-out for entrances, ease-in for exits
- Reduce motion: respect `prefers-reduced-motion`
- No animation on initial page load content
