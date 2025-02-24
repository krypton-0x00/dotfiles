#!/bin/bash

set -e # Exit on error

echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install all official packages
if [[ -f "pkglist.txt" ]]; then
    echo "Installing official repository packages..."
    sudo pacman -S --needed --noconfirm - <pkglist.txt
else
    echo "Error: pkglist.txt not found!"
    exit 1
fi

# Check if yay is installed, install if not
if ! command -v yay &>/dev/null; then
    echo "yay not found! Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/yay
else
    echo "yay is already installed!"
fi

# Install all AUR packages
if [[ -f "aurpkglist.txt" ]]; then
    echo "Installing AUR packages..."
    yay -S --needed --noconfirm - <aurpkglist.txt
else
    echo "Warning: aurpkglist.txt not found! Skipping AUR packages."
fi

echo "Package restoration complete!"
