#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Live registry lives under ~/z/env/ai (sys-env-data/ai is a redirect stub as of 2026-07-15)
REG_DIR="${WORKSTATION_REGISTRY_DIR:-$HOME/z/env/ai/workstation-registry}"
SNAP_DIR="$REG_DIR/snapshots"
HOST_SLUG="$(hostname 2>/dev/null | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9._-' '-')"
OUT_JSON="$SNAP_DIR/${HOST_SLUG}.json"
LATEST_JSON="$SNAP_DIR/latest.json"

mkdir -p "$SNAP_DIR"

python3 - <<'PY' "$OUT_JSON" "$LATEST_JSON"
import json, os, pathlib, shutil, subprocess, sys, time
out_json = pathlib.Path(sys.argv[1])
latest_json = pathlib.Path(sys.argv[2])
home = pathlib.Path.home()

def expand(p):
    return str(pathlib.Path(os.path.expanduser(p)))

def run(cmd):
    try:
        p = subprocess.run(cmd, shell=True, text=True, capture_output=True, timeout=12)
        return {"ok": p.returncode == 0, "code": p.returncode, "stdout": p.stdout.strip(), "stderr": p.stderr.strip()}
    except Exception as e:
        return {"ok": False, "code": -1, "stdout": "", "stderr": str(e)}

def which_all(name):
    hits = []
    path = shutil.which(name)
    if path:
        hits.append(path)
    candidates = []
    candidates += [home / '.local/bin' / name, home / '.cargo/bin' / name, home / '.config/nvm/versions/node/v24.14.0/bin' / name, home / '.local/share/fnm' / name, pathlib.Path('/usr/local/bin') / name, pathlib.Path('/usr/bin') / name]
    for c in candidates:
        if c.exists() and str(c) not in hits:
            hits.append(str(c))
    return hits

def entry(name, role, binaries=None, paths=None, checks=None, notes=None):
    binaries = binaries or []
    paths = paths or {}
    checks = checks or {}
    if not isinstance(checks, dict):
        checks = {}
    data = {
        "name": name,
        "role": role,
        "resolved_binaries": {b: which_all(b) for b in binaries},
        "resolved_paths": {k: [{"path": expand(p), "exists": pathlib.Path(os.path.expanduser(p)).exists()} for p in v] for k, v in paths.items()},
        "checks": {label: run(cmd) for label, cmd in checks.items()},
    }
    if notes:
        data["notes"] = notes
    return data

snapshot = {
    "generated_at": time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
    "host": os.uname().nodename,
    "cwd": os.getcwd(),
    "assets": {
        "n8n": entry("n8n", "workflow_orchestrator", ["n8n"], {"config": ["~/.n8n"]}, {"command": "command -v n8n", "npm_prefix": "npm prefix -g 2>/dev/null || true"}, notes={"common_node_bins": [expand('~/.config/nvm/versions/node/v24.14.0/bin'), expand('~/.local/share/fnm'), '/usr/local/bin', '/usr/bin']}),
        "litellm": entry("litellm", "openai_compatible_router", ["litellm"], {"config": ["~/z/os/os-env-data/obsidian/obsidian-vault-template-2/.obsidian/litellm/config.yaml", "~/z/os/os-env-data/obsidian/obsidian-vault-template-2/.obsidian/litellm/config.example.yaml"], "runtime": ["~/z/os/os-env-data/obsidian/obsidian-vault-template-2/scripts/run-litellm-proxy.sh"]}, {"command": "command -v litellm", "uv_tools": "uv tool list 2>/dev/null || true"}),
        "open_webui": entry("open_webui", "local_chat_ui", [], {"config": ["~/z/env/ai/open-webui/config/open-webui.env"], "runtime": ["~/z/env/ai/open-webui/compose/docker-compose.yml"], "data": ["~/z/env/ai/open-webui/data"]}, {"docker_info": "docker info >/dev/null 2>&1 && echo ok || true", "podman_info": "podman info >/dev/null 2>&1 && echo ok || true"}),
        "ai_chat_archive": entry("ai_chat_archive", "canonical_markdown_archive", [], {"data": ["~/z/data/ai-chat-archive", "~/z/data/ai-chat-archive/chats", "~/z/data/ai-chat-archive/raw"], "runtime": ["~/z/data/ai-chat-archive/.n8n/workflows"]}, {"git": "git -C ~/z/data/ai-chat-archive rev-parse --is-inside-work-tree 2>/dev/null || true"}),
        "cursor": entry("cursor", "ai_editor", ["cursor"], {"config": ["~/.cursor", "~/.config/Cursor", "~/z/env/ai/cursor"], "runtime": ["~/.cursor/mcp.json", "~/.cursor/projects"]}, {"command": "command -v cursor"}),
        "claude_code": entry("claude_code", "ai_cli", ["claude"], {"config": ["~/.claude", "~/z/env/ai/claude"], "runtime": ["~/.claude/settings.json", "~/z/env/ai/claude/live/memory"]}, {"command": "command -v claude"}),
        "codex_cli": entry("codex_cli", "ai_cli", ["codex"], {"config": ["~/.codex", "~/z/env/ai/codex"], "runtime": ["~/z/env/ai/codex/config.toml", "~/z/env/ai/codex/index.md", "~/z/env/ai/codex/thoughts-inbox.md"]}, {"command": "command -v codex"}),
        "vscode": entry("vscode", "editor", ["code"], {"config": ["~/.config/Code/User", "~/z/env/ai/vscode"], "runtime": ["~/.config/Code/User/mcp.json"]}, {"command": "command -v code"}),
        "obsidian": entry("obsidian", "note_vault_host", [], {"data": ["~/z/os/os-env-data/obsidian", "~/z/os/os-env-data/obsidian"]}, {"flatpak": "flatpak list --app --columns=application 2>/dev/null | grep -x md.obsidian.Obsidian || true"}),
        "ollama": entry("ollama", "local_model_runtime", ["ollama"], {"config": ["~/z/env/ai/hermes/ollama-override.env"], "runtime": ["~/.ollama"]}, {"command": "command -v ollama", "list": "ollama list 2>/dev/null || true"}),
        "hermes": entry("hermes", "agent_cli", ["hermes"], {"config": ["~/z/env/ai/hermes", "~/z/env/ai/hermes/ollama-override.env", "~/z/env/ai/hermes/api-keys.env"], "runtime": ["~/.hermes"]}, {"command": "command -v hermes"}),
        "openclaw": entry("openclaw", "agent_cli", ["openclaw"], {"config": ["~/z/env/ai/openclaw/openclaw.json"]}, {"command": "command -v openclaw"}),
        "archon": entry("archon", "workflow_harness", ["archon"], {"config": ["~/.archon"], "data": ["~/z/env/ai/Archon"], "runtime": ["~/z/env/ai/bin/archon"]}, {"command": "command -v archon", "version": "archon version 2>/dev/null || true"}),
        "proxima": entry("proxima", "browser_session_gateway", [], {}, {}, notes={"status": "optional/manual until a local bridge/config path exists"}),
        "shared_ai_registry": entry("shared_ai_registry", "curated_shared_assets", [], {"data": ["~/z/os/os-env-data/ai/shared", "~/z/os/os-env-data/ai/state", "~/z/os/os-env-data/ai/cursor", "~/z/os/os-env-data/ai/claude", "~/z/os/os-env-data/ai/codex", "~/z/os/os-env-data/ai/vscode", "~/z/os/os-env-data/ai/open-webui"]}, {"readme": "test -f ~/z/os/os-env-data/ai/README.md && echo ok || true"}),
    }
}
out_json.write_text(json.dumps(snapshot, indent=2) + "\n", encoding='utf-8')
latest_json.write_text(json.dumps(snapshot, indent=2) + "\n", encoding='utf-8')
print(out_json)
PY
