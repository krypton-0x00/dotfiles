#!/usr/bin/env bash
# Zazzu :: power menu

set -euo pipefail

entries="lock
logout
suspend
reboot
shutdown"

choice="$(printf '%s\n' "$entries" | wofi --dmenu --prompt 'power' --width 260 --height 300 --cache-file /dev/null)" || exit 0
[ -n "$choice" ] || exit 0

confirm() {
    local answer
    answer="$(printf 'no\nyes\n' | wofi --dmenu --prompt "$1" --width 220 --height 120 --cache-file /dev/null)" || exit 0
    [ "$answer" = "yes" ]
}

case "$choice" in
    lock)     hyprlock ;;
    logout)   hyprctl dispatch 'hl.dsp.exit()' ;;
    suspend)  systemctl suspend ;;
    reboot)   confirm "reboot?" && systemctl reboot ;;
    shutdown) confirm "shutdown?" && systemctl poweroff ;;
esac
