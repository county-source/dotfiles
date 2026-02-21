#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper-thumbs"
WAYBAR_COLORS="$HOME/.config/waybar/colors.css"
export PATH="$HOME/.local/bin:$PATH"

mkdir -p "$CACHE_DIR"

# 1. Generate thumbnails in background
generate_thumbs() {
    for pic in "$WALLPAPER_DIR"/*.{jpg,jpeg,png,webp,gif}; do
        [ -f "$pic" ] || continue
        filename=$(basename "$pic")
        thumb="$CACHE_DIR/$filename"

        if [ ! -f "$thumb" ] || [ "$pic" -nt "$thumb" ]; then
            magick "$pic" -thumbnail 150x150^ -gravity center -extent 150x150 "$thumb" 2>/dev/null &
        fi
    done
    wait
}

generate_thumbs &

# 2. Build list for Rofi
LIST=""
for pic in "$WALLPAPER_DIR"/*.{jpg,jpeg,png,webp,gif}; do
    [ -f "$pic" ] || continue
    filename=$(basename "$pic")
    thumb="$CACHE_DIR/$filename"

    if [ -f "$thumb" ]; then
        LIST+="${filename}\0icon\x1f${thumb}\n"
    else
        LIST+="${filename}\0icon\x1f${pic}\n"
    fi
done

# 3. Show Rofi picker
SELECT=$(echo -en "$LIST" | rofi -dmenu -i -show-icons -p "Wallpaper" \
    -theme-str '
    window {
        width: 50%;
        height: 45%;
        border: 2px;
        border-radius: 12px;
        border-color: @primary;
    }
    listview {
        columns: 5;
        lines: 2;
        spacing: 15px;
        padding: 15px;
        fixed-height: true;
    }
    element {
        orientation: vertical;
        padding: 8px;
        border-radius: 10px;
    }
    element-icon {
        size: 110px;
        horizontal-align: 0.5;
    }
    element-text {
        font: "JetBrains Mono Nerd Font 8";
        horizontal-align: 0.5;
    }')

[ -z "$SELECT" ] && exit 0

FULL_PATH="$WALLPAPER_DIR/$SELECT"

# 4. Save file timestamp before color generation
OLD_TIME=$(stat -c %Y "$WAYBAR_COLORS" 2>/dev/null || echo 0)

# 5. Set wallpaper with transition
swww img "$FULL_PATH" --transition-type fade --transition-step 90 --transition-fps 60 &

# 6. Generate color scheme from wallpaper
matugen image "$FULL_PATH" --type scheme-neutral

# 7. Wait for colors file to update (max 3 seconds)
for i in {1..30}; do
    NEW_TIME=$(stat -c %Y "$WAYBAR_COLORS" 2>/dev/null || echo 0)
    [ "$NEW_TIME" != "$OLD_TIME" ] && break
    sleep 0.1
done

# 8. Restart waybar to apply new colors
killall -q waybar
sleep 0.3
waybar &
disown

# 9. Reload other applications
~/.local/bin/pywalfox update &
pkill -SIGUSR1 kitty
swaync-client -R && swaync-client -rs

wait 2>/dev/null
