#!/usr/bin/env bash
# ============================================================================
#  Zazzu dotfiles :: SDDM login screen
#  Adds a dark-red variant to sddm-astronaut-theme and selects it.
#
#  Run with sudo (the main installer does this for you):
#    sudo ./sddm/install-sddm.sh [--keep-session]
# ============================================================================
set -euo pipefail

THEME_DIR="/usr/share/sddm/themes/sddm-astronaut-theme"
SRC="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="$(dirname "$SRC")"
KEEP_SESSION=0
[[ "${1:-}" == "--keep-session" ]] && KEEP_SESSION=1

log()  { printf '\033[1;31m::\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m !!\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m ERROR:\033[0m %s\n' "$*" >&2; exit 1; }

[[ $EUID -eq 0 ]] || die "run me with sudo"

[ -d "$THEME_DIR" ] || die "sddm-astronaut-theme is not installed (yay -S sddm-astronaut-theme)"

TARGET_USER="${SUDO_USER:-$(logname 2>/dev/null || echo zazzu)}"

log "installing theme variant"
install -m 0644 "$SRC/zazzu-dark-red.conf" "$THEME_DIR/Themes/zazzu-dark-red.conf"
install -m 0644 "$DOTFILES/config/hypr/wallpapers/zazzu-dark-red.png" \
    "$THEME_DIR/Backgrounds/zazzu-dark-red.png"

# Point the theme metadata at our variant. Package upgrades reset this file,
# so re-run this script after upgrading sddm-astronaut-theme.
if [ ! -f "$THEME_DIR/metadata.desktop.zazzu-orig" ]; then
    cp -a "$THEME_DIR/metadata.desktop" "$THEME_DIR/metadata.desktop.zazzu-orig"
fi
sed -i 's|^ConfigFile=.*|ConfigFile=Themes/zazzu-dark-red.conf|' "$THEME_DIR/metadata.desktop"

# Select the theme and keep the numpad usable at the greeter.
mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/20-zazzu-theme.conf <<'EOF'
[Theme]
Current=sddm-astronaut-theme

[General]
Numlock=on
EOF

# Preselect Hyprland for this user; XFCE stays available in the session menu.
if ((KEEP_SESSION)); then
    log "keeping the currently selected session"
elif [ -f /usr/share/wayland-sessions/hyprland.desktop ]; then
    if grep -q '^\[Last\]' /var/lib/sddm/state.conf 2>/dev/null; then
        if grep -q '^Session=' /var/lib/sddm/state.conf 2>/dev/null; then
            sed -i 's|^Session=.*|Session=/usr/share/wayland-sessions/hyprland.desktop|' /var/lib/sddm/state.conf
        else
            sed -i '/^\[Last\]/a Session=/usr/share/wayland-sessions/hyprland.desktop' /var/lib/sddm/state.conf
        fi
    else
        printf '\n[Last]\nUser=%s\nSession=/usr/share/wayland-sessions/hyprland.desktop\n' \
            "$TARGET_USER" >> /var/lib/sddm/state.conf
    fi
    log "default session: Hyprland (XFCE still selectable)"
else
    warn "hyprland.desktop not found — leaving the default session alone"
fi

log "done — the greeter restarts on the next logout"
