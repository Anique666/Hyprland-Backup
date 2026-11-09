#!/usr/bin/env bash
# Screen brightness control with a SwayNC progress notification.
set -euo pipefail

step="${BRIGHTNESS_STEP:-10}"
direction="${1:-}"

case "$direction" in
    up)   brightnessctl set "${step}%+" >/dev/null ;;
    down) brightnessctl set "${step}%-" >/dev/null ;;
    *)
        echo "usage: $0 up|down" >&2
        exit 2
        ;;
esac

percent="$(brightnessctl -m | awk -F, '{ gsub(/%/, "", $4); print $4 }')"
case "$percent" in
    ''|*[!0-9]*) percent=0 ;;
esac

if   (( percent <= 20 )); then icon="brightness-20"
elif (( percent <= 40 )); then icon="brightness-40"
elif (( percent <= 60 )); then icon="brightness-60"
elif (( percent <= 80 )); then icon="brightness-80"
else icon="brightness-100"
fi

notify-send \
    -e \
    -u low \
    -t 1500 \
    -i "$HOME/.config/swaync/icons/${icon}.png" \
    -h string:x-canonical-private-synchronous:brightness \
    -h int:value:"$percent" \
    "Brightness" "${percent}%"
