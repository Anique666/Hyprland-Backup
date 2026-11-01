#!/usr/bin/env bash
set -euo pipefail

screenshot_dir="$HOME/Pictures/Screenshots"
mkdir -p "$screenshot_dir"

timestamp="$(date '+%Y-%m-%d_%H-%M-%S')"
output="$screenshot_dir/${timestamp}.png"
counter=1
while [[ -e "$output" ]]; do
    output="$screenshot_dir/${timestamp}_${counter}.png"
    counter=$((counter + 1))
done

geometry="$(slurp)"
grim -g "$geometry" "$output"
wl-copy --type image/png < "$output"
