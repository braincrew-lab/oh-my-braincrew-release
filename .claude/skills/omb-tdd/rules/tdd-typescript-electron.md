# TDD for TypeScript / Electron

## Test File Structure

```
tests/
├── main/
│   ├── ipc-handlers.test.ts    # Main process IPC handler tests
│   ├── window-manager.test.ts  # Window creation and lifecycle tests
│   └── menu.test.ts            # Native menu tests
├── preload/
│   └── api.test.ts             # Preload bridge API tests
├── renderer/
│   ├── components/             # React component tests (use tdd-typescript-react.md)
│   └── hooks/
│       └── useIpc.test.ts      # IPC hook tests
└── mocks/
    ├── electron.ts             # Typed Electron mock
    └── ipc.ts                  # IPC channel mock
```

## Testing Main Process IPC Handlers

IPC handlers are pure functions that receive arguments and return results. Test them independently of Electron's IPC mechanism.

### Handler Function Pattern

```typescript
// src/main/handlers/file-handler.ts
export async function handleReadFile(
  _event: IpcMainInvokeEvent,
  filePath: string
): Promise<FileResult> {
  if (!isAllowedPath(filePath)) {
    throw new Error(`Access denied: ${filePath} is outside allowed directory`)
  }
  const content = await fs.readFile(filePath, "utf-8")
  return { content, path: filePath, size: content.length }
}
```

### RED — Test the handler directly

```typescript
import { handleReadFile } from "../src/main/handlers/file-handler"
import { vol } from "memfs"

vi.mock("fs/promises", () => vol.promises)

describe("handleReadFile", () => {
  const mockEvent = {} as IpcMainInvokeEvent

  beforeEach(() => {
    vol.reset()
    vol.fromJSON({
      "/allowed/data.txt": "file content here",
    })
  })

  it("should return file content for allowed paths", async () => {
    const result = await handleReadFile(mockEvent, "/allowed/data.txt")

    expect(result).toEqual({
      content: "file content here",
      path: "/allowed/data.txt",
      size: 17,
    })
  })

  it("should throw for paths outside allowed directory", async () => {
    await expect(
      handleReadFile(mockEvent, "/etc/passwd")
    ).rejects.toThrow("Access denied")
  })

  it("should throw for nonexistent files", async () => {
    await expect(
      handleReadFile(mockEvent, "/allowed/missing.txt")
    ).rejects.toThrow()
  })
})
```

## Testing IPC Channel Registration

```typescript
import { registerHandlers } from "../src/main/ipc-registry"

describe("IPC Registry", () => {
  const mockIpcMain = {
    handle: vi.fn(),
    on: vi.fn(),
    removeHandler: vi.fn(),
  }

  it("should register all expected channels", () => {
    registerHandlers(mockIpcMain as unknown as IpcMain)

    const registeredChannels = mockIpcMain.handle.mock.calls.map(
      ([channel]) => channel
    )

    expect(registeredChannels).toContain("file:read")
    expect(registeredChannels).toContain("file:write")
    expect(registeredChannels).toContain("settings:get")
    expect(registeredChannels).toContain("settings:set")
  })

  it("should not register dangerous channels", () => {
    registerHandlers(mockIpcMain as unknown as IpcMain)

    const registeredChannels = mockIpcMain.handle.mock.calls.map(
      ([channel]) => channel
    )

    expect(registeredChannels).not.toContain("shell:exec")
    expect(registeredChannels).not.toContain("eval")
  })
})
```

## Testing Preload API

The preload script exposes a typed API via `contextBridge`. Test the shape and validation.

```typescript
// Test that the exposed API matches the expected interface
import type { ElectronAPI } from "../src/preload/types"

describe("Preload API shape", () => {
  it("should expose only allowed methods", () => {
    const api: ElectronAPI = createPreloadAPI()

    // Expected methods exist
    expect(api.readFile).toBeTypeOf("function")
    expect(api.writeFile).toBeTypeOf("function")
    expect(api.getSettings).toBeTypeOf("function")

    // Dangerous methods do NOT exist
    expect(api).not.toHaveProperty("exec")
    expect(api).not.toHaveProperty("eval")
    expect(api).not.toHaveProperty("require")
  })
})
```

## Testing IPC Payload Validation

```typescript
describe("IPC Payload Validation", () => {
  it("should reject file:write with empty content", async () => {
    await expect(
      handleWriteFile(mockEvent, { path: "/allowed/file.txt", content: "" })
    ).rejects.toThrow("Content cannot be empty")
  })

  it("should reject file:write with path traversal", async () => {
    await expect(
      handleWriteFile(mockEvent, { path: "../../../etc/passwd", content: "hack" })
    ).rejects.toThrow("Access denied")
  })

  it("should reject oversized payloads", async () => {
    const largeContent = "x".repeat(10 * 1024 * 1024 + 1) // >10MB
    await expect(
      handleWriteFile(mockEvent, { path: "/allowed/file.txt", content: largeContent })
    ).rejects.toThrow("exceeds maximum")
  })
})
```

## Testing Window Management

```typescript
describe("WindowManager", () => {
  let mockBrowserWindow: MockedClass<typeof BrowserWindow>

  beforeEach(() => {
    mockBrowserWindow = vi.mocked(BrowserWindow)
    mockBrowserWindow.mockClear()
  })

  it("should create window with correct security settings", () => {
    createMainWindow()

    expect(mockBrowserWindow).toHaveBeenCalledWith(
      expect.objectContaining({
        webPreferences: expect.objectContaining({
          contextIsolation: true,
          nodeIntegration: false,
          sandbox: true,
        }),
      })
    )
  })

  it("should not show window until ready-to-show", () => {
    const window = createMainWindow()
    const onCalls = mockBrowserWindow.mock.instances[0].on.mock.calls

    // Window should register ready-to-show handler
    const readyHandler = onCalls.find(([event]) => event === "ready-to-show")
    expect(readyHandler).toBeDefined()

    // show should not be called before ready-to-show
    expect(mockBrowserWindow.mock.instances[0].show).not.toHaveBeenCalled()
  })
})
```

## Renderer Process Tests

For renderer process (React) components, follow `tdd-typescript-react.md`. Key differences for Electron:

### Testing useIpc Hook

```typescript
describe("useIpc", () => {
  const mockApi: ElectronAPI = {
    readFile: vi.fn(),
    writeFile: vi.fn(),
    getSettings: vi.fn(),
    onUpdate: vi.fn(),
    removeListener: vi.fn(),
  }

  beforeEach(() => {
    vi.stubGlobal("electronAPI", mockApi)
  })

  afterEach(() => {
    vi.unstubAllGlobals()
  })

  it("should call electronAPI.readFile and return content", async () => {
    mockApi.readFile = vi.fn<[string], Promise<FileResult>>()
      .mockResolvedValue({ content: "hello", path: "/file.txt", size: 5 })

    const { result } = renderHook(() => useReadFile("/file.txt"))

    await waitFor(() => expect(result.current.isSuccess).toBe(true))

    expect(result.current.data?.content).toBe("hello")
    expect(mockApi.readFile).toHaveBeenCalledWith("/file.txt")
  })

  it("should handle IPC errors gracefully", async () => {
    mockApi.readFile = vi.fn().mockRejectedValue(new Error("File not found"))

    const { result } = renderHook(() => useReadFile("/missing.txt"))

    await waitFor(() => expect(result.current.isError).toBe(true))

    expect(result.current.error?.message).toBe("File not found")
  })
})
```

## Rules

1. Test IPC handlers as pure functions — extract them from `ipcMain.handle` registration.
2. Test payload validation with malicious inputs — path traversal, oversized data, empty fields.
3. Verify security settings — `contextIsolation: true`, `nodeIntegration: false`, `sandbox: true`.
4. Test that only allowed IPC channels are registered — no shell exec, eval, or require exposure.
5. Use `memfs` for file system mocking — provides a typed, in-memory filesystem.
6. Test window lifecycle events — `ready-to-show`, `close`, `closed`.
7. Renderer tests follow React testing rules from `tdd-typescript-react.md`.
8. Mock `electronAPI` global with typed interface — never use `as any`.
