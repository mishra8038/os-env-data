#!/usr/bin/env bash
# Idempotent compat wiring for this env-data checkout.
#
# ~/z/env/ai is the live AI registry (real directory). Do NOT replace it with
# a symlink into this repo. The shadowed ai/ tree under this repo was archived
# 2026-07-15 → ~/z/data/archive/sys-env-data-ai-*.
#
# Obsidian templates: ~/z/env/sys-env-data/obsidian/ or sys-obsidian-vault-template.
set -u

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
Z_ENV="${Z_ENV_ROOT:-$HOME/z/env}"
STUB_AI="$REPO_ROOT/ai"
COMPAT_OS_DATA="${COMPAT_OS_DATA:-$Z_ENV/os/os-env-data}"

log() { printf '[wire-z-env] %s\n' "$*"; }

# Live AI registry — never overwrite a real tree.
if [ -d "$Z_ENV/ai" ] && [ ! -L "$Z_ENV/ai" ]; then
  log "OK: $Z_ENV/ai is the live AI registry (directory; left unchanged)"
elif [ -L "$Z_ENV/ai" ]; then
  target="$(readlink -f "$Z_ENV/ai" 2>/dev/null || true)"
  if [ "$target" = "$(readlink -f "$STUB_AI" 2>/dev/null)" ]; then
    log "WARN: $Z_ENV/ai still symlinks to archived stub $STUB_AI"
    log "       Repoint or replace with live tree under ~/z/env/ai/ (not this stub)."
  else
    log "OK: $Z_ENV/ai -> $target"
  fi
else
  log "WARN: $Z_ENV/ai missing — restore/create the live AI registry directory"
fi

if [ -f "$STUB_AI/README.md" ] && [ ! -d "$STUB_AI/claude" ]; then
  log "Note: $STUB_AI is a redirect stub (ai content archived)"
fi

mkdir -p "$(dirname "$COMPAT_OS_DATA")" 2>/dev/null || true
if [ -e "$COMPAT_OS_DATA" ] && [ ! -L "$COMPAT_OS_DATA" ]; then
  log "Skip compat: $COMPAT_OS_DATA exists and is not a symlink"
else
  ln -sfn "$REPO_ROOT" "$COMPAT_OS_DATA"
  log "OK: $COMPAT_OS_DATA -> $REPO_ROOT"
fi

log "Done."
