---
paths: ["k8s/**", "kubernetes/**", "helm/**", "manifests/**"]
---

# Kubernetes Conventions

## Resource Limits
- ALWAYS set `resources.requests` and `resources.limits` for CPU and memory
- Requests = expected usage, Limits = maximum allowed
- Start conservative and adjust based on metrics
- Use `LimitRange` and `ResourceQuota` at namespace level

## Security Contexts
- `runAsNonRoot: true` — never run containers as root
- `readOnlyRootFilesystem: true` — mount writable dirs explicitly
- `allowPrivilegeEscalation: false`
- Drop all capabilities, add only what is needed: `drop: ["ALL"]`

## Network Policies
- Default deny all ingress and egress per namespace
- Explicitly allow required traffic with NetworkPolicy rules
- Label pods consistently for policy selectors

## Health Probes
- `livenessProbe`: restarts container if unhealthy (use for deadlock detection)
- `readinessProbe`: removes from service if not ready (use for startup/dependencies)
- `startupProbe`: for slow-starting containers to avoid premature restarts
- Set `initialDelaySeconds`, `periodSeconds`, `failureThreshold` appropriately

## Rollout Strategy
- Use `RollingUpdate` with `maxSurge: 1` and `maxUnavailable: 0` for zero-downtime
- Set `minReadySeconds` to avoid marking pods ready too early
- Use `PodDisruptionBudget` for high-availability workloads

## RBAC
- Principle of least privilege — grant only what is needed
- Use `Role` for namespace-scoped, `ClusterRole` for cluster-scoped
- Bind service accounts to roles, not users
- Audit RBAC bindings periodically
