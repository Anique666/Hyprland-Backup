#!/bin/bash

# Wallpaper picker using wofi (replaces the rofi-based version).
# Selection is validated before the active wallpaper is touched:
# 1. pick a file via wofi dmenu
# 2. generate the Matugen palette from the candidate
# 3. only then update the current_wallpaper symlink
# The present wallpaper stays active until step 3 succeeds.

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"

command -v wofi  >/dev/null 2>&1 || exit 1
command -v matugen >/dev/null 2>&1 || exit 1

SELECTED_PATH=$(wofi --dmenu --prompt 'Wallpaper' \
	< <(find "$WALLPAPER_DIR" -maxdepth 1 \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' -o -iname '*.gif' \) -printf '%p\n' | sort))

[ -n "$SELECTED_PATH" ] && [[ -f "$SELECTED_PATH" ]] || exit 0

# Validate the candidate: generate colors from it BEFORE switching.
if ! matugen image "$SELECTED_PATH"; then
	notify-send -u low -i "$HOME/.config/swaync/images/lock.png" "Wallpaper" "Matugen failed - wallpaper unchanged" 2>/dev/null
	exit 1
fi

mkdir -p "$(dirname "$SYMLINK_PATH")"
ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"
