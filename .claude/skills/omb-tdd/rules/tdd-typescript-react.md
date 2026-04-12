# TDD for TypeScript / React

## Test File Structure

```
src/
├── components/
│   ├── UserCard.tsx
│   └── UserCard.test.tsx       # Co-located test
├── hooks/
│   ├── useAuth.ts
│   └── useAuth.test.ts         # Co-located test
├── pages/
│   └── Dashboard.tsx
└── __tests__/
    └── pages/
        └── Dashboard.test.tsx  # Page-level tests
```

## Setup

```typescript
// vitest.setup.ts
import "@testing-library/jest-dom/vitest"
import { cleanup } from "@testing-library/react"
import { afterEach } from "vitest"
import { server } from "./mocks/server"

beforeAll(() => server.listen({ onUnhandledRequest: "error" }))
afterEach(() => {
  cleanup()
  server.resetHandlers()
})
afterAll(() => server.close())
```

## RED-GREEN-IMPROVE Example

### RED — Failing test for a new component

```typescript
import { render, screen } from "@testing-library/react"
import userEvent from "@testing-library/user-event"
import { UserCard } from "./UserCard"

describe("UserCard", () => {
  const defaultUser = {
    id: 1,
    name: "Alice",
    email: "alice@example.com",
    role: "admin" as const,
  }

  it("should display user name and email", () => {
    render(<UserCard user={defaultUser} />)

    expect(screen.getByText("Alice")).toBeInTheDocument()
    expect(screen.getByText("alice@example.com")).toBeInTheDocument()
  })

  it("should show admin badge for admin users", () => {
    render(<UserCard user={defaultUser} />)

    expect(screen.getByRole("status", { name: /admin/i })).toBeInTheDocument()
  })

  it("should not show admin badge for regular users", () => {
    render(<UserCard user={{ ...defaultUser, role: "user" }} />)

    expect(screen.queryByRole("status", { name: /admin/i })).not.toBeInTheDocument()
  })

  it("should call onDelete when delete button is clicked", async () => {
    const onDelete = vi.fn()
    const user = userEvent.setup()

    render(<UserCard user={defaultUser} onDelete={onDelete} />)

    await user.click(screen.getByRole("button", { name: /delete/i }))

    expect(onDelete).toHaveBeenCalledWith(1)
  })
})
```

Run: `vitest run src/components/UserCard.test.tsx` — MUST fail (component does not exist yet).

### GREEN — Minimal implementation

```typescript
interface UserCardProps {
  user: User
  onDelete?: (id: number) => void
}

export function UserCard({ user, onDelete }: UserCardProps) {
  return (
    <div>
      <span>{user.name}</span>
      <span>{user.email}</span>
      {user.role === "admin" && <span role="status" aria-label="admin">Admin</span>}
      {onDelete && (
        <button onClick={() => onDelete(user.id)} aria-label="delete">
          Delete
        </button>
      )}
    </div>
  )
}
```

## Query Priority (Testing Library)

Use the most accessible query first. Falling back to `testId` is a last resort.

1. `getByRole` — buttons, links, headings, form elements
2. `getByLabelText` — form inputs with labels
3. `getByPlaceholderText` — inputs with placeholder
4. `getByText` — visible text content
5. `getByDisplayValue` — current value of form elements
6. `getByTestId` — last resort only

## Hook Testing

```typescript
import { renderHook, act, waitFor } from "@testing-library/react"
import { useCounter } from "./useCounter"

describe("useCounter", () => {
  it("should initialize with default value", () => {
    const { result } = renderHook(() => useCounter(0))
    expect(result.current.count).toBe(0)
  })

  it("should increment the counter", () => {
    const { result } = renderHook(() => useCounter(0))
    act(() => result.current.increment())
    expect(result.current.count).toBe(1)
  })
})
```

### Async Hook Testing

```typescript
describe("useUser", () => {
  it("should fetch and return user data", async () => {
    server.use(
      http.get("/api/users/1", () => {
        return HttpResponse.json({ id: 1, name: "Alice", email: "alice@test.com" })
      })
    )

    const { result } = renderHook(() => useUser(1), {
      wrapper: QueryClientProvider,
    })

    await waitFor(() => expect(result.current.isSuccess).toBe(true))

    expect(result.current.data).toEqual({
      id: 1,
      name: "Alice",
      email: "alice@test.com",
    })
  })

  it("should return error state on API failure", async () => {
    server.use(
      http.get("/api/users/1", () => {
        return new HttpResponse(null, { status: 500 })
      })
    )

    const { result } = renderHook(() => useUser(1), {
      wrapper: QueryClientProvider,
    })

    await waitFor(() => expect(result.current.isError).toBe(true))
  })
})
```

## API Mocking with MSW

Use MSW (Mock Service Worker) for all API mocking. Do NOT use `vi.mock("axios")` or `vi.mock("fetch")`.

```typescript
// mocks/handlers.ts
import { http, HttpResponse } from "msw"

export const handlers = [
  http.get("/api/users", () => {
    return HttpResponse.json([
      { id: 1, name: "Alice", email: "alice@test.com" },
      { id: 2, name: "Bob", email: "bob@test.com" },
    ])
  }),

  http.post("/api/users", async ({ request }) => {
    const body = await request.json()
    return HttpResponse.json(
      { id: 3, ...body },
      { status: 201 }
    )
  }),
]

// mocks/server.ts
import { setupServer } from "msw/node"
import { handlers } from "./handlers"
export const server = setupServer(...handlers)
```

### Override handlers per test

```typescript
it("should show error message on API failure", async () => {
  server.use(
    http.get("/api/users", () => {
      return new HttpResponse(null, { status: 500 })
    })
  )

  render(<UserList />)

  await waitFor(() => {
    expect(screen.getByRole("alert")).toHaveTextContent(/failed to load/i)
  })
})
```

## Form Testing

```typescript
describe("LoginForm", () => {
  it("should submit with valid credentials", async () => {
    const onSubmit = vi.fn()
    const user = userEvent.setup()

    render(<LoginForm onSubmit={onSubmit} />)

    await user.type(screen.getByLabelText(/email/i), "alice@test.com")
    await user.type(screen.getByLabelText(/password/i), "SecurePass123!")
    await user.click(screen.getByRole("button", { name: /sign in/i }))

    expect(onSubmit).toHaveBeenCalledWith({
      email: "alice@test.com",
      password: "SecurePass123!",
    })
  })

  it("should show validation error for empty email", async () => {
    const user = userEvent.setup()

    render(<LoginForm onSubmit={vi.fn()} />)

    await user.click(screen.getByRole("button", { name: /sign in/i }))

    expect(screen.getByText(/email is required/i)).toBeInTheDocument()
  })
})
```

## Rules

1. Use `userEvent` over `fireEvent` — `userEvent` simulates real browser interactions.
2. Query by role and accessible name first — `getByRole("button", { name: /submit/i })`.
3. Use MSW for API mocking — intercepts at the network level, not the module level.
4. Test loading, success, and error states for async components.
5. Test form validation with empty, invalid, and valid inputs.
6. Use `waitFor` for async assertions — do not use `setTimeout` or `sleep`.
7. Reset handlers after each test — `server.resetHandlers()` in `afterEach`.
8. Create a shared `QueryClientProvider` wrapper for TanStack Query hooks.
9. Never test implementation details (internal state, effect execution) — test visible behavior.
