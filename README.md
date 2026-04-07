# os-env-data

Portable, cross-machine **environment and notes** data: Logseq graph(s), reproduction metadata for apps, and (optionally) **non-secret** profile exports.

This repo is intentionally **separate** from your **dev-environment** workstation repo so personal journals and large note history do not bloat restore PRs. Keep both under `~/z/env/` if you like; layout rationale: `~/z/env/dev-environment/docs/Z_LAYOUT.md`.

## Logseq graph

1. Install Logseq (this machine: Flatpak `com.logseq.Logseq` from Flathub).
2. In Logseq: **Add new graph** → pick the **`logseq/`** directory inside this repository (the folder that contains `pages/`, `journals/`, and `logseq/config.edn`).
3. Optional: enable Git in Logseq settings if you want the app to commit; or manage commits yourself from the repo root.

Graph root: `logseq/` (not the repository root).

## Reproduction profiles

Machine-specific app metadata (paths, versions, sanitized settings) lives under **`profiles/`**. Copy or update after major upgrades.

| File | Purpose |
|------|---------|
| [profiles/logseq-reproduction.md](profiles/logseq-reproduction.md) | Logseq install channel, config paths, exported `configs.edn` |

## AI / editor profile data (Cursor, Claude, Codex, etc.)

- **Do not commit secrets** (API keys, tokens, cookies). Use environment variables or OS keyrings.
- **Cursor / editor**: this dev-environment repo already carries portable pieces under `restore/config/cursor/`; global rules live in your home directory—export or sync those separately if you want them in git (redact first).
- **Shared curated AI artifacts**: canonical layout is `~/z/env/ai/` (see `Z_LAYOUT.md` in dev-environment).
- **Optional**: add `profiles/cursor-paths.md` (or similar) here with *paths only* and “export procedure” pointers—keep heavy or sensitive trees out of git.

## Clone

```bash
git clone https://github.com/mishra8038/os-env-data.git ~/z/env/os-env-data
# or keep a copy inside dev-environment for convenience (submodule or nested clone—your choice)
```

After clone, open the `logseq/` folder as a graph in Logseq as above.
