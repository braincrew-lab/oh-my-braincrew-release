---
paths: ["Dockerfile*", "docker-compose*", ".dockerignore"]
---

# Docker Conventions

## Multi-Stage Builds
- Use multi-stage builds to separate build and runtime
- Name stages clearly: `FROM node:20-slim AS builder`
- Copy only artifacts needed for runtime into the final stage
- Keep final image as small as possible

## Base Images
- Use slim or alpine variants — never use `latest` tag
- Pin exact versions: `python:3.12-slim`, not `python:3`
- Use official images from Docker Hub
- Scan base images for vulnerabilities

## Layer Caching
- Order Dockerfile instructions from least to most frequently changed
- Copy dependency files first, install, then copy source code
- Combine related `RUN` commands with `&&` to reduce layers
- Use `.dockerignore` to exclude `node_modules`, `.git`, `__pycache__`, `.env`

## Security
- Run as non-root: `USER appuser` after creating the user
- Do not store secrets in image layers — use runtime env vars or secrets
- Remove package manager caches in the same `RUN` layer
- Set `--no-install-recommends` for apt-get

## Health Checks
- Define `HEALTHCHECK` in Dockerfile or compose
- Use lightweight endpoints (`/health`, `/readyz`)
- Set appropriate interval, timeout, and retries

## Docker Compose
- Use named volumes for persistent data
- Define explicit networks for service isolation
- Use `depends_on` with `condition: service_healthy`
- Set resource limits (`mem_limit`, `cpus`)
