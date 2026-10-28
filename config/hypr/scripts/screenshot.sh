#!/usr/bin/env bash
# Zazzu :: screenshot helper
# usage: screenshot.sh [region|full|window|swappy]

set -euo pipefail

mode="${1:-region}"
dir="${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
mkdir -p "$dir"
file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"

notify() {
    command -v notify-send >/dev/null 2>&1 && \
        notify-send -a screenshot -i camera-photo -h string:x-dunst-stack-tag:screenshot "$@"
}

case "$mode" in
    region)
        geometry="$(slurp -d 2>/dev/null || true)"
        [ -n "$geometry" ] || exit 0
        grim -g "$geometry" "$file"
        ;;
    window)
        geometry="$(hyprctl activewindow -j | jq -r '
            if .address == "0x0" then empty
            else "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"
            end' 2>/dev/null || true)"
        if [ -n "$geometry" ]; then
            grim -g "$geometry" "$file"
        else
            grim "$file"
        fi
        ;;
    full)
        grim "$file"
        ;;
    swappy)
        grim "$file"
        wl-copy < "$file"
        swappy -f "$file" >/dev/null 2>&1 || true
        notify "Screenshot" "Saved to $file"
        exit 0
        ;;
    *)
        echo "usage: $0 [region|full|window|swappy]" >&2
        exit 2
        ;;
esac

[ -s "$file" ] || exit 1
wl-copy < "$file"
notify "Screenshot" "Copied to clipboard\n$file"
