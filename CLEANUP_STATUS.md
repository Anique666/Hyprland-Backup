# CLEANUP STATUS

## Stage tracker

| Stage | Status |
|---|---|
| 0. Backup + GitHub initial push | ✅ done — commit fa0ef59, verified on origin/main |
| 1. Baseline documentation | ✅ done — commit 1ad42b0 |
| 2. Hyprlock repair | ✅ done — commit c3d4790; 0 config errors, lock+PAM prompt reached |
| 3. Hypridle / lock / suspend ownership | ✅ done — commit 94fde49; systemd unit active, single process |
| 4. Essential functionality (volume.sh, Waybar tray/fonts, wlogout, GTK imports) | ✅ done — commit 626c2db |
| 5. Dead dependency cleanup (zsh/rofi scripts, wppicker rewrite) | ✅ done — commit b143056 |
| 6. Matugen consistency | ✅ done — commit 96fd783; full regeneration idempotent (all outputs byte-identical) |
| 7. Waybar/SwayNC/wlogout prune + systemd ownership | ✅ done — commit c941664 |
| 8. Cliphist privacy | ✅ done — commit 643ca64; db 0600, 750-item bound verified |
| 9. Final dead cleanup + historical backup investigation | ✅ done — commit 1f04f18; unique files archived, 9.4 GB tree untouched |
| 10. Final regression + report | ✅ done — final commit on cleanup/november; report delivered |

## Verified in final regression (2026-11-02)

- Session: `Hyprland / hyprland-uwsm`, Hyprland 0.56.2 (COPR), unchanged.
- `hyprctl configerrors`: empty.
- `systemctl --user --failed`: 0 units.
- Daemons: waybar, hypridle, swaync, hyprpolkitagent — all active, exactly 1 process each.
- Displays/workspaces: eDP-1 → ws1, HDMI-A-1 → ws2/3; mapping preserved.
- `current_wallpaper` symlink intact → `~/Pictures/wallpapers/wallpaper.png`.
- cliphist db mode 600, 750 items; config `max-items 750`.
- No secrets found in repo; cliphist DB backup is git-ignored.
- Local `cleanup/november` == `origin/cleanup/november` at time of report.
- `main` remains the pristine initial snapshot (fa0ef59); never rewritten.

## Deferred (not this phase)

- Lua migration (hyprland.lua / colors.lua) — explicitly excluded; not started.
- Workspace redesign — mapping preserved (ws1=eDP-1, ws2-10=HDMI-A-1).
- Hyprland upgrade — stays 0.56.2 (COPR).
- Visual redesign — appearance intentionally unchanged.

## User-required verification (not claimed as passed)

These are physical/visual checks that cannot be automated:

1. Waybar glyph rendering (tray icons, Nerd Font symbols) on both outputs.
2. Hyprlock glyphs + unlock with SUPER+L and password.
3. wlogout layout/glyphs and each action.
4. SwayNC notification center UI and Do Not Disturb toggle.
5. Actual suspend/resume: manual, idle (7200 s), and lid close.
6. 600 s idle lock behavior.
7. Brightness restore (`brightnessctl -r`) after resume.
8. SUPER+C clipboard selection UI (store/decode pipeline already verified).
9. Logout/login persistence of the four systemd user units.

## Known limitations / residual issues

- Idle suspend path locks first (`lock-before-suspend.sh`); the lid-close path does not use that wrapper (logind default lid handling, unchanged). Documented residual limitation.
- Alternate Waybar stylesheets (`waybar/style/*.css`) still contain `#custom-cava_mviz` selectors. They are inactive files, deliberately untouched; the active `style.css` was cleaned.
- Spicetify Matugen template removed: active theme is Dribbblish/lunar, so the template fed an unused theme. Recoverable from `main` if the "text" theme is ever activated.
- `~/backup_november/cliphist/db.bak-20261101` contains clipboard data and is intentionally git-ignored/never pushed.
- Historial tree `~/.config/config-before-binnewbs` (9.4 GB): dominated by stale Chrome (4.7 GB) and Firefox (52 MB) profile copies. Unique small configs archived under `backup_november/extra/config-before-binnewbs-unique/`. Tree left intact pending user decision; recommended: delete `google-chrome/` and `mozilla/`, archive the small config remainder outside `~/.config`.

## Post-cleanup visual restoration (2026-11-02)

- Waybar: original font (`JetBrainsMono Nerd Font Propo`) and glyphs restored; tray applets removed from the bar; clock alternate date is `Monday, 02 November, 2026`.
- Hyprlock: minimal layout restored; weather and username removed; 12-hour clock with AM/PM.
- Font dependency: Nerd Fonts v3.5.1 JetBrainsMono installed at `~/.local/share/fonts/JetBrainsMonoNerdFont/` (not tracked by git).
- Manual checks remaining: `SUPER+L` + password, HDMI bar after exiting fullscreen, tray icon visibility.
