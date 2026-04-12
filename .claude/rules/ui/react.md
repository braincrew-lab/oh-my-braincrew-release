---
paths: ["src/components/**", "src/pages/**", "src/hooks/**", "src/app/**/*.tsx"]
---

# React Conventions

## Component Structure
- Use functional components exclusively — no class components
- One component per file, named export matching filename
- Colocate component, styles, types, and tests in the same directory
- Extract reusable logic into custom hooks (`use<Name>`)

## Hooks Rules
- Never call hooks conditionally or inside loops
- Custom hooks must start with `use`
- Keep hooks focused — one concern per hook
- Prefer `useReducer` over `useState` for complex state logic

## State Management
- Local state: `useState` / `useReducer`
- Shared state: context or state management library (Zustand, Jotai)
- Server state: TanStack Query (React Query) — do not store server data in local state
- Derive values in render — do not duplicate state

## Props and Types
- Define props with TypeScript interfaces, not inline types
- Use `children: React.ReactNode` for wrapper components
- Destructure props in function signature
- Provide default values where sensible

## Performance
- Use `React.memo` only for expensive renders with stable props
- Use `useCallback` for callbacks passed to memoized children
- Use `useMemo` for expensive computations, not for every value
- Avoid creating objects/arrays inline in JSX (causes re-renders)

## Error Boundaries
- Wrap route-level components with error boundaries
- Display fallback UI — never show a blank screen
- Log errors to monitoring service in `componentDidCatch`
