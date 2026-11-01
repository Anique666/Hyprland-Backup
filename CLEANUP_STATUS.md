# CLEANUP STATUS

## Stage tracker

| Stage | Status |
|---|---|
| 0. Backup + GitHub initial push | ✅ done (commit fa0ef59, verified remote) |
| 1. Baseline documentation | ✅ done |
| 2. Hyprlock repair | pending |
| 3. Hypridle / lock / suspend | pending |
| 4. Essential functionality (volume.sh, waybar tray/fonts, wlogout, GTK imports) | pending |
| 5. Dead dependency cleanup (zsh/rofi scripts, wppicker rewrite) | pending |
| 6. Matugen consistency | pending |
| 7. Waybar/SwayNC/wlogout prune + systemd ownership | pending |
| 8. Cliphist privacy | pending |
| 9. Final dead cleanup + historical backup investigation | pending |
| 10. Final regression + report | pending |

## Deferred (not this phase)

- Lua migration (hyprland.lua / colors.lua) — explicitly excluded.
- Workspace redesign — mapping preserved (ws1=eDP-1, ws2-10=HDMI-A-1).
- Hyprland upgrade — stays 0.56.2.
- Visual redesign.

## Known limitations / uncertainty

- config-before-binnewbs (9.4 GB) not yet inspected (controlled by Stage 9).
- Spicetify template retention depends on Stage 6 verification.
