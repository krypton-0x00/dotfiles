#!/usr/bin/env bash
# Zazzu dotfiles :: bootstrap yay (AUR helper)
set -euo pipefail

if command -v yay >/dev/null 2>&1; then
    echo "yay already installed: $(yay --version | head -n1)"
    exit 0
fi

echo ":: installing build prerequisites"
sudo pacman -S --needed --noconfirm base-devel git

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo ":: cloning yay"
git clone --depth 1 https://aur.archlinux.org/yay.git "$tmp/yay"
cd "$tmp/yay"
makepkg -si --noconfirm

echo ":: yay installed: $(yay --version | head -n1)"
