#!/bin/bash

set -u

mapfile -t wifi_rows < <(
	nmcli -t --escape no \
		-f IN-USE,SSID,SIGNAL,SECURITY dev wifi list --rescan no
)

entries=()
ssids=()
securities=()

for row in "${wifi_rows[@]}"; do
	IFS=: read -r -a fields <<< "$row"
	field_count=${#fields[@]}
	in_use="${fields[0]}"
	signal="${fields[$((field_count - 2))]}"
	security="${fields[$((field_count - 1))]}"
	ssid=""
	for ((field = 1; field < field_count - 2; field++)); do
		[ -n "$ssid" ] && ssid+=:
		ssid+="${fields[$field]}"
	done
	[ -n "$ssid" ] || continue

	marker="  "
	[ "$in_use" = "*" ] && marker="● "
	entries+=("$marker$ssid  ($signal%, $security)")
	ssids+=("$ssid")
	securities+=("$security")
done

[ "${#entries[@]}" -gt 0 ] || exit 0

choice=$(printf '%s\n' "${entries[@]}" | wofi --dmenu --prompt 'Wi-Fi')
[ -n "$choice" ] || exit 0

selected=-1
for i in "${!entries[@]}"; do
	if [ "${entries[$i]}" = "$choice" ]; then
		selected=$i
		break
	fi
done

[ "$selected" -ge 0 ] || exit 0
ssid="${ssids[$selected]}"

if nmcli dev wifi connect "$ssid" >/dev/null 2>&1; then
	exit 0
fi

case "${securities[$selected]}" in
""|"--") exit 1 ;;
esac

password=$(printf '' | wofi --dmenu --password --prompt "Password for $ssid")
[ -n "$password" ] || exit 0

nmcli dev wifi connect "$ssid" password "$password"
