#!/bin/bash
# lock-before-suspend.sh
# Request the session lock, wait briefly for Hyprlock to come up, then suspend.
# Designed for hypridle's suspend listener and wlogout's suspend button.
#
# Note: logind does not wait for hypridle's before_sleep_cmd (it is a
# notification, not a barrier), so suspend jobs we control directly get
# ordered here instead.
#
# Failure modes:
# - If no hyprlock process appears within the timeout we log a warning,
#   notify the user, and STILL suspend (battery/thermal safety outweighs
#   an unlocked resume here; the screen-off + lock-on-resume paths recover).
set -u

LOG_TAG="lock-before-suspend"
LOG_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/hypr/lock-before-suspend.log"
mkdir -p "$(dirname "$LOG_FILE")"
log() { printf '%s %s: %s\n' "$(date '+%F %T')" "$LOG_TAG" "$*" >> "$LOG_FILE" 2>/dev/null; }

are_locked() {
    pidof hyprlock >/dev/null 2>&1
}

log "suspend requested"

if ! are_locked; then
    if ! loginctl lock-session; then
        log "ERROR: loginctl lock-session failed"
    fi

    # Wait up to 3s for hyprlock to appear, then give it a short settle
    # delay so the ext-session-lock is engaged before we suspend.
    waited=0
    while ! are_locked; do
        sleep 0.1
        waited=$((waited + 100))
        if [ "$waited" -ge 3000 ]; then
            log "ERROR: hyprlock did not spawn within 3s - suspending anyway"
            notify-send -u critical -t 5000 "Suspend warning" \
                "Session lock failed to start before suspend" 2>/dev/null
            break
        fi
    done

    if are_locked; then
        # Allow Hyprlock to complete session-lock acquisition/render.
        sleep 0.5
        log "lock present after ${waited}ms + settle; suspending"
    fi
else
    log "lock already present; suspending"
fi

exec systemctl suspend
