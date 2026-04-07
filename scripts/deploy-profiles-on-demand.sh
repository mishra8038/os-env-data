#!/usr/bin/env bash
set -u

SCRIPT_NAME="$(basename "$0")"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RESULTS_DIR="$REPO_ROOT/results"
TIMESTAMP="$(date -u +"%Y-%m-%d_%H%M%S")"
REPORT_PATH="$RESULTS_DIR/${TIMESTAMP}-deploy-profiles-on-demand-report.md"

mkdir -p "$RESULTS_DIR"

ATTEMPTED=()
SUCCESS=()
SKIPPED=()
FAILED=()

log() {
  printf '[%s] %s\n' "$SCRIPT_NAME" "$*"
}

record_attempted() { ATTEMPTED+=("$*"); }
record_success() { SUCCESS+=("$*"); }
record_skipped() { SKIPPED+=("$*"); }
record_failed() { FAILED+=("$*"); }

confirm_step() {
  local prompt="$1"
  while true; do
    read -r -p "$prompt [y/N]: " reply
    case "${reply:-N}" in
      y|Y|yes|YES) return 0 ;;
      n|N|no|NO|"") return 1 ;;
      *) log "Please answer y or n." ;;
    esac
  done
}

safe_copy_file() {
  local src="$1"
  local dst="$2"
  local desc="$3"
  record_attempted "$desc"

  if [[ ! -f "$src" ]]; then
    log "Skip: source not found: $src"
    record_skipped "$desc (source missing)"
    return 0
  fi

  mkdir -p "$(dirname "$dst")" || {
    log "Fail: cannot create target directory: $(dirname "$dst")"
    record_failed "$desc (mkdir failed)"
    return 0
  }

  if cp -f "$src" "$dst"; then
    log "OK: copied $src -> $dst"
    record_success "$desc"
  else
    log "Fail: copy failed for $src"
    record_failed "$desc (copy failed)"
  fi
  return 0
}

write_report() {
  {
    echo "# On-demand profile deploy report"
    echo
    echo "- Timestamp (UTC): $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    echo "- Repo: $REPO_ROOT"
    echo "- Host: $(hostname)"
    echo
    echo "## Attempted"
    if [[ ${#ATTEMPTED[@]} -eq 0 ]]; then
      echo "- None"
    else
      for item in "${ATTEMPTED[@]}"; do
        echo "- $item"
      done
    fi
    echo
    echo "## Successful"
    if [[ ${#SUCCESS[@]} -eq 0 ]]; then
      echo "- None"
    else
      for item in "${SUCCESS[@]}"; do
        echo "- $item"
      done
    fi
    echo
    echo "## Skipped"
    if [[ ${#SKIPPED[@]} -eq 0 ]]; then
      echo "- None"
    else
      for item in "${SKIPPED[@]}"; do
        echo "- $item"
      done
    fi
    echo
    echo "## Failed"
    if [[ ${#FAILED[@]} -eq 0 ]]; then
      echo "- None"
    else
      for item in "${FAILED[@]}"; do
        echo "- $item"
      done
    fi
  } > "$REPORT_PATH"
  log "Report written: $REPORT_PATH"
}

deploy_logseq_profile() {
  local src="$REPO_ROOT/profiles/logseq-reproduction.md"
  local dst="$HOME/.local/share/os-env-data/profiles/logseq-reproduction.md"
  safe_copy_file "$src" "$dst" "Deploy logseq reproduction profile"
}

print_usage() {
  cat <<EOF
Usage:
  $SCRIPT_NAME <bundle>

Bundles:
  logseq    Deploy Logseq reproduction profile to \$HOME/.local/share/os-env-data/profiles/
EOF
}

main() {
  local bundle="${1:-}"
  if [[ -z "$bundle" ]]; then
    print_usage
    exit 1
  fi

  if ! confirm_step "Step 1: Deploy profile bundle '$bundle' from os-env-data?"; then
    log "Cancelled by user."
    record_skipped "Bundle '$bundle' deployment (user cancelled)"
    write_report
    exit 0
  fi

  case "$bundle" in
    logseq)
      if confirm_step "Step 2: Copy Logseq reproduction profile to local profile cache path?"; then
        deploy_logseq_profile
      else
        log "Skip: Step 2 cancelled by user."
        record_skipped "Deploy logseq reproduction profile (user cancelled)"
      fi
      ;;
    *)
      log "Unknown bundle: $bundle"
      print_usage
      record_failed "Bundle '$bundle' deployment (unknown bundle)"
      write_report
      exit 1
      ;;
  esac

  write_report
  log "Done."
}

main "$@"
