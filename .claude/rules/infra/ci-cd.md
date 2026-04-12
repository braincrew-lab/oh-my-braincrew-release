---
paths: [".github/workflows/**", ".github/actions/**"]
---

# GitHub Actions CI/CD Conventions

## Job Naming
- Use descriptive job names: `lint`, `test`, `build`, `deploy-staging`
- Use `name:` field for human-readable display in GitHub UI
- Prefix reusable workflows with `reusable-`

## Caching
- Cache dependency installations (`actions/cache` or built-in caching)
- Use lockfile hash as cache key: `hashFiles('**/package-lock.json')`
- Cache Docker layers with `docker/build-push-action` cache options
- Cache build artifacts between jobs with `actions/upload-artifact`

## Secret Management
- Store secrets in GitHub repository or organization secrets
- Never echo or log secret values
- Use `GITHUB_TOKEN` for repo-scoped operations — avoid PATs
- Rotate secrets on a schedule

## Matrix Strategy
- Use matrix for multi-version testing: `matrix: { node: [18, 20] }`
- Use `fail-fast: false` when you want all matrix combinations to complete
- Keep matrix dimensions minimal — avoid combinatorial explosion

## Concurrency
- Set `concurrency` to cancel in-progress runs on the same branch
- Use `concurrency.cancel-in-progress: true` for PR workflows
- Protect production deploys with `environment` and approval gates

## Artifact Handling
- Upload test results and coverage reports as artifacts
- Set retention days appropriate to the artifact type
- Use artifacts to pass data between jobs, not caching

## Best Practices
- Pin action versions to full SHA, not tags: `actions/checkout@<sha>`
- Run linting and type checks before tests (fail fast)
- Separate CI (test on PR) from CD (deploy on merge)
