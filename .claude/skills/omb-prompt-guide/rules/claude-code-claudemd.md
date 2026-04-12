---
title: Write an Effective CLAUDE.md
impact: HIGH
impactDescription: Persistent context that shapes every session
tags: claude-code, claudemd, configuration, conventions
---

## Write an Effective CLAUDE.md

CLAUDE.md loads every session, so it shapes all Claude Code behavior. Include only what Claude cannot infer from code: build commands, testing conventions, project-specific rules, and non-obvious behaviors. Bloated CLAUDE.md files cause Claude to ignore your actual instructions.

Test with: "Would removing this line cause Claude to make mistakes?" If not, cut it. Treat CLAUDE.md like code — review when things go wrong, prune regularly.

**Incorrect (bloated with self-evident information):**

```markdown
# CLAUDE.md
- Write clean code
- Use meaningful variable names
- Follow JavaScript best practices
- Use TypeScript for type safety
- Use React functional components
- Always test your code
- Files are in the src/ directory
- The project uses npm for package management
```

**Correct (only non-obvious, high-leverage rules):**

```markdown
# CLAUDE.md

## Build & Test
- `npm run test:unit -- --filter=<path>` for single-file tests (faster)
- `npm run typecheck` after code changes (must pass before commit)

## Code Style
- Use ES modules (import/export), not CommonJS (require)
- Destructure imports: `import { foo } from 'bar'`

## Gotchas
- Auth tokens expire after 15min in dev; use `npm run auth:refresh`
- The legacy /v1 API uses snake_case; /v2 uses camelCase
```

**Key principles:**
- Include Bash commands Claude can't guess
- Include rules that differ from defaults
- Exclude anything Claude figures out by reading code
- Exclude standard language conventions
- Use emphasis (IMPORTANT, YOU MUST) sparingly for critical rules
- Check CLAUDE.md into git; the file compounds in value

Reference: [Claude Code Best Practices — CLAUDE.md](https://code.claude.com/docs/en/best-practices)
