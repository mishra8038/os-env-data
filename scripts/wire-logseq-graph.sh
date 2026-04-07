#!/usr/bin/env bash
# Open the canonical Logseq graph folder and print the in-app steps (Logseq has no stable
# Flatpak CLI flag to select a folder graph; you choose it once in the UI).
set -u
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GRAPH_DIR="$REPO_ROOT/logseq"

if [ ! -d "$GRAPH_DIR/logseq" ] || [ ! -d "$GRAPH_DIR/pages" ] || [ ! -d "$GRAPH_DIR/journals" ]; then
  echo "Expected graph layout missing under: $GRAPH_DIR" >&2
  echo "Need: logseq/pages, logseq/journals, logseq/logseq/ (with config.edn)" >&2
  exit 1
fi

GRAPH_ABS="$(readlink -f "$GRAPH_DIR" 2>/dev/null || realpath "$GRAPH_DIR" 2>/dev/null || echo "$GRAPH_DIR")"

cat <<EOF

Graph root (select this folder in Logseq):
  $GRAPH_ABS

In Logseq (desktop):
  1. Click the current graph name (bottom of the left sidebar).
  2. Choose "All graphs" (or the graph switcher).
  3. "Add new graph" / "Open a local directory" / "Choose folder" (wording varies by version).
  4. Pick the folder above (the one that contains pages/, journals/, and logseq/).

To use it as your daily driver, pick the same graph again from the graph list after restart.

EOF

if command -v xdg-open >/dev/null 2>&1; then
  echo "Opening folder in the default file manager..."
  xdg-open "$GRAPH_DIR" 2>/dev/null || true
fi
