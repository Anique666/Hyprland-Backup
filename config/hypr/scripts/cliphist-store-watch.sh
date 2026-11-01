#!/bin/bash
# cliphist-store-watch.sh — starts a wl-paste cliphist watcher with a private umask
# so the cliphist database (and any recreated database) is user-only (0600).
umask 077
exec wl-paste --type "$1" --watch cliphist store
