#!/bin/bash

# Packages to install alot for ricing, but some for the Ericer.
packages="cava dunst neofetch mpv nautilus nwg-dock-hyprland rofi oh-my-posh swaync fzf"

echo "Installing packages..."
sudo pacman -S --noconfirm $packages

echo "Updating system..."
sudo pacman -Syu --noconfirm
clear
sleep 1
echo "NOTE: For a smooth white cursor theme, try 'Bibata-Modern-Ice' from AUR."
sleep 1
clear
# Function to fetch and display remote teaching text it might have the wrong directory-
display_remote_text() {
  local url="https://raw.githubusercontent.com/XansiVA/Ericer/main/howtouse.txt"
  echo "Fetching remote text from GitHub..."
  if curl -s --fail "$url" -o /tmp/remote_text.txt; then
    less /tmp/remote_text.txt
  else
    echo "Could not fetch the remote text file."
  fi
}

# Function to open config files with fuzzy picker
open_config_with_fzf() {
  echo "Indexing files in ~/.config..."
  mapfile -t files < <(find ~/.config -type f)

  if [[ ${#files[@]} -eq 0 ]]; then
    echo "No config files found."
    return
  fi

  selected=$(printf "%s\n" "${files[@]}" | fzf --prompt="Search configs: " --height=30% --reverse --border)

  if [[ -n "$selected" && -f "$selected" ]]; then
    echo "Choose editor:"
    echo "[1] nano"
    echo "[2] nvim"
    echo "[3] xdg-open (GUI)"
    read -rp "Editor: " editor_choice

    case "$editor_choice" in
      1) nano "$selected" ;;
      2) nvim "$selected" ;;
      3) xdg-open "$selected" ;;
      *) echo "Invalid choice. Opening with nano."; nano "$selected" ;;
    esac
  else
    echo "No file selected."
  fi
}

# Main menu
while true; do
  echo -e "\nMain Menu:"
  echo "1) View teaching text from GitHub"
  echo "2) Browse config files with fzf"
  echo "q) Quit"
  read -rp "Choice: " main_choice

  case "$main_choice" in
    1) display_remote_text ;;
    2) open_config_with_fzf ;;
    q) echo "Bye!"; exit ;;
    *) echo "Invalid choice." ;;
  esac
done

