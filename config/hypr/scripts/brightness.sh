#!/usr/bin/env bash
# Zazzu :: brightness helper (no-op with a notification on machines without a backlight)

set -euo pipefail

action="${1:-up}"

notify() {
    command -v notify-send >/dev/null 2>&1 && \
        notify-send -a brightness -h string:x-dunst-stack-tag:brightness "$@"
}

if ! command -v brightnessctl >/dev/null 2>&1; then
    notify -i display-brightness "Brightness" "brightnessctl is not installed"
    exit 0
fi

case "$action" in
    up)
        if ! brightnessctl -q set 5%+ 2>/dev/null; then
            notify -i display-brightness "Brightness" "no backlight device"
            exit 0
        fi
        ;;
    down)
        if ! brightnessctl -q set 5%- 2>/dev/null; then
            notify -i display-brightness "Brightness" "no backlight device"
            exit 0
        fi
        ;;
    *)
        echo "usage: $0 [up|down]" >&2
        exit 2
        ;;
esac

percent="$(brightnessctl -m | awk -F, '{print $4}' | tr -d '%')"
notify -i display-brightness -h int:value:"$percent" "Brightness" "${percent}%"
