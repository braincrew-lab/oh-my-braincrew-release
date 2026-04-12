---
name: omb-ci-typescript
description: "Generate GitHub Actions workflows for TypeScript projects — tsc, eslint, vitest, build, Docker."
user-invocable: true
argument-hint: "[project name or path]"
---

# CI/CD Workflow Generator for TypeScript Projects

Generate a production-ready GitHub Actions workflow for a TypeScript project. The workflow covers type checking, linting, testing, building, and optional Docker build.

## Workflow Template

Create `.github/workflows/ci.yml` with the following structure:

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  lint-and-type-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "22"

      - name: Cache node_modules
        uses: actions/cache@v4
        with:
          path: node_modules
          key: ${{ runner.os }}-node-22-${{ hashFiles('package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-node-22-

      - name: Install dependencies
        run: npm ci

      - name: Type check
        run: npx tsc --noEmit

      - name: Lint
        run: npx eslint .

  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: ["20", "22"]
    steps:
      - uses: actions/checkout@v4

      - name: Set up Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}

      - name: Cache node_modules
        uses: actions/cache@v4
        with:
          path: node_modules
          key: ${{ runner.os }}-node-${{ matrix.node-version }}-${{ hashFiles('package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-node-${{ matrix.node-version }}-

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npx vitest run --coverage

      - name: Upload coverage
        if: matrix.node-version == '22'
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: coverage/

  build:
    runs-on: ubuntu-latest
    needs: [lint-and-type-check, test]
    steps:
      - uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "22"

      - name: Cache node_modules
        uses: actions/cache@v4
        with:
          path: node_modules
          key: ${{ runner.os }}-node-22-${{ hashFiles('package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-node-22-

      - name: Install dependencies
        run: npm ci

      - name: Build
        run: npm run build

  docker:
    runs-on: ubuntu-latest
    needs: [build]
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build Docker image
        uses: docker/build-push-action@v6
        with:
          context: .
          push: false
          tags: ${{ github.repository }}:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

## Instructions

When the user invokes this skill:

1. **Identify the project** — Look at the argument for a project name or path. If none given, use the current working directory.
2. **Inspect the project** — Check for `package.json`, `tsconfig.json`, lock files, and test config to determine the setup.
3. **Adapt the template** based on findings:
   - If `pnpm-lock.yaml` exists, switch to `pnpm install --frozen-lockfile` and cache `~/.pnpm-store`.
   - If `yarn.lock` exists, switch to `yarn install --frozen-lockfile` and cache `.yarn/cache`.
   - If `bun.lockb` exists, switch to Bun setup action and `bun install`.
   - If using Jest instead of Vitest, switch test command to `npx jest --coverage`.
   - If using Biome instead of ESLint, switch lint command to `npx biome check .`.
4. **Adjust Node versions** — Check `engines.node` in `package.json` if present.
5. **Docker step** — Include only if a `Dockerfile` exists in the project root.
6. **Write the file** to `.github/workflows/ci.yml` in the target project.
7. **Report** what was generated and any customizations applied.

## Customization Notes

- For Next.js projects, add `next build` and consider adding Lighthouse CI.
- For monorepos (Turborepo/Nx), use `npx turbo run lint test build` or `npx nx affected`.
- Add `services:` block for projects needing databases in tests.
- Add secrets for Docker registry push or npm publish.
- For Playwright/Cypress e2e tests, add a separate job with browser installation.
