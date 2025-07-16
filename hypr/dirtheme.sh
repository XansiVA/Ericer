#!/bin/bash

REPO_URL="https://github.com/XansiVA/Ericer.git"
CLONE_DIR="Ericer/"

echo "Cloning rice files..."
git clone "$REPO_URL" "$CLONE_DIR" || { echo "❌ Clone failed"; exit 1; }

# List of config folders to copy
CONFIGS=("hypr" "waybar" "rofi" "cava")

for config in "${CONFIGS[@]}"; do
    SRC="$CLONE_DIR/$config"
    DEST="$HOME/.config/$config"

    if [[ -d "$SRC" ]]; then
        echo "Found $config config"
        
        # Backup existing config
        if [[ -d "$DEST" ]]; then
            echo "Backing up existing $config..."
            mv "$DEST" "$DEST.backup.$(date +%s)"
        fi

        echo "📦 Copying $config..."
        cp -r "$SRC" "$DEST"
    else
        echo "⚠️  No $config in repo"
    fi
done

# Set wallpaper if it exists
if [[ -f "$CLONE_DIR/wallpaper.png" ]]; then
    mkdir -p "$HOME/Pictures/Wallpapers"
    cp "$CLONE_DIR/wallpaper.png" "$HOME/Pictures/Wallpapers/current.png"
    swww img "$HOME/Pictures/Wallpapers/current.png"
fi





# Reload Hyprland + Waybar
echo "🔁 Restarting Waybar..."
hyprctl reload
pkill waybar
sleep 0.5
waybar -c "$HOME/.config/waybar/config.jsonc" -s "$HOME/.config/waybar/style.css" & disown


echo "done!"
