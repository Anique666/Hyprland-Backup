# BASELINE — November Fedora Hyprland Desktop (pre-cleanup)

Captured 2026-11-01 ~21:45 IST. Machine: `fedora`, Fedora 44, kernel 6.19.10-300.fc44.x86_64.
Runtime snapshots in `runtime/` (version.txt, monitors.json, clients.json, binds.json, layers.json, configerrors.txt, user_failed.txt, user_services.txt).

## Environment

| Item | Value (verified) |
|---|---|
| OS | Fedora 44 Workstation |
| Kernel | 6.19.10-300.fc44.x86_64 |
| Session | DESKTOP_SESSION=hyprland-uwsm, WAYLAND_DISPLAY=wayland-1, XDG_CURRENT_DESKTOP=Hyprland |
| Hyprland | 0.56.2 (COPR package: hyprland-0.56.2-2.fc44.x86_64) — NOT to be changed |
| Hyprlock | 0.9.6 |
| Hypridle | 0.1.8 (running via exec-once, PID 1937) |
| Waybar | 0.15.0 (running via exec-once, PID 1935) |
| SwayNC | systemd user service, active since 01:12, MainPID 2087 |
| hyprpolkitagent | active (started by exec-once `systemctl --user start`) |
| awww | 0.12.1, awww-daemon PID 1936 |
| wofi | 1.5.3 (no user config dir; invoked via `wofi --show drun` and `--dmenu`) |
| kitty | 0.48.2 style (config uses `JetBrainsMono NF Bold` — font NOT installed) |
| cliphist | 0.7.0, DB ~/.cache/cliphist/db 40 MB mode 644 |
| Matugen | 4.1.0 |
| wlogout | 1.2.2 |
| cava | 0.10.2 |
| uwsm | 0.26.4 |

## Displays (hyprctl monitors)

- eDP-1 1920x1080@144.00 — workspace 1
- HDMI-A-1 1920x1080@179.96 — workspace 2
- Workspace mapping: ws 1 → eDP-1, ws 2–10 → HDMI-A-1. **Preserve.**

## Pre-change configuration issues (verified against files)

### hypr/hyprlock.conf
1. `general.grace = 1` — not a supported Hyprlock 0.9.x option (audit: invalid).
2. `#label {` around "Degrees": `label` commented out, closing `}` not → parses as broken key + orphan block.
3. Same for "USER" section.
4. `dots_rouding = -1` — typo of `dots_rounding`.
5. `source = colors.conf` relative source; `$Scripts` var defined but unused.
6. Fonts: `JetBrainsMono NFM`, `JetBrainsMono Nerd Font 10`, `JetBrainsMono NFM Bold` — none installed. Installed: `JetBrains Mono`, `Cascadia Mono NF`, `Adwaita Sans`, `Adwaita Mono`, `Font Awesome 6 Free`.
7. Clock: two `cmd[update:1000]` labels (hours+minutes, 1/s refresh each).
8. Date/week: `cmd[update:18000000]` (~5 h — misses midnight rollover).

### hypr/hypridle.conf
- Started by `exec-once = hypridle` (hypridle.service exists but disabled).
- Thresholds: 150 dim(brightnessctl -s set 10), 600 `loginctl lock-session`, 1800 dpms off, 7200 `systemctl suspend`; `before_sleep_cmd = loginctl lock-session`; restore `brightnessctl -r` present on both listeners. Preserve thresholds.
- lid drop-in /etc/systemd/logind.conf.d/10-lid-suspend.conf: suspend on all lid switches.

### hypr/hyprland.conf
- `exec-once` list: waybar, gnome-keyring (secrets), dbus-update-activation-environment, awww-daemon, hypridle, nm-applet, blueman-applet, `systemctl --user start hyprpolkitagent`, wl-paste cliphist watcher x2.
- SUPER+L → `hyprlock` directly. SUPER+P → Wlogout.sh. Screenshot SUPER+SHIFT+S → screenshot.sh.
- SUPER+C → cliphist list | wofi --dmenu | cliphist decode | wl-copy.
- Volume/brightness via wpctl/brightnessctl bindel binds (no volume.sh in binds).

### Scripts (~/.config/hypr/scripts)
| Script | Status |
|---|---|
| AirplaneMode.sh | working (rfkill + swaync icon) |
| brightness.sh (+Brightness.sh symlink) | referenced by Waybar backlight scroll; hardware uses bindel XF86 keys |
| hyprlock.sh | `#!/bin/zsh` — zsh NOT installed (dead) |
| KillActiveProcess.sh | no caller found |
| NetworkSelector.sh | working wofi-based wifi joiner |
| screenshot.sh | working (slurp+grim+wl-copy) |
| volume.sh | Calls missing Sounds.sh; `dec_mic_volume` → `toggle-mic` (wrong name); stray `u` in `pamixer -u --default-source u`; Waybar scroll/click hooks use it |
| waybarcava.sh | cava visualizer for waybar; waybar does NOT include custom/cava_mviz currently |
| WaybarLayout.sh / WaybarStyles.sh | require missing rofi + wbrestart.sh (dead) |
| WaybarScripts.sh | only implements --nmtui; --nvtop/--btop called from Modules but missing |
| wbrestart.sh | `#!/bin/zsh` (dead); .bak variant too |
| Wlogout.sh | working wlogout launcher |
| wppicker.sh | requires missing rofi (dead) — to be rewritten with wofi |

### Waybar
- config include list contains `UserModules` (doesn't exist). No UserScripts refs found.
- modules-right: group/notify, battery, network, separator, group/audio (pulseaudio + mic), bluetooth, separator, custom/power. **No tray module** though nm-applet/blueman-applet run.
- Modules: clock `interval: 1` without seconds. custom/spotify polls playerctl every 2s. mpris module defined but not used in bar (commented out).
- style.css font: "JetBrainsMono Nerd Font Propo" — not installed.
- On-click hooks referencing dead scripts: ChangeBlur.sh, WaybarStyles.sh, WaybarLayout.sh, LockScreen.sh, Kool_Quick_Settings.sh, Wallpapers/KeyHints/KeyBinds/NewsUpdate/Hypridle.sh/DarkLight/Distro_update/Weather etc. (all in commented-out or unused modules; must prune only what is in the active bar).
- Battery: bat BAT1.

### SwayNC
- config.json buttons-grid lock button → `bash -c $HOME/.config/hypr/scripts/hyprlock.sh` (dead zsh script).
- style.css imports: waybar colors.css + themes/control_center.css + themes/notifications.css. themes/jakoolit.css unused.
- control_center.css and notifications.css both redefine text/background-alt/selected/hover/urgent → conflicting definitions.

### wlogout
- layout: shutdown/reboot/suspend only. style.css: `@import` placed AFTER rules (GTK CSS import must be first); font "JetBrains Mono NFM" not installed.

### Matugen
- config.toml templates: waybar, kitty, hyprland, gtk3, gtk4, rofi (input template missing!), cava, spicetify, vesktop.
- colors.conf (hyprland output) has repeated `$image = ...` artifact line before each variable (template line `$image = {{image}}` inside loop).
- GTK colors.css generated in gtk-3.0 and gtk-4.0 but no `gtk.css` importing them.
- Spotify (client) + spicetify installed; ~/.config/spotify exists. Vesktop NOT installed (only themes dir 8K).
- cava template: uses gradient colors; cava/config includes both `method = pulse` and `method = pipewire` active sections.

### Fonts installed (fc-list)
JetBrains Mono (all weights), Cascadia Mono NF (all weights), Adwaita Sans, Adwaita Mono, Font Awesome 6 Free + Brands.

### systemd user units (packaged, /usr/lib/systemd/user/)
- waybar.service — exists, disabled. Restart=on-failure.
- hypridle.service — exists, disabled. Restart=on-failure.
- swaync.service — active + enabled (only entry in graphical-session.target.wants).
- hyprpolkitagent.service — active (started manually each session).

## Diagram-critical facts to preserve
- UWSM env vars; GDM session "hyprland-uwsm"
- SwayNC already systemd-managed — never double-start
- NVIDIA vendor config untouched
- cliphist watchers currently wl-paste --watch via exec-once
