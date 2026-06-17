#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
SCRIPT_NAME="$(basename "$0")"

declare -A LINKS
LINKS=(
  [".config/hypr/vars.conf"]="$HOME/.config/hypr/vars.conf"
  [".config/hypr/theme.conf"]="$HOME/.config/hypr/theme.conf"
  [".config/hypr/hyprland.conf"]="$HOME/.config/hypr/hyprland.conf"
  [".config/hypr/hyprlock.conf"]="$HOME/.config/hypr/hyprlock.conf"
  [".config/hypr/hypridle.conf"]="$HOME/.config/hypr/hypridle.conf"
  [".config/hypr/hyprpaper.conf"]="$HOME/.config/hypr/hyprpaper.conf"
  [".config/hypr/scripts/matrix-rain"]="$HOME/.config/hypr/scripts/matrix-rain"
  [".config/kitty/cybrcore.conf"]="$HOME/.config/kitty/cybrcore.conf"
  [".config/waybar/config.jsonc"]="$HOME/.config/waybar/config.jsonc"
  [".config/waybar/style.css"]="$HOME/.config/waybar/style.css"
  [".config/waybar/modules.jsonc"]="$HOME/.config/waybar/modules.jsonc"
  [".config/waybar/svg"]="$HOME/.config/waybar/svg"
  [".config/rofi/config.rasi"]="$HOME/.config/rofi/config.rasi"
  [".config/rofi/style.rasi"]="$HOME/.config/rofi/style.rasi"
  [".config/rofi/launcher.rasi"]="$HOME/.config/rofi/launcher.rasi"
  [".config/rofi/theme"]="$HOME/.config/rofi/theme"
  [".config/rofi/scripts"]="$HOME/.config/rofi/scripts"
  [".config/dunst/dunstrc"]="$HOME/.config/dunst/dunstrc"
  [".config/fastfetch/config.jsonc"]="$HOME/.config/fastfetch/config.jsonc"
  [".config/cava/config"]="$HOME/.config/cava/config"
  [".config/starship.toml"]="$HOME/.config/starship.toml"
  [".config/swaync/config.json"]="$HOME/.config/swaync/config.json"
  [".config/swaync/style.css"]="$HOME/.config/swaync/style.css"
  [".config/tmux/tmux.conf"]="$HOME/.config/tmux/tmux.conf"
  [".tmux.conf"]="$HOME/.tmux.conf"
  [".config/firefoxhome.html"]="$HOME/.config/firefoxhome.html"
  [".config/gtk-3.0/settings.ini"]="$HOME/.config/gtk-3.0/settings.ini"
  [".gtkrc-2.0"]="$HOME/.gtkrc-2.0"
  ["walls/matrix-2560x1440.png"]="$HOME/.config/hypr/walls/matrix-2560x1440.png"
)

echo "  Matrix dotfiles installer"
echo "────────────────────────────"
echo ""

backup() {
  echo "  Creating backup at $BACKUP_DIR ..."
  mkdir -p "$BACKUP_DIR"
  for src in "${!LINKS[@]}"; do
    target="${LINKS[$src]}"
    if [ -f "$target" ] || [ -d "$target" ]; then
      rel_target="${target/#$HOME\//}"
      bak_dir="$BACKUP_DIR/$(dirname "$rel_target")"
      mkdir -p "$bak_dir"
      cp -r "$target" "$bak_dir/"
    fi
  done
  echo "  Done. Existing files backed up to $BACKUP_DIR"
  echo ""
}

install() {
  for src in "${!LINKS[@]}"; do
    target="${LINKS[$src]}"
    dotfile="$DOTFILES_DIR/$src"

    # Remove existing file/dir/symlink
    rm -rf "$target" 2>/dev/null || true

    # Ensure parent directory exists
    mkdir -p "$(dirname "$target")"

    # Create symlink
    ln -sf "$dotfile" "$target"
    echo "    symlinked  $src  →  $target"
  done
  echo ""
  echo "  Done. All dotfiles installed."
}

backup
install

echo ""
echo "  Reload your config:"
echo "    hyprctl reload           # Hyprland"
echo "    pkill waybar && waybar   # Waybar"
echo "    pkill swaync && swaync   # SwayNC"
echo "    tmux kill-server         # Tmux"
echo "    source ~/.config/starship.toml  # Starship"
