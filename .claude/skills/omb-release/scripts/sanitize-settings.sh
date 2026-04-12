#!/usr/bin/env bash
# sanitize-settings.sh — Remove sensitive env var keys from settings.json before release
# Usage: sanitize-settings.sh <repo_dir>
# Exit codes: 0 = success or skipped, 1 = failure
set -euo pipefail

REPO_DIR="${1:?Usage: sanitize-settings.sh <repo_dir>}"
SETTINGS_FILE="${REPO_DIR}/.claude/settings.json"

if [ ! -f "${SETTINGS_FILE}" ]; then
  echo "[sanitize-settings] settings.json not found at ${SETTINGS_FILE} — skipping" >&2
  exit 0
fi

python3 << PYEOF
import json, pathlib, sys

settings_path = pathlib.Path("${SETTINGS_FILE}")
try:
    data = json.loads(settings_path.read_text())
except json.JSONDecodeError as e:
    print(f"[sanitize-settings] ERROR: failed to parse settings.json: {e}", file=sys.stderr)
    sys.exit(1)

removed_keys = []
if "env" in data:
    sensitive_patterns = ("KEY", "TOKEN", "SECRET", "PASSWORD", "CREDENTIAL", "AUTH")
    for k in list(data["env"]):
        if any(s in k.upper() for s in sensitive_patterns):
            del data["env"][k]
            removed_keys.append(k)

settings_path.write_text(json.dumps(data, indent=2) + "\n")

if removed_keys:
    for k in removed_keys:
        print(f"[sanitize-settings] removed sensitive key: {k}", file=sys.stderr)
    print(f"[sanitize-settings] removed {len(removed_keys)} sensitive env key(s)", file=sys.stderr)
else:
    print("[sanitize-settings] no sensitive keys found — settings unchanged", file=sys.stderr)
PYEOF
