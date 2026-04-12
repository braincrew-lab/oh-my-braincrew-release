---
description: Chrome browser verification tools for visual UI testing via Claude in Chrome MCP
---

# Chrome Browser Verification

## Availability Detection

Call `mcp__claude-in-chrome__tabs_context_mcp` at the start of verification.
- **Success**: Chrome is active. Run browser verification checks after CLI checks.
- **Error**: Chrome is unavailable. Report browser checks as SKIPPED and rely on CLI-only verification.

## Tool Decision Tree

| Question | Tool | Notes |
|----------|------|-------|
| Get current tab context | `tabs_context_mcp` | Always call first to get fresh tab IDs |
| Open a new tab | `tabs_create_mcp` | Create new tabs for testing |
| Navigate to a URL | `navigate` | Go to localhost or any URL |
| Read page DOM structure | `read_page` | Inspect rendered HTML elements |
| Get page text content | `get_page_text` | Extract visible text from the page |
| Run JavaScript in page | `javascript_tool` | Execute scripts (axe-core, DOM queries) |
| Read console output | `read_console_messages` | Check for errors/warnings; use `pattern` to filter |
| Click, type, interact | `computer` | Mouse clicks, keyboard input, screenshots |
| Find elements on page | `find` | Locate specific elements by text or selector |
| Fill form fields | `form_input` | Enter data into form inputs |
| Resize browser window | `resize_window` | Test responsive breakpoints |
| Record interaction GIF | `gif_creator` | Document visual verification for review |

## Verification Workflow

Run browser checks AFTER all CLI checks (tsc, eslint, vitest) pass. Browser checks supplement — never replace — automated checks.

### Step 1: Dev Server Check
Navigate to the project's dev URL (default: `http://localhost:3000`).
- If navigation fails: report ALL Chrome checks as **BLOCKED** and stop browser verification.
- Do NOT treat a missing dev server as a code FAIL.

### Step 2: Navigate to Target Page
Go to the page containing the implemented component(s).

### Step 3: Visual Inspection
Call `read_page` to get the DOM structure. Verify:
- Component hierarchy matches the design spec
- Key elements are present and visible
- Layout structure is correct (flex/grid containers, proper nesting)

### Step 4: Console Errors
Call `read_console_messages` with a pattern filter (e.g., `"error|warning|Error"`) to check for:
- Runtime errors or unhandled promise rejections
- React warnings (missing keys, invalid prop types)
- Network request failures
- Any error is a FAIL finding.

### Step 5: Responsive Verification
Use `resize_window` to test at standard breakpoints:
- **Mobile**: 375x812
- **Tablet**: 768x1024
- **Desktop**: 1280x800

At each size, call `read_page` to verify layout adapts correctly.

### Step 6: Interaction Testing (if applicable)
Use `form_input` and `computer` to test:
- Form submissions and validation
- Button clicks and navigation
- Modal open/close behavior
- Keyboard navigation (Tab, Enter, Escape)

### Step 7: Accessibility in Browser
Use `javascript_tool` to run in-browser accessibility checks:
- If axe-core is loaded: `JSON.stringify(await axe.run())`
- Otherwise: inspect ARIA attributes, focus order, and color contrast via DOM queries

### Step 8: Design Fidelity (if .pen design exists)
Compare the rendered output against the Pencil design spec:
- Check spacing, colors, typography
- Verify component structure matches design tree
- Use `get_screenshot` from Pencil MCP alongside browser screenshots for comparison

## Reporting Format

Report Chrome findings using this format:

```
[browser:visual]      [FAIL] Layout mismatch: sidebar width is 300px, design spec says 256px
[browser:console]     [FAIL] Unhandled promise rejection in ProductList component
[browser:responsive]  [WARN] Mobile layout wraps awkwardly at 375px — text truncation missing
[browser:interaction] [FAIL] Submit button has no keyboard focus indicator
[browser:a11y]        [FAIL] Missing aria-label on search input
[browser:fidelity]    [WARN] Color #334155 used instead of design token $color.text (#333333)
```

Categories: `visual`, `console`, `responsive`, `interaction`, `a11y`, `fidelity`

## Key Constraints

- **[HARD] Chrome checks are supplementary** — they do NOT replace tsc, eslint, or vitest. A passing browser check cannot override a failing CLI check.
- **[HARD] BLOCKED, not FAIL, if no dev server** — missing dev server is an environment issue, not a code issue.
- **[HARD] SKIPPED if Chrome unavailable** — never fail a verification because Chrome was not connected.
- **[HARD] Read-only constraint still applies** — do not modify code during browser verification.
- Avoid triggering JavaScript alerts/confirms/prompts — they block the browser extension.
- Use `pattern` parameter with `read_console_messages` to filter verbose output.
- Always call `tabs_context_mcp` first to get fresh tab IDs — never reuse IDs from prior sessions.

## When to Use Chrome vs CLI-Only

| Scenario | Approach |
|----------|----------|
| Visual layout verification | Chrome |
| Form interaction testing | Chrome |
| Console error detection | Chrome |
| Responsive breakpoint testing | Chrome |
| Design fidelity comparison | Chrome + Pencil |
| Type checking | CLI only (tsc) |
| Lint rules | CLI only (eslint) |
| Unit test coverage | CLI only (vitest) |
| Static code analysis | CLI only |
