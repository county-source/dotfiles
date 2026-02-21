#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/.config"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[*]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[x]${NC} $1"; exit 1; }

# --- Check Arch Linux ---
command -v pacman &>/dev/null || error "This script requires Arch Linux (pacman not found)"

# --- Packages ---
PACMAN_PKGS=(
    # Hyprland & tools
    hyprland hyprlock hypridle hyprshot

    # Bar, launcher, notifications, logout
    waybar rofi swaync wlogout

    # Terminal & shell
    kitty starship

    # System monitors & visualizer
    btop cava fastfetch

    # Wallpaper & theming
    swww matugen

    # Utilities
    brightnessctl imagemagick
    network-manager-applet blueman pavucontrol
    polkit-gnome tlp

    # Fonts
    ttf-jetbrains-mono-nerd
)

info "Installing packages..."
sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}" || {
    warn "Some packages failed. You may need an AUR helper (yay/paru) for: wlogout, matugen"
    warn "Try: yay -S --needed ${PACMAN_PKGS[*]}"
}

# --- Symlink configs ---
CONFIGS=(
    hypr
    waybar
    rofi
    kitty
    matugen
    swaync
    btop
    cava
    fastfetch
    wlogout
)

info "Symlinking configs to $CONFIG_DIR..."
mkdir -p "$CONFIG_DIR"

for dir in "${CONFIGS[@]}"; do
    src="$DOTFILES/.config/$dir"
    dst="$CONFIG_DIR/$dir"

    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        warn "Backing up existing $dst -> ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi

    ln -sfn "$src" "$dst"
    info "  $dir -> linked"
done

# starship.toml (single file, not directory)
if [ -e "$CONFIG_DIR/starship.toml" ] && [ ! -L "$CONFIG_DIR/starship.toml" ]; then
    mv "$CONFIG_DIR/starship.toml" "$CONFIG_DIR/starship.toml.bak"
fi
ln -sf "$DOTFILES/.config/starship.toml" "$CONFIG_DIR/starship.toml"
info "  starship.toml -> linked"

# --- TLP config ---
if [ -f "$DOTFILES/etc/tlp.conf" ]; then
    info "Copying tlp.conf to /etc/ (requires sudo)..."
    sudo cp "$DOTFILES/etc/tlp.conf" /etc/tlp.conf
fi

# --- Make scripts executable ---
chmod +x "$DOTFILES/.config/hypr/scripts/wallpaper-picker.sh"
chmod +x "$DOTFILES/.config/waybar/power_cycle.sh"
chmod +x "$DOTFILES/.config/waybar/power_profile.sh"

# --- Enable services ---
info "Enabling TLP..."
sudo systemctl enable --now tlp.service 2>/dev/null || warn "TLP service failed to enable"

info ""
info "Done! Log out and back into Hyprland to apply everything."
info "Set a wallpaper with SUPER+W to generate your color scheme."
