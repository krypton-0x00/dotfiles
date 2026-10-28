#!/usr/bin/env bash
# Zazzu :: volume helper
# usage: volume.sh [up|down|mute|mic]

set -euo pipefail

action="${1:-up}"
step="${VOLUME_STEP:-5}"

notify() {
    command -v notify-send >/dev/null 2>&1 && \
        notify-send -a volume -h string:x-dunst-stack-tag:volume "$@"
}

case "$action" in
    up)
        pamixer -i "$step"
        vol="$(pamixer --get-volume)"
        notify -i audio-volume-high -h int:value:"$vol" "Volume" "${vol}%"
        ;;
    down)
        pamixer -d "$step"
        vol="$(pamixer --get-volume)"
        notify -i audio-volume-low -h int:value:"$vol" "Volume" "${vol}%"
        ;;
    mute)
        pamixer -t
        if pamixer --get-mute | grep -q true; then
            notify -i audio-volume-muted "Volume" "muted"
        else
            vol="$(pamixer --get-volume)"
            notify -i audio-volume-high -h int:value:"$vol" "Volume" "${vol}%"
        fi
        ;;
    mic)
        pamixer --default-source -t
        if pamixer --default-source --get-mute | grep -q true; then
            notify -i microphone-sensitivity-muted "Microphone" "muted"
        else
            notify -i microphone-sensitivity-high "Microphone" "live"
        fi
        ;;
    *)
        echo "usage: $0 [up|down|mute|mic]" >&2
        exit 2
        ;;
esac
