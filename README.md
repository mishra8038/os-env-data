# pkb-env-data

Portable, cross-machine **personal environment** data: Logseq graph(s), reproduction metadata, and (optionally) **non-secret** profile exports.

**GitHub:** `mishra8038/pkb-env-data` (renamed from `os-env-data`, 2026-07-06).

| | Path |
| --- | --- |
| **Canonical checkout** | `~/z/kb/personal/pkb-env-data` |
| **Compat symlink** | `~/z/env/os/os-env-data` |

This repo is intentionally **separate** from **`sys-restore`** so personal journals do not bloat restore PRs. Layout: `~/z/env/sys-restore/docs/Z_LAYOUT.md` · reorg: `docs/reorg-1/`.

**Not in this repo (by design):**
- **`ai/`** — local tool homes under `~/z/env/ai/` (symlink target on disk; gitignored)
- **Obsidian templates** — `~/z/kb/personal/pkb-obsidian-vault-template`

## Deployment boundary

- Profile data is deployed **only on request**.
- Nothing in restore should auto-deploy these profiles during setup.
- Use `scripts/deploy-profiles-on-demand.sh` manually when you want deployment.

## Directory layout (git-tracked)

| Path | Purpose |
| --- | --- |
| `logseq/` | Logseq graph root |
| `profiles/` | Reproduction notes (sanitized) |
| `scripts/` | On-demand deploy + `wire-z-env-symlinks.sh` |

After clone, run **`scripts/wire-z-env-symlinks.sh`** so **`~/z/env/ai`** points at this repo's local `ai/` tree (when present).

## Logseq graph

1. Install Logseq (this machine: Flatpak `com.logseq.Logseq` from Flathub).
2. Run **`scripts/wire-logseq-graph.sh`**, or in Logseq: **Add new graph** → open **`logseq/`** inside this repo.
3. Optional: enable Git in Logseq settings, or commit from the repo root.

Graph root: `logseq/` (not the repository root).

## Reproduction profiles

Machine-specific app metadata lives under **`profiles/`**.

- `profiles/logseq-reproduction.md`: Logseq install channel, config paths.

## Clone

```bash
git clone https://github.com/mishra8038/pkb-env-data.git ~/z/kb/personal/pkb-env-data
ln -sfn ~/z/kb/personal/pkb-env-data ~/z/env/os/os-env-data   # optional compat
```

## On-demand deployment

```bash
cd ~/z/kb/personal/pkb-env-data
scripts/deploy-profiles-on-demand.sh logseq
```

The script asks for confirmation before each major step and writes a report to `results/` (gitignored).
