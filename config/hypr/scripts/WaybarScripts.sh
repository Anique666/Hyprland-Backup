#!/bin/bash

case "${1:-}" in
	--nmtui)
		if command -v nmtui >/dev/null 2>&1; then
			exec kitty -e nmtui
		fi
		exec /usr/bin/nm-connection-editor
		;;
	--btop)
		if command -v btop >/dev/null 2>&1; then
			exec kitty -e btop
		fi
		exit 1
		;;
	*)
		exit 1
		;;
esac
