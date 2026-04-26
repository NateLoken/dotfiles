#!/usr/bin/env bash

set -u

state="${1:-suspend}"

if ! pidof hyprlock >/dev/null 2>&1; then
    hyprlock >/dev/null 2>&1 &
    sleep 1
fi

case "$state" in
    suspend)
        systemctl suspend -i
        ;;
    hibernate)
        systemctl hibernate -i
        ;;
    *)
        exit 2
        ;;
esac
