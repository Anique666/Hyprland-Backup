#!/bin/zsh

killall -9 waybar
systemctl --user restart swaync.service

waybar &
