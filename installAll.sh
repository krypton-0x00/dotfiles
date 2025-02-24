#!/bin/bash
set -euo pipefail

# Function for printing messages
info() {
    echo -e "\e[32m[INFO]\e[0m $1"
}

error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
    exit 1
}

#########################################
# Step 1: Update and Install Packages   #
#########################################
info "Updating system and installing official packages..."
sudo pacman -Syu --noconfirm

if [[ -f "pkglist.txt" ]]; then
    sudo pacman -S --needed --noconfirm - <pkglist.txt
else
    error "pkglist.txt not found!"
fi

#########################################
# Step 2: Install yay if not available  #
#########################################
if ! command -v yay &>/dev/null; then
    info "yay not found. Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
else
    info "yay is already installed."
fi

#########################################
# Step 3: Install AUR Packages          #
#########################################
if [[ -f "aurpkglist.txt" ]]; then
    info "Installing AUR packages..."
    yay -S --needed --noconfirm - <aurpkglist.txt
else
    info "aurpkglist.txt not found! Skipping AUR package installation."
fi

#########################################
# Step 4: Clone GitHub Repository       #
#########################################
info "Cloning repository from github.com/krypton-0x00/chadwm..."
git clone https://github.com/krypton-0x00/chadwm.git /tmp/chadwm_repo

# Create ~/.config if it doesn't exist
CONFIG_DIR="$HOME/.config"
mkdir -p "$CONFIG_DIR"

# Copy the entire repo to ~/.config/chadwm
TARGET_DIR="$CONFIG_DIR/chadwm"
rm -rf "$TARGET_DIR" 2>/dev/null || true
cp -r /tmp/chadwm_repo "$TARGET_DIR"
info "Repository copied to $TARGET_DIR."

#########################################
# Step 5: Build and Install chadwm       #
#########################################
# Change directory to the inner chadwm folder inside the cloned repo.
BUILD_DIR="$TARGET_DIR/chadwm"
if [ -d "$BUILD_DIR" ]; then
    info "Building and installing chadwm from $BUILD_DIR..."
    (cd "$BUILD_DIR" && sudo make clean install)
else
    error "Build directory $BUILD_DIR does not exist."
fi

#########################################
# Step 6: Create Xsession Desktop File  #
#########################################
# Get current username
USERNAME=$(whoami)
DESKTOP_FILE="/usr/share/xsessions/chadwm.desktop"

info "Creating desktop entry at $DESKTOP_FILE..."
sudo bash -c "cat > ${DESKTOP_FILE}" <<EOF
[Desktop Entry]
Name=chadwm
Comment=dwm made beautiful
Exec=/home/${USERNAME}/.config/chadwm/scripts/./run.sh
Type=Application
EOF
info "Desktop entry created."

#########################################
# Step 7: Copy eww folder               #
#########################################
# Check if eww folder exists inside ~/.config/chadwm
if [ -d "$TARGET_DIR/eww" ]; then
    info "Copying eww folder to ~/.config/..."
    cp -r "$TARGET_DIR/eww" "$CONFIG_DIR/"
    info "eww folder copied."
else
    info "eww folder not found in $TARGET_DIR. Skipping copy."
fi

#########################################
# Done                                  #
#########################################
info "Setup complete!"
