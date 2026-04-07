# os-env-data

Portable, cross-machine **environment and notes** data: **AI registry** (`ai/`), **Obsidian** trees (`obsidian/`), Logseq graph(s), reproduction metadata, and (optionally) **non-secret** profile exports.

This repo is intentionally **separate** from your **dev-environment** workstation repo so personal journals and large note history do not bloat restore PRs. Keep both under `~/z/env/` if you like; layout rationale: `~/z/env/dev-environment/docs/Z_LAYOUT.md`.

## Deployment boundary

- Profile data in this repo is deployed **only on request**.
- Nothing in `dev-environment` should auto-deploy these profiles during setup/restore.
- Use `scripts/deploy-profiles-on-demand.sh` manually when you want deployment.

## Directory layout (canonical)

| Path | Purpose |
| --- | --- |
| `ai/` | Cursor / Claude / Codex / Hermes / VS Code registry (shared + per-tool); layout semantics: `~/z/env/dev-environment/docs/Z_LAYOUT.md` |
| `obsidian/` | Vault templates and Obsidian-related assets |
| `logseq/` | Logseq graph root |
| `profiles/` | Reproduction notes (sanitized) |
| `scripts/` | On-demand deploy + `wire-z-env-symlinks.sh` |

After clone on a new machine, run **`scripts/wire-z-env-symlinks.sh`** so **`~/z/env/ai`** and **`~/z/env/obsidian`** point here (or rely on **`deploy-ai-artifacts.sh`** / restore, which does the same when this repo is at **`~/z/env/os-env-data`**).

## Logseq graph

1. Install Logseq (this machine: Flatpak `com.logseq.Logseq` from Flathub).
2. Run **`scripts/wire-logseq-graph.sh`** (prints steps and opens the graph folder), **or** in Logseq: **Add new graph** → open the **`logseq/`** directory inside this repository (the folder that contains `pages/`, `journals/`, and `logseq/config.edn`).
3. Optional: enable Git in Logseq settings if you want the app to commit; or manage commits yourself from the repo root.

Graph root: `logseq/` (not the repository root).

## Reproduction profiles

Machine-specific app metadata (paths, versions, sanitized settings) lives under **`profiles/`**. Copy or update after major upgrades.

- `profiles/logseq-reproduction.md`: Logseq install channel, config paths, exported `configs.edn`.

## AI / editor profile data (Cursor, Claude, Codex, etc.)

- **Do not commit secrets** (API keys, tokens, cookies). Use environment variables or OS keyrings.
- **Cursor / editor**: this dev-environment repo already carries portable pieces under `restore/config/cursor/`; global rules live in your home directory—export or sync those separately if you want them in git (redact first).
- **Shared curated AI artifacts**: canonical layout is **`ai/`** in this repo (also `~/z/env/ai/` via symlink; see `Z_LAYOUT.md` in dev-environment).
- **Optional**: add `profiles/cursor-paths.md` (or similar) here with *paths only* and “export procedure” pointers—keep heavy or sensitive trees out of git.

## Clone

```bash
git clone https://github.com/mishra8038/os-env-data.git ~/z/env/os-env-data
```

After clone, open the `logseq/` folder as a graph in Logseq as above.

## On-demand deployment

Current deploy script supports profile bundle `logseq`:

```bash
cd ~/z/env/os-env-data
scripts/deploy-profiles-on-demand.sh logseq
```

The script asks for confirmation before each major step and writes a report to `results/`.
