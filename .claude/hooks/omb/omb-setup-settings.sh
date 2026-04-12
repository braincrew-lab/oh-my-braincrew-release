#!/usr/bin/env bash
# omb-setup-settings.sh — Deterministic settings.json generator
# Usage: omb-setup-settings.sh [doc_language]
# Merges env vars, hook entries, and permissions into existing settings.json atomically.
set -euo pipefail

DOC_LANG="${1:-en}"
SETTINGS_FILE="${CLAUDE_PROJECT_DIR}/.claude/settings.json"
TMPFILE="${SETTINGS_FILE}.tmp.$$"

# Cleanup temp file on exit
trap 'rm -f "$TMPFILE"' EXIT

# Base settings template (env + hooks + permissions)
read -r -d '' PATCH <<'JSONEOF' || true
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "hooks": {
    "SessionStart": [{"hooks": [{"command": "\"$CLAUDE_PROJECT_DIR/.claude/hooks/omb/omb-hook.sh\" SessionStart", "timeout": 30, "type": "command"}]}],
    "PreToolUse": [
      {"hooks": [{"command": "\"$CLAUDE_PROJECT_DIR/.claude/hooks/omb/omb-hook.sh\" PreToolUse", "timeout": 10, "type": "command"}], "matcher": "Bash"},
      {"hooks": [{"command": "\"$CLAUDE_PROJECT_DIR/.claude/hooks/omb/omb-hook.sh\" PreToolUse", "timeout": 10, "type": "command"}], "matcher": "Write|Edit"}
    ],
    "PostToolUse": [{"hooks": [{"command": "\"$CLAUDE_PROJECT_DIR/.claude/hooks/omb/omb-hook.sh\" PostToolUse", "timeout": 30, "type": "command"}], "matcher": "Write|Edit"}],
    "Stop": [{"hooks": [{"command": "\"$CLAUDE_PROJECT_DIR/.claude/hooks/omb/omb-hook.sh\" Stop", "timeout": 10, "type": "command"}], "matcher": "Agent"}]
  },
  "permissions": {"defaultMode": "bypassPermissions", "allow": ["Read","Grep","Glob","Bash","Skill","Write","Edit","Agent"]},
  "respectGitignore": true,
  "statusLine": {"type": "command", "command": "\"$CLAUDE_PROJECT_DIR/.claude/statusline-omb.sh\"", "padding": 1}
}
JSONEOF

# Ensure .claude directory exists
mkdir -p "$(dirname "$SETTINGS_FILE")"

# Merge: existing settings + omb patch (omb keys overwrite, non-omb keys preserved)
if command -v jq &>/dev/null; then
  EXISTING="{}"
  [ -f "$SETTINGS_FILE" ] && EXISTING=$(cat "$SETTINGS_FILE")
  echo "$EXISTING" | jq --argjson patch "$PATCH" --arg lang "$DOC_LANG" \
    '. * $patch | .env.OMB_DOCUMENTATION_LANGUAGE = $lang' > "$TMPFILE"
  mv "$TMPFILE" "$SETTINGS_FILE"
else
  # Python fallback (project requires Python via uv)
  python3 -c "
import json, pathlib
settings_path = pathlib.Path('$SETTINGS_FILE')
existing = json.loads(settings_path.read_text()) if settings_path.exists() else {}
patch = json.loads(r'''$PATCH''')
for key, val in patch.items():
    if isinstance(val, dict) and isinstance(existing.get(key), dict):
        existing[key].update(val)
    else:
        existing[key] = val
existing.setdefault('env', {})['OMB_DOCUMENTATION_LANGUAGE'] = '$DOC_LANG'
tmp = pathlib.Path('$TMPFILE')
tmp.write_text(json.dumps(existing, indent=2) + '\n')
tmp.rename(settings_path)
"
fi

echo "[omb-setup] settings.json updated (env: CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1, OMB_DOCUMENTATION_LANGUAGE=$DOC_LANG)"
