#!/usr/bin/env bash
# Zazzu :: wallpaper picker (hyprpaper)

set -euo pipefail

wall_dir="$HOME/.config/hypr/wallpapers"

mapfile -t walls < <(
    find "$wall_dir" "$HOME/Pictures" -maxdepth 2 -type f \
        \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) \
        2>/dev/null | sort
)

[ "${#walls[@]}" -gt 0 ] || { notify-send -a wallpaper "Wallpaper" "no images found"; exit 0; }

choice="$(printf '%s\n' "${walls[@]}" | wofi --dmenu --prompt 'wallpaper' --width 760 --height 480 --cache-file /dev/null)" || exit 0
[ -n "$choice" ] || exit 0

hyprctl hyprpaper unload all >/dev/null 2>&1 || true
hyprctl hyprpaper preload "$choice" >/dev/null 2>&1 || true
hyprctl hyprpaper wallpaper ",$choice" >/dev/null 2>&1 || true

notify-send -a wallpaper -i preferences-desktop-wallpaper "Wallpaper" "$(basename "$choice")"
