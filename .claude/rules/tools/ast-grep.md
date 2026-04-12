---
paths: ["**/*.py", "**/*.ts", "**/*.tsx"]
---

# AST-grep Usage

Use `ast_grep_search` for structural code patterns where text-based grep is insufficient.

## When to Use AST-grep vs Grep
- **AST-grep**: function signatures, class definitions, decorator usage, structural refactoring
- **Grep**: imports, string literals, comments, simple text patterns

## Meta-variable Syntax
- `$NAME` — matches a single AST node (identifier, expression)
- `$$$` — matches zero or more nodes (variadic, like function body or args)

## Common Python Patterns
- All async functions: `async def $NAME($$$): $$$`
- FastAPI routes: `@router.$METHOD($PATH)`
- Pydantic models: `class $NAME(BaseModel): $$$`
- Pytest functions: `def test_$NAME($$$): $$$`
- Depends injection: `Depends($FUNC)`

## Common TypeScript Patterns
- React components: `export function $NAME($PROPS) { $$$ }`
- Hooks: `function use$NAME($$$) { $$$ }`
- Arrow components: `export const $NAME = ($PROPS) => { $$$ }`
- Type definitions: `type $NAME = $$$`
- Interface: `interface $NAME { $$$ }`

## Refactoring with ast_grep_replace
Use for safe structural transformations:
- Rename patterns across files
- Update function signatures
- Transform decorator usage
- Migrate API patterns
