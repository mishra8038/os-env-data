# Logseq — reproduction profile

Captured for the machine where this file was generated. Update when you change install method or OS.

## Install channel

| Field | Value |
|-------|--------|
| **Distribution** | Flatpak (Flathub) |
| **Application ID** | `com.logseq.Logseq` |
| **Reported version** | 0.10.14 (stable) |

Verify:

```bash
flatpak list --app | grep -i logseq
```

## Configuration paths (Flatpak)

| Purpose | Path |
|---------|------|
| **App / Electron user data** | `~/.var/app/com.logseq.Logseq/config/Logseq/` |
| **User `configs.edn` (Logseq settings)** | `~/.var/app/com.logseq.Logseq/config/Logseq/configs.edn` |
| **Window geometry** | `~/.var/app/com.logseq.Logseq/config/Logseq/window-state.json` |
| **Chromium `Preferences` (spellcheck, etc.)** | `~/.var/app/com.logseq.Logseq/config/Logseq/Preferences` |
| **Cache (do not sync)** | `~/.var/app/com.logseq.Logseq/cache/` |

**Not synced to git:** `Cookies*`, `IndexedDB`, `Local Storage`, `GPUCache`, `blob_storage` — browser-style data; exclude from backups if you only care about notes.

## Exported `configs.edn` (sanitized)

This is the full content at capture time (no secrets observed in this file):

```clojure
{:git/disable-auto-commit? false, :git/commit-on-close? true, :git/auto-commit-seconds 600, :window/native-titlebar? true}
```

## Graph location (this repo)

Open in Logseq as graph root:

```text
<path-to-repo>/logseq/
```

That directory must contain `pages/`, `journals/`, and `logseq/config.edn` (see repo layout).

## Non-Flatpak Linux (reference)

If you use AppImage or native package, configs often appear under `~/.config/Logseq/` — confirm with your packager.

## Capture date

2026-04-07 (generated during dev-environment setup assist).
