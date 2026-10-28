#!/usr/bin/env bash
# Zazzu :: clipboard history picker (cliphist + wofi)

set -euo pipefail

entry="$(cliphist list | wofi --dmenu --prompt 'clipboard' --width 720 --height 520 --cache-file /dev/null)" || exit 0
[ -n "$entry" ] || exit 0

printf '%s' "$entry" | cliphist decode | wl-copy
