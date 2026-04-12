# Project Stack Conventions

Language-specific rules (tooling, MUST/MUST NOT, file conventions, testing) are in `.claude/rules/languages/`. This file covers project-specific stack choices only.

## Python / Backend
- FastAPI with async endpoints
- Pydantic v2 for request/response models
- SQLAlchemy 2.0 async + Alembic for migrations

## TypeScript / Frontend
- React functional components with hooks
- Tailwind CSS for styling, no inline styles
- Path aliases via tsconfig
- Test framework: vitest + @testing-library/react

## Node.js
- Express or Fastify with TypeScript
- Structured error handling middleware

## Electron
- Context isolation enabled, nodeIntegration disabled
- IPC via preload scripts only
- Main/renderer separation enforced

## General
- No secrets in code — use environment variables
- Prefer composition over inheritance
- Prefer immutable data structures — use `const`/`final`/`frozen`/`readonly` by default, mutate only when performance requires it
- Small, focused functions (< 50 lines)
- Small, focused files — 200-400 lines typical, 800 lines absolute maximum. Split before you exceed
- Meaningful names — no abbreviations except well-known ones (db, api, auth, config)
- Error messages must be actionable
