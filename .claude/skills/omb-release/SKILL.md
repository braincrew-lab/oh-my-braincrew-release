---
name: omb-release
user-invocable: true
description: >
  Use when releasing a new version — handles version bump (default: patch),
  changelog generation (AI-summarized, public-facing), git tagging, GitHub Release,
  binary builds (via CI), and public release repo update with changelog and README.
argument-hint: "[major|minor|patch|X.Y.Z] [additional comment]"
allowed-tools: Bash, Read, Write, Edit, Grep, Glob
---

# OMB Release Pipeline

Orchestrates the full release lifecycle: version bump, changelog generation, git tagging, GitHub Release creation, and public release repo update. Binary builds happen automatically via CI after the tag is pushed.

## Prerequisites

- `gh` CLI must be authenticated (`gh auth status` succeeds)
- `git` working tree must be clean (no uncommitted changes)

## Current State

Current version (read at invocation time):
!`grep '^__version__' src/hook/__init__.py | head -1`

Latest tag:
!`git describe --tags --abbrev=0 2>/dev/null || echo "(no tags yet — first release)"`

Working tree status:
!`git status --short | head -5 || echo "clean"`

## Arguments

$ARGUMENTS

- First word: `major`, `minor`, `patch`, or explicit semver `X.Y.Z`. Default: `patch`.
- Remaining text: additional comment appended to the changelog entry.

## Execution Steps

<execution_order>

### Step 1: Parse Arguments

1. Strip leading/trailing whitespace from `$ARGUMENTS`.
2. Split on the first space: `first_word` + `remaining`.
3. Determine bump type:
   - If `first_word` matches `major|minor|patch`: `bump_type = first_word`
   - If `first_word` matches semver `^\d+\.\d+\.\d+$`: `explicit_version = first_word`, `bump_type = explicit`
   - If `first_word` is empty or unrecognized: `bump_type = patch`
4. Set `additional_comment = remaining` (may be empty).

### Step 2: Pre-flight Checks

Run all checks before touching any files:

```bash
# Clean working tree
git diff --quiet && git diff --cached --quiet || { echo "ERROR: Working tree is dirty — commit or stash changes first"; exit 1; }

# package.json exists
test -f package.json || { echo "ERROR: package.json not found at project root"; exit 1; }

# gh CLI is authenticated
gh auth status || { echo "ERROR: gh CLI is not authenticated — run 'gh auth login' first"; exit 1; }
```

If any check fails: report BLOCKED with the specific failure message. Do not proceed.

### Step 3: Calculate Version

1. Read current version:
   ```bash
   grep '^__version__\s*=' src/hook/__init__.py | head -1
   ```
   Parse the `X.Y.Z` triplet. If the line is missing or malformed, report BLOCKED.

2. Apply bump logic:
   - `patch`: `X.Y.(Z+1)`
   - `minor`: `X.(Y+1).0`
   - `major`: `(X+1).0.0`
   - `explicit`: use the provided `X.Y.Z` verbatim

3. Verify the target tag does not already exist:
   ```bash
   git tag -l "v${NEW_VERSION}"
   ```
   If the tag exists: report BLOCKED — tag already exists, bump manually or use explicit version.

### Step 4: Generate Changelog Entry

1. Get commits since the last tag:
   ```bash
   git log v${CURRENT_VERSION}..HEAD --pretty=format:"%H %s" 2>/dev/null
   ```
   **First release fallback**: if no previous tag exists (git log exits non-zero or returns nothing), use:
   ```bash
   git log HEAD --pretty=format:"%H %s"
   ```
   And treat the entry as "Initial Release".

2. AI-summarize the commits into a changelog entry using Keep a Changelog format:
   - **Added** — new features and capabilities
   - **Changed** — changes to existing functionality
   - **Fixed** — bug fixes
   - **Documentation** — docs-only changes
   - **Maintenance** — dependency updates, refactoring, CI changes

   Rules:
   - Write in public-facing language (no internal jargon, no commit hashes)
   - Omit trivial changes (typos, whitespace, chore commits with no user impact)
   - Include `additional_comment` as a prominent note if it was provided
   - First release: use a single "Initial Release" section describing the product

3. Format the entry:
   ```markdown
   ## [X.Y.Z] - YYYY-MM-DD

   ### Added
   - ...

   ### Fixed
   - ...
   ```

4. If `CHANGELOG.md` does not exist at project root, create it with the standard header:
   ```markdown
   # Changelog

   All notable changes to this project will be documented in this file.

   The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
   ```

### Step 5: Display Changelog

Show the generated changelog entry to the user. Proceed automatically — no confirmation needed.

### Step 6: Update Version Files

Update exactly these two files. Do NOT update `pyproject.toml` (it uses dynamic versioning via `[tool.hatch.version]`).

1. **`src/hook/__init__.py`**: Replace the `__version__` line.
   - Old: `__version__ = "X.Y.Z"`
   - New: `__version__ = "NEW_VERSION"`
   - Preserve all other content.

2. **`package.json`**: Replace the top-level `version` field.
   - Old: `"version": "X.Y.Z"`
   - New: `"version": "NEW_VERSION"`
   - Preserve formatting and all other content.

3. **`CHANGELOG.md`**: Prepend the new entry after the header (before the first existing `##` section).

### Step 7: Build Validation (optional)

```bash
uv build --project "${CLAUDE_PROJECT_DIR}" 2>&1 | tail -20
```

If the build exits non-zero: show the last 20 lines and abort. Do NOT proceed to tagging.

If `uv build` is not available in the environment, skip this step and note it in the summary.

### Step 8: Commit and Tag

```bash
git add src/hook/__init__.py package.json CHANGELOG.md
git commit -m "chore(release): v${NEW_VERSION}"
git tag -a "v${NEW_VERSION}" -m "Release v${NEW_VERSION}"
```

Note: commit message uses `chore(release):` format (conventional commit), not `release:`.

### Step 9: Push

```bash
git push && git push --tags
```

If push fails: report the error. The tag and commit exist locally — advise the user to push manually.

### Step 10: Create GitHub Release (private repo)

```bash
gh release create "v${NEW_VERSION}" \
  --title "v${NEW_VERSION}" \
  --notes "${CHANGELOG_ENTRY}"
```

Uses `GITHUB_TOKEN` (default environment variable). If the release creation fails, note the error in the summary but continue to Step 11 — the tag is already pushed.

### Step 11: Update Public Release Repo

The public release repository is `teddynote-lab/oh-my-braincrew-release`.

```bash
RELEASE_REPO_DIR=$(mktemp -d)
```

**11.1 Clone the public repo** (using gh for auth):

```bash
gh repo clone teddynote-lab/oh-my-braincrew-release "${RELEASE_REPO_DIR}"
```

**11.2 Generate public-facing changelog**

Write a user-facing version of the changelog entry — omit any internal implementation details, hook names, or architecture references. Focus on what users of the harness can do now that they couldn't before.

**11.3 Update CHANGELOG.md in release repo**

Prepend the public changelog entry to `${RELEASE_REPO_DIR}/CHANGELOG.md`. Create the file with the standard header if it does not exist.

**11.4 Update README.md version references**

Replace occurrences of the previous version string `X.Y.Z` with `NEW_VERSION` in `${RELEASE_REPO_DIR}/README.md`. If README does not exist, skip silently.

**11.5 Copy install scripts**

```bash
cp scripts/install.sh "${RELEASE_REPO_DIR}/scripts/install.sh" 2>/dev/null || true
cp scripts/install.ps1 "${RELEASE_REPO_DIR}/scripts/install.ps1" 2>/dev/null || true
```

**11.6 Copy .claude/ directory (allowlist only)**

Only the directories listed below are copied. Everything else is excluded.

```bash
rm -rf "${RELEASE_REPO_DIR}/.claude"
mkdir -p "${RELEASE_REPO_DIR}/.claude"
for dir in skills rules agents; do
  if [ -d ".claude/${dir}" ]; then
    cp -r ".claude/${dir}" "${RELEASE_REPO_DIR}/.claude/${dir}"
  fi
done
```

**Explicitly excluded from .claude/**: `agent-memory/`, `settings.local.json`, any plans or internal-only config.

**11.7 Copy CLAUDE.md**

```bash
cp CLAUDE.md "${RELEASE_REPO_DIR}/CLAUDE.md"
```

**11.8 Run sanitize script on settings.json**

Copy `settings.json` and run the sanitize script:

```bash
cp .claude/settings.json "${RELEASE_REPO_DIR}/.claude/settings.json"
bash "${CLAUDE_PROJECT_DIR}/.claude/skills/omb-release/scripts/sanitize-settings.sh" "${RELEASE_REPO_DIR}"
```

**11.9 Sanitize verification gate**

Before pushing, verify no secrets leaked through:

```bash
if grep -riE 'KEY|TOKEN|SECRET|PASSWORD' "${RELEASE_REPO_DIR}/.claude/settings.json" 2>/dev/null; then
  echo "ERROR: Secret stripping failed — aborting release repo push"
  exit 1
fi
```

If this check fails: do NOT push. Report BLOCKED with the matched lines so the user can investigate the sanitize script.

**11.10 Remove internal artifacts**

```bash
rm -rf "${RELEASE_REPO_DIR}/.claude/agent-memory"
rm -f "${RELEASE_REPO_DIR}/.claude/settings.local.json"
```

**11.11 Commit and push to public repo**

```bash
cd "${RELEASE_REPO_DIR}"
git config user.email "release-bot@oh-my-braincrew.dev"
git config user.name "OMB Release Bot"
git add -A
git commit -m "chore(release): v${NEW_VERSION}"
git push
```

**11.12 Create GitHub Release on public repo**

```bash
gh release create "v${NEW_VERSION}" \
  --repo "teddynote-lab/oh-my-braincrew-release" \
  --title "v${NEW_VERSION}" \
  --notes "${PUBLIC_CHANGELOG_ENTRY}"
```

**11.13 Cleanup temp directory**

```bash
rm -rf "${RELEASE_REPO_DIR}"
```

</execution_order>

### Step 12: Report Summary

Print a final release summary:

```
## Release v{NEW_VERSION} Complete

| Item | Status |
|------|--------|
| Version bump | {OLD_VERSION} → {NEW_VERSION} ({bump_type}) |
| CHANGELOG.md | Updated |
| Build validation | OK / SKIPPED |
| Git commit | {commit_hash} |
| Git tag | v{NEW_VERSION} (pushed) |
| GitHub Release (private) | {release_url} |
| Public repo update | {public_repo_release_url} |
| Binary builds | Triggered via CI (no action needed) |

### Changelog
{CHANGELOG_ENTRY}
```

## Error Handling

| Error | Action |
|-------|--------|
| Dirty working tree | BLOCKED — commit or stash changes first |
| `package.json` missing | BLOCKED |
| `gh auth status` fails | BLOCKED — run `gh auth login` first |
| `src/hook/__init__.py` missing | BLOCKED — cannot determine current version |
| `__version__` line missing/malformed | BLOCKED with actual file content |
| Tag already exists | BLOCKED — use explicit version or bump differently |
| `uv build` fails | Abort with last 20 lines of output |
| Sanitize verification fails | BLOCKED — do NOT push public repo |
| GitHub Release creation fails | Log error, continue to Step 11 |
| Public repo push fails | Report error in summary (private release is complete) |

## Authentication

All GitHub operations use `gh` CLI authentication. Run `gh auth login` if not already authenticated. The `gh` CLI handles token management automatically for both the private repo and public release repo.

## Notes

- `pyproject.toml` is NOT updated — it uses `[tool.hatch.version]` dynamic versioning that reads from `src/hook/__init__.py`.
- Binary builds are triggered automatically by the CI pipeline when the tag is pushed. No manual build step is needed.
- `omb-version` is the canonical standalone version bumper for bump-only workflows. This skill reads and applies the same bump logic inline.
- First release (no previous tags): changelog covers all commits and is labeled "Initial Release".

<omb>DONE</omb>

```result
summary: "omb-release SKILL.md created — 12-step release pipeline for version bump, changelog, git tagging, GitHub Release, and public repo update."
artifacts:
  - ".claude/skills/omb-release/SKILL.md"
changed_files:
  - ".claude/skills/omb-release/SKILL.md"
concerns: []
blockers: []
retryable: false
next_step_hint: "Create .claude/skills/omb-release/scripts/sanitize-settings.sh referenced in Step 11.8"
```
