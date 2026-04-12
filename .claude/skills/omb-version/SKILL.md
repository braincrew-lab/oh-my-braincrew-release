---
name: omb-version
description: "Bump OMB version (major/minor/patch). Updates __init__.py and package.json."
argument-hint: "[major|minor|patch]"
user-invocable: true
---

# OMB Version Bump

Bump the OMB harness version. Reads the current version from `src/hook/__init__.py`, increments the requested component, writes the new version back, updates `package.json` if present, and verifies the build.

## Current State

Current version (read at invocation time):
!`grep -E '^__version__' src/hook/__init__.py | head -1`

package.json presence:
!`test -f package.json && echo "package.json found" || echo "package.json not found"`

## Arguments

$ARGUMENTS

Supported values: `major`, `minor`, `patch` (default: `patch` when no argument is provided).

## Execution Steps

<execution_order>
1. **Parse argument**: Extract bump type from `$ARGUMENTS`.
   - Strip whitespace. Lowercase.
   - Valid values: `major`, `minor`, `patch`.
   - If empty or not provided: default to `patch`.
   - If an unrecognized value is provided: stop and explain valid options.

2. **Read current version**: Extract `X.Y.Z` from `src/hook/__init__.py`.
   ```bash
   grep -E '^__version__\s*=' src/hook/__init__.py | head -1
   ```
   Parse the version string. If the file does not exist or contains no `__version__` line, report BLOCKED.

3. **Compute new version**: Apply the bump rule to `X.Y.Z`:
   - `patch`: increment Z, reset nothing — result: `X.Y.(Z+1)`
   - `minor`: increment Y, reset Z to 0 — result: `X.(Y+1).0`
   - `major`: increment X, reset Y and Z to 0 — result: `(X+1).0.0`

4. **Update `src/hook/__init__.py`**: Replace the `__version__` line with the new version.
   - Match the exact line: `__version__ = "X.Y.Z"`
   - Replace with: `__version__ = "NEW_VERSION"`
   - Preserve all other file content.

5. **Update `package.json`** (conditional — only if `package.json` exists at project root):
   - Read current `package.json`.
   - Update the top-level `version` field to `NEW_VERSION`.
   - Write the file back (preserve formatting as closely as possible).

6. **Run build verification**:
   ```bash
   uv build --project "${CLAUDE_PROJECT_DIR}" 2>&1 | tail -20
   ```
   - If the build exits with a non-zero code: report the failure output and stop. Do NOT mark as done.
   - If the build succeeds: proceed.

7. **Print version change summary**:
   ```
   Version bumped: OLD_VERSION → NEW_VERSION (BUMP_TYPE)
   Updated files:
     - src/hook/__init__.py
     - package.json (if updated)
   Build: OK
   ```
</execution_order>

## Error Handling

- If `src/hook/__init__.py` is missing: report BLOCKED — cannot determine current version.
- If `__version__` line is missing or malformed: report BLOCKED with the actual file content.
- If version components are not integers: report BLOCKED.
- If build fails: show the last 20 lines of build output and stop.

## Examples

| Invocation | Current | Result |
|------------|---------|--------|
| `/omb-version` | 0.1.0 | 0.1.1 (patch) |
| `/omb-version patch` | 0.1.0 | 0.1.1 |
| `/omb-version minor` | 0.1.0 | 0.2.0 |
| `/omb-version major` | 0.1.0 | 1.0.0 |
| `/omb-version minor` | 1.3.7 | 1.4.0 |
| `/omb-version major` | 1.3.7 | 2.0.0 |
