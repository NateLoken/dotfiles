#!/usr/bin/env bash

set -u

state="${1:-suspend}"

arm_update_wakeup() {
    local days_until_sunday now target_date wake_time

    now=$(date +%s)
    days_until_sunday=$((7 - $(date +%u)))
    target_date=$(date --date="${days_until_sunday} days" +%F)
    wake_time=$(date --date="$target_date 00:00 4 minutes ago" +%s)

    if ((wake_time <= now)); then
        target_date=$(date --date="$((days_until_sunday + 7)) days" +%F)
        wake_time=$(date --date="$target_date 00:00 4 minutes ago" +%s)
    fi

    sudo -n /usr/bin/rtcwake --mode no --time "$wake_time"
}

if ! pidof hyprlock >/dev/null 2>&1; then
    hyprlock >/dev/null 2>&1 &
    sleep 1
fi

case "$state" in
    suspend)
        arm_update_wakeup || {
            notify-send --urgency=critical "Suspend cancelled" \
                "Could not arm the RTC wake alarm for Sunday's system update."
            exit 1
        }
        loginctl suspend
        ;;
    hibernate)
        loginctl hibernate
        ;;
    *)
        exit 2
        ;;
esac
