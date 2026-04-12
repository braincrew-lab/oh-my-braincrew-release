#!/usr/bin/env bash
# omb-hook.sh — Release version: calls installed binary directly
# Usage: omb-hook.sh <EventType> [args...]
set -euo pipefail
BIN="${HOME}/.local/bin/omb"
[ -x "$BIN" ] || BIN="${HOME}/.local/bin/oh-my-braincrew"
exec "$BIN" "$1" "${@:2}"
