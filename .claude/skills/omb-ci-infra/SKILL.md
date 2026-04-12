---
name: omb-ci-infra
description: "Generate GitHub Actions workflows for infrastructure — Terraform, Docker, Helm, actionlint."
user-invocable: true
argument-hint: "[project name or path]"
---

# CI/CD Workflow Generator for Infrastructure

Generate production-ready GitHub Actions workflows for infrastructure projects. Covers Terraform validation, Docker linting and builds, Helm chart testing, and workflow self-validation with actionlint.

## Terraform Workflow Template

Create `.github/workflows/terraform.yml`:

```yaml
name: Terraform

on:
  push:
    branches: [main]
    paths: ["infra/**", "*.tf"]
  pull_request:
    branches: [main]
    paths: ["infra/**", "*.tf"]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: "1.9"

      - name: Terraform fmt
        run: terraform fmt -check -recursive

      - name: Terraform init
        run: terraform init -backend=false

      - name: Terraform validate
        run: terraform validate

  plan:
    runs-on: ubuntu-latest
    needs: [validate]
    if: github.event_name == 'pull_request'
    steps:
      - uses: actions/checkout@v4

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: "1.9"

      - name: Terraform init
        run: terraform init

      - name: Terraform plan
        run: terraform plan -no-color -out=tfplan
        env:
          # Add cloud provider credentials as secrets
          # AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          # AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

      - name: Post plan to PR
        uses: actions/github-script@v7
        if: github.event_name == 'pull_request'
        with:
          script: |
            const { execSync } = require('child_process');
            const plan = execSync('terraform show -no-color tfplan').toString();
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: `## Terraform Plan\n\`\`\`\n${plan.substring(0, 60000)}\n\`\`\``
            });
```

## Docker Workflow Template

Create `.github/workflows/docker.yml`:

```yaml
name: Docker

on:
  push:
    branches: [main]
    paths: ["Dockerfile*", "docker-compose*.yml", ".dockerignore"]
  pull_request:
    paths: ["Dockerfile*", "docker-compose*.yml", ".dockerignore"]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Lint Dockerfiles with hadolint
        uses: hadolint/hadolint-action@v3.1.0
        with:
          dockerfile: Dockerfile
          failure-threshold: warning

  build:
    runs-on: ubuntu-latest
    needs: [lint]
    steps:
      - uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build image
        uses: docker/build-push-action@v6
        with:
          context: .
          push: false
          tags: ${{ github.repository }}:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

## Helm Workflow Template

Create `.github/workflows/helm.yml`:

```yaml
name: Helm

on:
  push:
    branches: [main]
    paths: ["charts/**"]
  pull_request:
    paths: ["charts/**"]

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Set up Helm
        uses: azure/setup-helm@v4

      - name: Helm lint
        run: helm lint charts/*

      - name: Helm template
        run: |
          for chart in charts/*/; do
            echo "--- Rendering $chart ---"
            helm template test "$chart" --debug
          done

      - name: Set up chart-testing
        uses: helm/chart-testing-action@v2.7.0

      - name: Run chart-testing
        run: ct lint --target-branch ${{ github.event.repository.default_branch }}
```

## Workflow Validation (actionlint)

Create `.github/workflows/actionlint.yml`:

```yaml
name: Validate Workflows

on:
  push:
    paths: [".github/workflows/**"]
  pull_request:
    paths: [".github/workflows/**"]

jobs:
  actionlint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run actionlint
        uses: rhysd/actionlint-action@v1
```

## Instructions

When the user invokes this skill:

1. **Identify the project** — Look at the argument for a project name or path. If none given, use the current working directory.
2. **Scan the project** to determine which infra tools are in use:
   - Look for `*.tf` files or `infra/` directory for Terraform.
   - Look for `Dockerfile*` files for Docker.
   - Look for `charts/` directory or `Chart.yaml` for Helm.
   - Look for `.github/workflows/` for actionlint relevance.
3. **Generate only the relevant workflows** — Do not create Helm workflow if there are no charts.
4. **Adapt Terraform paths** — Adjust the `paths:` filter and working directory based on where `.tf` files live.
5. **Write the files** to `.github/workflows/` in the target project.
6. **Report** what was generated.

## Customization Notes

- For Terraform Cloud/Spacelift, replace the plan step with the appropriate integration.
- For multi-environment Terraform (dev/staging/prod), create separate jobs or use matrix with workspace.
- For Docker multi-platform builds, add `platforms: linux/amd64,linux/arm64` to the build step.
- For private Helm chart repos, add `helm repo add` steps with credentials.
- Add Trivy or Snyk scanning for container vulnerability checks.
