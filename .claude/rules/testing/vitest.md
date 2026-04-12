---
paths: ["tests/**/*.ts", "**/*.test.ts", "**/*.test.tsx", "**/*.spec.ts"]
---

# Vitest Conventions

## Structure
- Co-locate tests: `Component.tsx` → `Component.test.tsx` (same directory)
- Or mirror structure: `src/hooks/useAuth.ts` → `tests/hooks/useAuth.test.ts`
- Setup files in `vitest.setup.ts`

## Test Structure
```typescript
describe('ComponentName', () => {
  it('should render with default props', () => { ... });
  it('should handle user interaction', () => { ... });
  it('should show error state', () => { ... });
});
```

## React Testing
- Use `@testing-library/react`: `render`, `screen`, `userEvent`
- Query by role/label first, testId last: `screen.getByRole('button', { name: /submit/i })`
- Use `userEvent` over `fireEvent` for realistic interactions
- Test behavior, not implementation details
- Avoid testing internal state directly

## Mocking
- `vi.fn()` for function mocks
- `vi.mock('module')` for module mocks
- `vi.spyOn(obj, 'method')` for partial mocks
- Reset mocks: `afterEach(() => { vi.restoreAllMocks() })`

## Async
- Use `await` with `findBy*` queries for async rendering
- `waitFor(() => { ... })` for assertions that need to wait
- Mock API calls with `msw` (Mock Service Worker)

## Coverage
- Run: `vitest run --coverage`
- Target: 80%+ for components with business logic
