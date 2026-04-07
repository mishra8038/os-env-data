#!/usr/bin/env bash
# Idempotent: ensure ~/z/env/ai and ~/z/env/obsidian point at this repo's trees.
# Safe if those paths are already correct symlinks. Refuses to replace real directories.
set -u

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
Z_ENV="${Z_ENV_ROOT:-$HOME/z/env}"
TARGET_AI="$REPO_ROOT/ai"
TARGET_OBS="$REPO_ROOT/obsidian"

log() { printf '[wire-z-env] %s\n' "$*"; }

link_one() {
  local name="$1" target="$2"
  local linkpath="$Z_ENV/$name"
  mkdir -p "$Z_ENV" 2>/dev/null || true
  if [ ! -d "$target" ]; then
    log "Skip: $target does not exist (create or clone content first)"
    return 0
  fi
  if [ -e "$linkpath" ] && [ ! -L "$linkpath" ]; then
    log "Refuse: $linkpath exists and is not a symlink; move it into $target then re-run"
    return 1
  fi
  ln -sfn "$target" "$linkpath"
  log "OK: $linkpath -> $target"
}

link_one ai "$TARGET_AI" || exit 1
link_one obsidian "$TARGET_OBS" || exit 1
log "Done."
