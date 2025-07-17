#!/bin/bash

# Packages to install
packages="cava dunst neofetch mpv nautilus nwg-dock-hyprland rofi oh-my-posh swaync"

echo "Installing packages..."
sudo pacman -S --noconfirm $packages

echo "Updating system..."
sudo pacman -Syu --noconfirm

# Cursor theme installation is usually manual or from AUR, so here's a placeholder:
echo "NOTE: For a smooth white cursor theme, please install it manually or from AUR."

# Function to fetch and display remote text from GitHub
display_remote_text() {
  local url="https://raw.githubusercontent.com/XansiVA/Ericer/main/howtouse.txt"

  echo "Fetching remote text file from GitHub..."
  if curl -s --fail "$url" -o /tmp/remote_text.txt; then
    less /tmp/remote_text.txt
  else
    echo "Failed to download remote text file."
  fi
}

# List all files in ~/.config
list_config_files() {
  mapfile -t files < <(find ~/.config -type f)
  echo "Config files found:"
  for i in "${!files[@]}"; do
    echo "[$i] ${files[$i]}"
  done
}

open_file_with_editor() {
  local file="$1"
  echo "Choose editor to open the file:"
  echo "[1] nano"
  echo "[2] nvim"
  echo "[3] text editor (use 'xdg-open' fallback)"
  read -rp "Enter choice: " editor_choice

  case "$editor_choice" in
    1) nano "$file" ;;
    2) nvim "$file" ;;
    3) xdg-open "$file" ;;  # Opens default GUI editor
    *) echo "Invalid choice, opening with nano by default."; nano "$file" ;;
  esac
}

# Main menu loop
while true; do
  echo
  echo "Select an option:"
  echo "1) View remote teaching text file from GitHub"
  echo "2) Browse and open files in ~/.config"
  echo "q) Quit"
  read -rp "Your choice: " choice

  case "$choice" in
    1)
      display_remote_text
      ;;
    2)
      list_config_files
      read -rp "Enter file number to open (or q to quit): " file_choice
      if [[ "$file_choice" =~ ^[0-9]+$ ]] && (( file_choice >= 0 && file_choice < ${#files[@]} )); then
        open_file_with_editor "${files[$file_choice]}"
      elif [[ "$file_choice" == "q" ]]; then
        echo "Returning to main menu."
      else
        echo "Invalid input."
      fi
      ;;
    q)
      echo "Goodbye!"
      exit 0
      ;;
    *)
      echo "Invalid choice."
      ;;
  esac
done
