#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

AUR_HELPER="${AUR_HELPER:-yay}"

PACKAGES_OFFICIAL=(
  base-devel btop brightnessctl cava dunst easyeffects fastfetch fd-find
  firefox fish flameshot flatpak grim gtk3 gtk4 hyprland jq kitty
  libreoffice-fresh micro mpd mpc mpv nemo network-manager-applet
  networkmanager nvtop obs-studio pavucontrol pipewire playerctl
  polkit-gnome python python-gobject qt5ct qt6ct retroarch rofi
  slurp spotify-launcher starship swaync swayosd tmux
  ttf-hack-nerd-font udiskie waybar wf-recorder wireplumber
  wl-clipboard xdg-desktop-portal xdg-desktop-portal-hyprland
  xclip yazi zoxide
)

PACKAGES_AUR=(
  cava cliphist hyprpicker keyb nwg-look obsidian overskride
  python-hijridate rofimoji satthy ttf-geist-mono-nerd-font
  vesktop-bin waybar-updates wleave
)

declare -A LINKS
LINKS=(
  [".config/hypr/vars.conf"]="$HOME/.config/hypr/vars.conf"
  [".config/hypr/theme.conf"]="$HOME/.config/hypr/theme.conf"
  [".config/hypr/hyprland.conf"]="$HOME/.config/hypr/hyprland.conf"
  [".config/hypr/hyprlock.conf"]="$HOME/.config/hypr/hyprlock.conf"
  [".config/hypr/hypridle.conf"]="$HOME/.config/hypr/hypridle.conf"
  [".config/hypr/hyprpaper.conf"]="$HOME/.config/hypr/hyprpaper.conf"
  [".config/hypr/scripts"]="$HOME/.config/hypr/scripts"
  [".config/kitty/cybrcore.conf"]="$HOME/.config/kitty/cybrcore.conf"
  [".config/waybar/config.jsonc"]="$HOME/.config/waybar/config.jsonc"
  [".config/waybar/style.css"]="$HOME/.config/waybar/style.css"
  [".config/waybar/modules.jsonc"]="$HOME/.config/waybar/modules.jsonc"
  [".config/waybar/svg"]="$HOME/.config/waybar/svg"
  [".config/waybar/scripts"]="$HOME/.config/waybar/scripts"
  [".config/rofi/config.rasi"]="$HOME/.config/rofi/config.rasi"
  [".config/rofi/style.rasi"]="$HOME/.config/rofi/style.rasi"
  [".config/rofi/launcher.rasi"]="$HOME/.config/rofi/launcher.rasi"
  [".config/rofi/theme"]="$HOME/.config/rofi/theme"
  [".config/rofi/scripts"]="$HOME/.config/rofi/scripts"
  [".config/dunst/dunstrc"]="$HOME/.config/dunst/dunstrc"
  [".config/fastfetch/config.jsonc"]="$HOME/.config/fastfetch/config.jsonc"
  [".config/cava/config"]="$HOME/.config/cava/config"
  [".config/cava/shaders"]="$HOME/.config/cava/shaders"
  [".config/cava/themes"]="$HOME/.config/cava/themes"
  [".config/starship.toml"]="$HOME/.config/starship.toml"
  [".config/swaync/config.json"]="$HOME/.config/swaync/config.json"
  [".config/swaync/style.css"]="$HOME/.config/swaync/style.css"
  [".config/tmux/tmux.conf"]="$HOME/.config/tmux/tmux.conf"
  [".tmux.conf"]="$HOME/.tmux.conf"
  [".config/fish/config.fish"]="$HOME/.config/fish/config.fish"
  [".config/firefoxhome.html"]="$HOME/.config/firefoxhome.html"
  [".config/gtk-3.0/settings.ini"]="$HOME/.config/gtk-3.0/settings.ini"
  [".gtkrc-2.0"]="$HOME/.gtkrc-2.0"
  [".themes/Black n Red GTK"]="$HOME/.themes/Black n Red GTK"
  [".config/opencode/themes/crimson.json"]="$HOME/.config/opencode/themes/crimson.json"
  [".config/opencode/tui.json"]="$HOME/.config/opencode/tui.json"
  ["walls/matrix-2560x1440.png"]="$HOME/.config/hypr/walls/matrix-2560x1440.png"
  ["walls/chiyoda-2560x1440.png"]="$HOME/.config/hypr/walls/chiyoda-2560x1440.png"
  ["walls/ikebukuro-2560x1440.png"]="$HOME/.config/hypr/walls/ikebukuro-2560x1440.png"
  ["walls/minato-2560x1440.png"]="$HOME/.config/hypr/walls/minato-2560x1440.png"
  ["walls/roppongi-2560x1440.png"]="$HOME/.config/hypr/walls/roppongi-2560x1440.png"
  ["walls/samurai-2560x1440.png"]="$HOME/.config/hypr/walls/samurai-2560x1440.png"
  ["walls/shibuya-2560x1440.png"]="$HOME/.config/hypr/walls/shibuya-2560x1440.png"
  ["walls/shinjuku-2560x1440.png"]="$HOME/.config/hypr/walls/shinjuku-2560x1440.png"
  ["walls/taito-2560x1440.png"]="$HOME/.config/hypr/walls/taito-2560x1440.png"
  ["walls/yoyogi-2560x1440.png"]="$HOME/.config/hypr/walls/yoyogi-2560x1440.png"
)

echo "  Matrix dotfiles installer"
echo "────────────────────────────"
echo ""

usage() {
  echo "Usage: $0 [--help|--install-packages|--no-backup]"
  echo ""
  echo "  --install-packages   Install required packages via pacman + yay"
  echo "  --no-backup          Skip backing up existing dotfiles"
  echo "  --help               Show this help"
  exit 0
}

INSTALL_PKGS=false
NO_BACKUP=false

for arg in "$@"; do
  case "$arg" in
    --help) usage ;;
    --install-packages) INSTALL_PKGS=true ;;
    --no-backup) NO_BACKUP=true ;;
  esac
done

install_packages() {
  echo "  Installing official packages..."
  sudo pacman -S --needed --noconfirm "${PACKAGES_OFFICIAL[@]}"

  if command -v "$AUR_HELPER" &>/dev/null; then
    echo "  Installing AUR packages via $AUR_HELPER..."
    $AUR_HELPER -S --needed --noconfirm "${PACKAGES_AUR[@]}"
  else
    echo "  WARNING: $AUR_HELPER not found. Install AUR packages manually:"
    printf '    %s\n' "${PACKAGES_AUR[@]}"
  fi

  echo "  Installing Python packages..."
  pip install --user hijridate 2>/dev/null || true
  echo ""
}

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

install_links() {
  for src in "${!LINKS[@]}"; do
    target="${LINKS[$src]}"
    dotfile="$DOTFILES_DIR/$src"

    rm -rf "$target" 2>/dev/null || true
    mkdir -p "$(dirname "$target")"
    ln -sf "$dotfile" "$target"
    echo "    symlinked  $src"
  done
  echo ""
  echo "  Done. All dotfiles installed."
}

[ "$INSTALL_PKGS" = true ] && install_packages
[ "$NO_BACKUP" = false ] && backup
install_links

gsettings set org.gnome.desktop.interface gtk-theme "Black n Red GTK" 2>/dev/null || true

echo ""
echo "  Reload your config:"
echo "    hyprctl reload           # Hyprland"
echo "    pkill waybar && waybar   # Waybar"
echo "    pkill swaync && swaync   # SwayNC"
echo "    tmux kill-server         # Tmux"
echo "    fish                     # Fish shell"
