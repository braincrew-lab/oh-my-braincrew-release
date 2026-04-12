---
paths: ["src/components/**", "src/pages/**"]
---

# UI Patterns

## Forms
- Controlled components with React Hook Form or native useState
- Validation on submit AND on blur for critical fields
- Inline error messages below the field, not in alerts
- Disable submit button during API calls (prevent double submit)
- Show loading indicator on submit button

## Lists & Tables
- Virtualize lists > 100 items (react-window or @tanstack/virtual)
- Pagination or infinite scroll for large datasets
- Empty state with illustration and action prompt
- Loading skeleton, not spinner, for content areas

## Loading States
- Skeleton loader for initial data fetch (preserves layout)
- Inline spinner for actions (button click, form submit)
- Progress bar for multi-step or long operations
- Optimistic updates for instant-feel interactions

## Error States
- Inline errors near the failed component, not global alerts
- Retry button for recoverable errors
- Fallback UI (error boundary) for unrecoverable crashes
- Error messages: what happened + what to do next

## Toast Notifications
- Success: auto-dismiss after 3-5 seconds
- Error: persist until dismissed
- Max 3 visible toasts at once
- Position: top-right or bottom-right, consistent across app
