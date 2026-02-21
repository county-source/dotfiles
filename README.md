# dotfiles

Hyprland rice with dynamic Material You theming via [Matugen](https://github.com/InioX/matugen).

## Details

- **WM**: Hyprland
- **Bar**: Waybar
- **Launcher**: Rofi
- **Terminal**: Kitty
- **Notifications**: SwayNC
- **Logout**: wlogout
- **Shell prompt**: Starship
- **Font**: JetBrains Mono Nerd Font
- **Color scheme**: Auto-generated from wallpaper using Matugen

## How it works

Press `SUPER+W` to pick a wallpaper. Matugen extracts colors and applies them across all apps (Hyprland borders, Waybar, Rofi, Kitty, SwayNC, wlogout, btop, cava, fastfetch, Firefox via Pywalfox).

## Install

```bash
git clone https://github.com/county-source/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

Requires Arch Linux. The script installs packages and symlinks configs to `~/.config/`.

## Keybindings

| Key | Action |
|-----|--------|
| `SUPER + Enter` | Kitty terminal |
| `SUPER + Space` | Rofi launcher |
| `SUPER + W` | Wallpaper picker |
| `SUPER + H/J/K/L` | Focus window (vim-style) |
| `SUPER + 1-5` | Switch workspace |
| `SUPER + Shift + 1-5` | Move window to workspace |
| `SUPER + C` | Close window |
| `SUPER + F` | Firefox |
| `SUPER + Shift + L` | Lock screen |
| `Print` | Screenshot (region) |
