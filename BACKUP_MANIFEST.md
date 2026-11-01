# BACKUP MANIFEST — November Backup

- Created: 2026-11-01 21:44 IST
- Machine: fedora, Fedora 44, kernel 6.19.10-300.fc44.x86_64
- Session: GDM -> UWSM (hyprland-uwsm) -> Hyprland 0.56.2
- This backup is a standalone snapshot taken BEFORE any cleanup modifications.

## Structure

| Path | Contents |
|---|---|
| `config/` | Snapshot of the relevant user configuration (see list below) |
| `config/systemd/user/` | User systemd config incl. `graphical-session.target.wants/swaync.service` symlink |
| `wallpaper/active_wallpaper.png` | Copy of the current wallpaper (`~/.config/hypr/current_wallpaper` -> `~/Pictures/wallpapers/wallpaper.png`) |
| `runtime/` | Pre-change runtime state: hyprctl version/monitors/clients/binds/layers/configerrors, systemctl --user state |
| `BACKUP_MANIFEST.tsv` | Machine-readable manifest: path, type, size, perms, uid:gid, mtime, symlink targets |
| `CHECKSUMS.sha256` | sha256 of every backed-up regular file (115 files), verified OK |

## Directories included

```
~/.config/hypr        (incl. scripts/, colors.conf, current_wallpaper symlink preserved)
~/.config/waybar      (incl. configs/, style/, Modules*, scripts/ [empty])
~/.config/swaync      (incl. icons/, images/, themes/, config.json.bak-*)
~/.config/wlogout     (incl. icons/, layout.bak-*)
~/.config/matugen     (incl. templates/)
~/.config/gtk-3.0     (colors.css, bookmarks)
~/.config/gtk-4.0     (colors.css)
~/.config/kitty       (incl. kitty.conf.bak)
~/.config/cava        (incl. shaders/)
~/.config/systemd     (user-level only)
~/.config/vesktop     (8K — included for completeness)
~/.config/spotify     (24K — included for completeness)
```

## Deliberately NOT included (and why)

| Item | Reason |
|---|---|
| `~/.config/config-before-binnewbs` (9.4 GB) | Historical backup tree; unknown contents. Disposition is investigated separately (see CLEANUP_STATUS.md). NOT deleted. |
| `~/Pictures/wallpapers` (195 MB) | Personal media; only the ACTIVE wallpaper was backed up. Config modifications cannot destroy these files. |
| `~/.cache/cliphist/db` (40 MB, mode 644) | Clipboard database — privacy-sensitive. Cleared/pruning handled in a later stage; contents are copied nowhere. |
| `~/.config/gh`, `~/.config/google-chrome`, `~/Code`, etc. | Unrelated app data / credentials / personal files. Out of scope. |
| `/usr/lib/systemd/user/*` (waybar, hypridle, swaync, hyprpolkitagent units) | System-managed vendor files; not user-owned. Their definitions are reproduced in BASELINE.md for reference. |

## Sensitive-material review

- Reviewed backup contents for tokens/keys/credentials: none found in the included config trees.
- `gcloud/gh/ssh/spotify credential` trees are excluded by scope.
- Clipboard history DB excluded explicitly.

## Integrity verification performed

- `sha256sum -c CHECKSUMS.sha256` → OK (115/115 files).
- Content-hash diff between source tree and backup tree → identical.
- Symlink list diff (name + target) between source and backup → identical. Symlinks preserved as symlinks (`--links` semantics via rsync `-a`), notably:
  - `config/hypr/current_wallpaper -> /home/anique/Pictures/wallpapers/wallpaper.png`
  - `config/hypr/scripts/Brightness.sh -> /home/anique/.config/hypr/scripts/brightness.sh`
  - `config/systemd/user/graphical-session.target.wants/swaync.service -> /usr/lib/systemd/user/swaync.service`

## Restore procedure

```bash
# restore a single tree, e.g. hypr:
rm  -rf ~/.config/hypr
cp -a ~/backup_november/config/hypr ~/.config/hypr
# then: hyprctl reload / restart waybar etc. as applicable
```
