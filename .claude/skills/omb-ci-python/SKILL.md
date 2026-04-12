---
name: omb-ci-python
description: "Generate GitHub Actions workflows for Python projects — pytest, ruff, pyright, coverage, Docker build."
user-invocable: true
argument-hint: "[project name or path]"
---

# CI/CD Workflow Generator for Python Projects

Generate a production-ready GitHub Actions workflow for a Python project. The workflow covers linting, type checking, testing with coverage, and optional Docker build.

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

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - name: Cache pip
        uses: actions/cache@v4
        with:
          path: ~/.cache/pip
          key: ${{ runner.os }}-pip-${{ hashFiles('**/pyproject.toml', '**/requirements*.txt') }}
          restore-keys: |
            ${{ runner.os }}-pip-

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -e ".[dev]"

      - name: Lint with ruff
        run: ruff check .

      - name: Format check with ruff
        run: ruff format --check .

      - name: Type check with pyright
        run: pyright

  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.11", "3.12", "3.13"]
    steps:
      - uses: actions/checkout@v4

      - name: Set up Python ${{ matrix.python-version }}
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - name: Cache pip
        uses: actions/cache@v4
        with:
          path: ~/.cache/pip
          key: ${{ runner.os }}-pip-${{ matrix.python-version }}-${{ hashFiles('**/pyproject.toml', '**/requirements*.txt') }}
          restore-keys: |
            ${{ runner.os }}-pip-${{ matrix.python-version }}-

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -e ".[dev]"

      - name: Run tests with coverage
        run: pytest --cov=src --cov-report=xml --cov-report=term-missing

      - name: Upload coverage
        if: matrix.python-version == '3.12'
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: coverage.xml

  docker:
    runs-on: ubuntu-latest
    needs: [lint-and-type-check, test]
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
2. **Inspect the project** — Check for `pyproject.toml`, `setup.py`, `requirements.txt`, or `setup.cfg` to determine the dependency installation method.
3. **Adapt the template** based on findings:
   - If `pyproject.toml` with `[project.optional-dependencies]` has a `dev` group, use `pip install -e ".[dev]"`.
   - If `requirements-dev.txt` exists, use `pip install -r requirements-dev.txt`.
   - If using Poetry, switch to `poetry install` and adjust caching to `~/.cache/pypoetry`.
   - If using uv, switch to `uv sync` and adjust accordingly.
4. **Adjust Python versions** — Match the `requires-python` field from `pyproject.toml` if present.
5. **Docker step** — Include only if a `Dockerfile` exists in the project root.
6. **Write the file** to `.github/workflows/ci.yml` in the target project.
7. **Report** what was generated and any customizations applied.

## Customization Notes

- Add `services:` block for database-dependent tests (e.g., PostgreSQL, Redis).
- Add secrets for Docker registry push (`docker/login-action`).
- Add `codecov/codecov-action` for coverage reporting if the project uses Codecov.
- For monorepos, add `paths:` filter to the trigger to scope to the Python subdirectory.
