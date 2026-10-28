#!/usr/bin/env bash
# Build and install a Hyprland with the vmwgfx DMA-BUF patch applied.
#
# VMware-only workaround. Not used by install.sh; run it by hand inside a
# VMware guest when GPU clients (kitty, alacritty, Chromium, foot-with-GL)
# die with:
#
#   wl_display#1: error 1: invalid arguments for wl_surface#N.attach
#
# Bare-metal installs must never run this.

set -euo pipefail

SRC_REF="${SRC_REF:-v0.56.2}"
BUILD_DIR="${BUILD_DIR:-/tmp/hyprland-vmwgfx-build}"
PKG_CACHE="${PKG_CACHE:-/var/cache/pacman/pkg}"

log() { printf '\033[1;31m::\033[0m %s\n' "$*"; }
die() { printf '\033[1;31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

[[ $EUID -ne 0 ]] || die "run as your normal user; sudo is used only to install"

if ! grep -qi vmware /sys/class/dmi/id/sys_vendor 2>/dev/null; then
    die "this is not a VMware guest; the patch is only needed on vmwgfx"
fi

for dep in git cmake ninja pkgconf; do
    command -v "$dep" >/dev/null || die "missing build dependency: $dep (sudo pacman -S $dep)"
done

log "fetching Hyprland $SRC_REF"
rm -rf "$BUILD_DIR"
git clone --depth 1 --branch "$SRC_REF" https://github.com/hyprwm/Hyprland.git "$BUILD_DIR"
git -C "$BUILD_DIR" submodule update --init --depth 1

log "applying vmwgfx DMA-BUF patch"
patch -d "$BUILD_DIR" -p1 < "$(dirname "$(readlink -f "$0")")/hyprland-vmwgfx-dmabuf.patch"

log "configuring"
cmake -S "$BUILD_DIR" -B "$BUILD_DIR/build" -G Ninja \
    -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr >/dev/null

log "building (this takes a few minutes)"
ninja -C "$BUILD_DIR/build"

log "backing up the packaged binary"
sudo cp /usr/bin/Hyprland "/tmp/Hyprland.orig-$(pacman -Q hyprland | awk '{print $2}')"

log "installing patched binary"
sudo install -m 0755 "$BUILD_DIR/build/Hyprland" /usr/bin/.Hyprland.patched
sudo mv -f /usr/bin/.Hyprland.patched /usr/bin/Hyprland

cat <<EOF

  Installed $(Hyprland --version | head -1)

  Log out and back in, then test kitty/alacritty.

  Rollback (any package upgrade also restores the stock build):
    sudo pacman -U $PKG_CACHE/hyprland-$(pacman -Q hyprland | awk '{print $2}')-x86_64.pkg.tar.zst
EOF
