#!/usr/bin/env bash
# ============================================================================
#  Zazzu dotfiles :: installer
#  Arch / Athena OS · Hyprland · dark red on black
#
#  Usage:
#    ./install.sh                 # packages + configs + theme + SDDM
#    ./install.sh --no-packages   # configs only
#    ./install.sh --config-only   # same as --no-packages
#    ./install.sh --no-sddm       # skip the login-screen theme
#    ./install.sh --keep-session  # do not make Hyprland the default session
# ============================================================================
set -euo pipefail

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

DO_PACKAGES=1
DO_SDDM=1
KEEP_SESSION=0

for arg in "$@"; do
    case "$arg" in
        --no-packages|--config-only) DO_PACKAGES=0 ;;
        --no-sddm)                   DO_SDDM=0 ;;
        --keep-session)              KEEP_SESSION=1 ;;
        -h|--help)                   sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "unknown option: $arg (try --help)" >&2; exit 2 ;;
    esac
done

log()  { printf '\033[1;31m::\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m ✓\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m !!\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m ERROR:\033[0m %s\n' "$*" >&2; exit 1; }

[[ $EUID -ne 0 ]] || die "run this as your user, not as root"
command -v pacman >/dev/null 2>&1 || die "pacman not found — this installer targets Arch-based systems"

log "Zazzu dotfiles :: $DOTFILES"
sudo -v || die "sudo is required"

# ── backups ────────────────────────────────────────────────────────────────

backup_path() {
    local dst="$1" rel target
    rel="${dst#"$HOME"/}"
    target="$BACKUP/$rel"
    mkdir -p "$(dirname "$target")"
    mv "$dst" "$target"
    warn "backed up $dst -> $target"
}

link_path() {
    local src="$1" dst="$2"
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        ok "linked $dst"
        return
    fi
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        backup_path "$dst"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    ok "linked $dst"
}

# ── packages ───────────────────────────────────────────────────────────────

install_packages() {
    local p missing=()

    mapfile -t pkgs < <(grep -vE '^[[:space:]]*(#|$)' "$DOTFILES/packages/pacman.txt")
    for p in "${pkgs[@]}"; do
        [ -n "$(pacman -T "$p" 2>/dev/null || true)" ] && missing+=("$p")
    done

    if ((${#missing[@]})); then
        log "installing ${#missing[@]} official packages"
        sudo pacman -S --needed --noconfirm "${missing[@]}"
    else
        ok "official packages already installed"
    fi

    mapfile -t aur < <(grep -vE '^[[:space:]]*(#|$)' "$DOTFILES/packages/aur.txt")
    missing=()
    for p in "${aur[@]}"; do
        [ -n "$(pacman -T "$p" 2>/dev/null || true)" ] && missing+=("$p")
    done

    if ((${#missing[@]})); then
        if ! command -v yay >/dev/null 2>&1; then
            log "yay is missing — bootstrapping it first"
            "$DOTFILES/scripts/install-yay.sh"
        fi
        log "installing ${#missing[@]} AUR package(s): ${missing[*]}"
        yay -S --needed --noconfirm "${missing[@]}"
    else
        ok "AUR packages already installed"
    fi
}

# ── config deployment ──────────────────────────────────────────────────────

deploy_configs() {
    local dir

    # Pure-config trees: symlink the whole directory.
    for dir in hypr waybar wofi dunst kitty alacritty btop fastfetch; do
        link_path "$DOTFILES/config/$dir" "$HOME/.config/$dir"
    done

    # GTK directories also contain app-written files (bookmarks, recently-used),
    # so only link the files that belong to this rice.
    mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
    link_path "$DOTFILES/config/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
    link_path "$DOTFILES/config/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"

    # GTK4 used to symlink Matrix-Dark here; link_path backs that up for us.
    for stale in gtk-dark.css assets; do
        if [ -L "$HOME/.config/gtk-4.0/$stale" ]; then
            backup_path "$HOME/.config/gtk-4.0/$stale"
        fi
    done
    link_path "$DOTFILES/config/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"

    # Fish keeps fish_variables next to config.fish, so link files, not the dir.
    mkdir -p "$HOME/.config/fish/functions"
    link_path "$DOTFILES/config/fish/config.fish" "$HOME/.config/fish/config.fish"
    link_path "$DOTFILES/config/fish/functions/fish_prompt.fish" "$HOME/.config/fish/functions/fish_prompt.fish"

    # GTK2
    link_path "$DOTFILES/config/gtk-2.0/gtkrc-2.0" "$HOME/.gtkrc-2.0"

    # Qt: copy rather than symlink, because the .conf is rendered from a template.
    local qt
    mkdir -p "$BACKUP"
    for qt in qt5ct qt6ct; do
        mkdir -p "$HOME/.config/$qt/colors"
        cp -f "$DOTFILES/config/$qt/colors/zazzu-red.conf" "$HOME/.config/$qt/colors/zazzu-red.conf"
        if [ -f "$HOME/.config/$qt/$qt.conf" ] && ! grep -q "^color_scheme_path=$HOME/.config/$qt/colors/zazzu-red.conf" "$HOME/.config/$qt/$qt.conf"; then
            cp -f "$HOME/.config/$qt/$qt.conf" "$BACKUP/$qt.conf.bak" 2>/dev/null || true
        fi
        sed "s#@HOME@#$HOME#g" "$DOTFILES/config/$qt/$qt.conf.in" > "$HOME/.config/$qt/$qt.conf"
        ok "rendered ~/.config/$qt/$qt.conf"
    done

    chmod +x "$DOTFILES"/config/hypr/scripts/*.sh "$DOTFILES"/scripts/*.sh

    # Theme + wallpaper (wallpaper lives inside the linked hypr tree).
    mkdir -p "$HOME/.themes" "$HOME/Pictures/Screenshots"
    if [ -e "$HOME/.themes/Zazzu-Red" ]; then
        backup_path "$HOME/.themes/Zazzu-Red"
    fi
    cp -a "$DOTFILES/theme/Zazzu-Red" "$HOME/.themes/Zazzu-Red"
    ok "installed ~/.themes/Zazzu-Red"
}

apply_appearance() {
    if ! command -v gsettings >/dev/null 2>&1; then
        warn "gsettings not found — set the theme manually with nwg-look"
        return
    fi

    log "applying GTK / icon / cursor preferences"
    gsettings set org.gnome.desktop.interface gtk-theme 'Zazzu-Red'              2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'           2>/dev/null || true
    gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'    2>/dev/null || true
    gsettings set org.gnome.desktop.interface cursor-size 24                      2>/dev/null || true
    gsettings set org.gnome.desktop.interface font-name 'JetBrainsMono Nerd Font 10' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 10' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'          2>/dev/null || true
    gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close' 2>/dev/null || true

    if command -v papirus-folders >/dev/null 2>&1; then
        log "recolouring Papirus folders to red"
        sudo papirus-folders -C red -t Papirus-Dark -u || warn "papirus-folders failed (safe to ignore)"
    fi
}

# ── main ───────────────────────────────────────────────────────────────────

(($DO_PACKAGES)) && install_packages

deploy_configs
apply_appearance

if (($DO_SDDM)); then
    if [ -x "$DOTFILES/sddm/install-sddm.sh" ] && [ -d /usr/share/sddm/themes/sddm-astronaut-theme ]; then
        log "theming the SDDM login screen"
        if (($KEEP_SESSION)); then
            sudo "$DOTFILES/sddm/install-sddm.sh" --keep-session
        else
            sudo "$DOTFILES/sddm/install-sddm.sh"
        fi
    else
        warn "sddm-astronaut-theme not found — skipping login screen theme"
        warn "install it with: yay -S sddm-astronaut-theme, then run sddm/install-sddm.sh"
    fi
fi

echo
ok "done."
echo
cat <<EOF
  Next steps
  ──────────
  1. Log out of XFCE and pick "Hyprland" at the SDDM login screen.
  2. First launch: SUPER+Return = kitty, SUPER+R = launcher, SUPER+SHIFT+Q = power menu.
  3. Validate the config any time:  Hyprland --verify-config -c ~/.config/hypr/hyprland.lua

  This VMware guest has no 3D acceleration, so Hyprland runs on llvmpipe
  (MESA_LOADER_DRIVER_OVERRIDE=kms_swrast in hyprland.lua). Remove that
  hl.env line after enabling 3D acceleration in the VM settings.

  If anything looks off, the previous files are in:
    $BACKUP
EOF
