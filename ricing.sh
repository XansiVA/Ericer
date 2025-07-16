#!/bin/bash

# Colors for better output
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

echo -e "${GREEN}ERice${RESET}"

# Packages to install
packages=(
    cava
    nautilus
    neofetch
    nwg-dock-hyprland
    oh-my-posh
    rofi
    waybar
    swww
    waypaper
)

# Ask for confirmation
echo -e "${YELLOW}This will install the following packages:${RESET}"
for pkg in "${packages[@]}"; do echo " - $pkg"; done
read -p "Continue? (y/n): " confirm
[[ "$confirm" != "y" ]] && echo "Cancelled." && exit 1

# Install packages
echo -e "${GREEN}Installing packages...${RESET}"
for pkg in "${packages[@]}"; do
    if ! command -v "$pkg" &>/dev/null; then
        echo -e "${YELLOW}Installing $pkg...${RESET}"
        sudo pacman -S --noconfirm "$pkg"
    else
        echo -e "${GREEN}$pkg is already installed.${RESET}"
    fi
done

# Ensure swww is ready
echo -e "${GREEN}Starting swww daemon...${RESET}"
pkill swww &>/dev/null
swww init & disown
sleep 1

# Test wallpaper setting
if [[ -f "./wallpaper.png" ]]; then
    echo -e "${GREEN}Setting test wallpaper with swww...${RESET}"
    swww img ./wallpaper.png
else
    echo -e "${YELLOW}No wallpaper.png found — skipping wallpaper test.${RESET}"
fi

#hyprland install for the config change
HYPR_CONFIG="$HOME/.config/hypr/hyprland.conf"
THEME_HYPR_CONF="$THEME_DIR/hyprland.conf"


echo -e "${GREEN}✅ Done! happy ricing :3${RESET}"

sleep 1
echo "You should reboot to load files correctly"
sleep 2
