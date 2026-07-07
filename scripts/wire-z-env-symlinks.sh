#!/usr/bin/env bash
# Idempotent: ensure ~/z/env/ai points at this repo's ai/ tree when present.
# Obsidian: ~/z/kb/personal/pkb-obsidian-vault-template (not this repo).
set -u

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
Z_ENV="${Z_ENV_ROOT:-$HOME/z/env}"
TARGET_AI="$REPO_ROOT/ai"
COMPAT_OS_DATA="${COMPAT_OS_DATA:-$Z_ENV/os/os-env-data}"

log() { printf '[wire-z-env] %s\n' "$*"; }

if [ ! -d "$TARGET_AI" ]; then
  log "Skip: $TARGET_AI does not exist (create locally or restore ai/ tree)"
else
  if [ -e "$Z_ENV/ai" ] && [ ! -L "$Z_ENV/ai" ]; then
    log "Refuse: $Z_ENV/ai exists and is not a symlink; merge into $TARGET_AI then re-run"
    exit 1
  fi
  ln -sfn "$TARGET_AI" "$Z_ENV/ai"
  log "OK: $Z_ENV/ai -> $TARGET_AI"
fi

mkdir -p "$(dirname "$COMPAT_OS_DATA")" 2>/dev/null || true
if [ -e "$COMPAT_OS_DATA" ] && [ ! -L "$COMPAT_OS_DATA" ]; then
  log "Skip compat: $COMPAT_OS_DATA exists and is not a symlink"
else
  ln -sfn "$REPO_ROOT" "$COMPAT_OS_DATA"
  log "OK: $COMPAT_OS_DATA -> $REPO_ROOT"
fi

log "Obsidian template: ~/z/kb/personal/pkb-obsidian-vault-template"
log "Done."
