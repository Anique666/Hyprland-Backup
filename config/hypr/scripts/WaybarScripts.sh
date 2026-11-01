#!/bin/bash

case "${1:-}" in
	--nmtui)
		if command -v nmtui >/dev/null 2>&1; then
			exec kitty -e nmtui
		fi
		exec /usr/bin/nm-connection-editor
		;;
	*)
		exit 1
		;;
esac
