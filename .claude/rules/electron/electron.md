---
paths: ["src/electron/**", "electron/**", "src/main/**", "src/renderer/**", "src/preload/**"]
---

# Electron Conventions

## Context Isolation (MANDATORY)
- `contextIsolation: true` — always enabled, never disable
- `nodeIntegration: false` — never enable in renderer
- `sandbox: true` — enable for all renderer processes
- All Node.js access goes through preload scripts only

## Preload Scripts
- Expose minimal API surface via `contextBridge.exposeInMainWorld`
- Type the exposed API with shared TypeScript interfaces
- Never expose raw Node.js modules (`fs`, `child_process`, etc.)
- Validate all data passed through the bridge

## IPC Patterns
- Use `ipcMain.handle` / `ipcRenderer.invoke` for request-response
- Use `ipcMain.on` / `webContents.send` for main-to-renderer pushes
- Define channel names as constants in a shared module
- Validate and sanitize all IPC message payloads
- Never pass unsanitized user input to shell commands via IPC

## Window Management
- Define window options in a factory function, not inline
- Set minimum window size with `minWidth` / `minHeight`
- Restore window bounds from persisted state on launch
- Handle `close` event for save-before-quit flows

## Content Security Policy
- Set CSP headers via `session.defaultSession.webRequest`
- Restrict `script-src` to `'self'` — no `unsafe-inline` or `unsafe-eval`
- Block remote code loading in production
- Allow dev server URLs only in development mode

## Security Checklist
- Do not load remote URLs without URL validation
- Disable `webSecurity` only in development, never in production
- Use `safeStorage` for storing sensitive data locally
- Keep Electron updated — security patches are critical
