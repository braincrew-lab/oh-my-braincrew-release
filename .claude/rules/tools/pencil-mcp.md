---
description: Pencil MCP design tool usage for .pen visual design files
---

# Pencil MCP Usage

## Availability Detection

Call `mcp__pencil__get_editor_state({ include_schema: false })` at the start of execution.
- **Success**: Pencil is active. Follow the visual-first workflow.
- **Error**: Pencil is unavailable. Fall back to text-only design specs.

## Tool Decision Tree

| Question | Tool | Notes |
|----------|------|-------|
| What's the current editor state? | `get_editor_state` | Call with `include_schema: true` for full schema |
| Open or create a .pen file | `open_document` | Pass `'new'` for new canvas, file path for existing |
| Read design structure | `batch_get` | Search by patterns or node IDs |
| Create/modify design elements | `batch_design` | Max 25 operations per call |
| Load design system rules | `get_guidelines` | Call BEFORE first design operation |
| Capture visual snapshot | `get_screenshot` | Render a node to PNG for review |
| Export to image/code | `export_nodes` | PNG, JPEG, WEBP, or PDF |
| Read design tokens | `get_variables` | Colors, spacing, typography values |
| Set design tokens | `set_variables` | Update document-wide variables |
| Get layout with computed bounds | `snapshot_layout` | Structure + positioning data |
| Find space for new elements | `find_empty_space_on_canvas` | Avoid overlapping existing content |
| Search properties recursively | `search_all_unique_properties` | Discover patterns in node tree |
| Bulk property replacement | `replace_all_matching_properties` | Apply changes across matching nodes |

## File Convention

All .pen design files MUST be stored in the `designs/` folder at project root:

```
designs/
├── 2026-04-11-login-page.pen
├── 2026-04-11-dashboard-sidebar.pen
├── 2026-04-12-settings-modal.pen
```

**Naming format**: `YYYY-MM-DD-descriptive-kebab-name.pen`

- Date is the creation date (use today's date)
- Name describes the feature or component being designed
- If a .pen file is found outside `designs/`, recommend moving it there

## Design-First Workflow

When Pencil MCP is available, visual design is the PRIMARY artifact:

1. **Load guidelines**: Call `get_guidelines()` to load the design system before any design work.
2. **Create .pen file**: Call `open_document('designs/YYYY-MM-DD-name.pen')` with the correct naming convention.
3. **Design visually**: Use `batch_design()` to create the component tree:
   - Use Pencil's component/instance system (`reusable: true` + `ref`) for reusable elements
   - Use flexbox layout properties (`layout`, `justifyContent`, `alignItems`) for responsive behavior
   - Use variables for design tokens (colors, spacing, typography) that map to Tailwind theme
   - Use themes for light/dark mode and responsive variants
4. **Capture for review**: Call `get_screenshot()` to generate a visual snapshot.
5. **Capture layout data**: Call `snapshot_layout()` to record computed bounds and constraints.
6. **Reference in spec**: Include the .pen file path in the text-based design spec.

## Design-to-Code Extraction

When implementing from a .pen design:

1. `open_document("[path]")` — open the approved design
2. `batch_get({ patterns: ["*"] })` — read the full component tree
3. `get_variables()` — read design tokens (colors, spacing, typography)
4. Map Pencil variables to Tailwind classes/tokens
5. Optionally use `export_nodes()` for code generation — review and adapt to project conventions

## Key Constraints

- **[HARD] Never use Read, Grep, or Glob to read .pen files** — .pen file contents are encrypted and only accessible via Pencil MCP tools. Non-MCP tools return unusable data.
- **[HARD] Max 25 operations per `batch_design` call** — split larger designs across multiple calls.
- **[HARD] Call `get_guidelines()` before first design** — loads the design system context needed for consistent output.
- **[HARD] Follow the `designs/YYYY-MM-DD-name.pen` naming convention** — centralizes designs for easy discovery.

## When to Use Pencil vs Text-Only

| Scenario | Approach |
|----------|----------|
| New component or page design | Pencil (visual-first) |
| Visual layout decisions | Pencil (visual-first) |
| Design system alignment | Pencil (token mapping) |
| Simple prop addition | Text-only |
| Bug fix with no visual change | Text-only |
| Refactor with no UI change | Text-only |
