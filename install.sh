#!/usr/bin/env bash

# lingSDDM Installation Script
# https://github.com/imtraf/ling-sddm

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

THEME_NAME="lingSDDM"
THEMES_DIR="/usr/share/sddm/themes"
FONTS_DIR="/usr/share/fonts"
SDDM_CONF="/etc/sddm.conf"
SCRIPT_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
CUSTOM_BACKGROUND=""

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --background) CUSTOM_BACKGROUND="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

echo -e "${CYAN}${BOLD}==>${RESET} ${BOLD}Installing lingSDDM Theme...${RESET}"

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# 1. Dependency Installation
install_dependencies() {
    echo -e "${CYAN}${BOLD}  ->${RESET} Detecting package manager and installing dependencies..."
    
    if command_exists pacman; then
        sudo pacman -S --needed --noconfirm sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg
    elif command_exists dnf; then
        sudo dnf install -y sddm qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia
    elif command_exists apt; then
        sudo apt update
        sudo apt install -y sddm qml6-module-qtquick-layouts qml6-module-qtquick-controls qml6-module-qtmultimedia qml6-module-qtsvg qml6-module-qtvirtualkeyboard libqt6multimedia6-ffmpeg || \
        echo -e "${YELLOW}Warning: Some QT6 packages might not be available. Please ensure QT 6.5+ is installed.${RESET}"
    elif command_exists zypper; then
        sudo zypper install -y sddm-qt6 libQt6Svg6 qt6-virtualkeyboard qt6-virtualkeyboard-imports qt6-multimedia qt6-multimedia-imports
    elif command_exists xbps-install; then
        sudo xbps-install -Sy sddm qt6-svg qt6-virtualkeyboard qt6-multimedia
    else
        echo -e "${YELLOW}Unknown package manager. Please ensure SDDM (QT6) and its dependencies are installed manually.${RESET}"
    fi
}

# 2. Copy Theme Files
copy_theme() {
    echo -e "${CYAN}${BOLD}  ->${RESET} Copying theme files to ${THEMES_DIR}/${THEME_NAME}..."
    sudo mkdir -p "${THEMES_DIR}/${THEME_NAME}"
    sudo cp -rf "${SCRIPT_PATH}"/* "${THEMES_DIR}/${THEME_NAME}/"
    # Remove unnecessary files from destination
    sudo rm -rf "${THEMES_DIR}/${THEME_NAME}/nix"
    sudo rm -rf "${THEMES_DIR}/${THEME_NAME}/.git"
    sudo rm -f "${THEMES_DIR}/${THEME_NAME}/install.sh"
    sudo rm -f "${THEMES_DIR}/${THEME_NAME}/README.md"
    sudo rm -f "${THEMES_DIR}/${THEME_NAME}/flake.nix"
    sudo rm -f "${THEMES_DIR}/${THEME_NAME}/flake.lock"

    # Update theme.conf if custom background is provided
    if [ -n "$CUSTOM_BACKGROUND" ]; then
        echo -e "${CYAN}${BOLD}  ->${RESET} Setting custom background to ${CUSTOM_BACKGROUND}..."
        sudo sed -i "s|^background =.*|background = \"${CUSTOM_BACKGROUND}\"|" "${THEMES_DIR}/${THEME_NAME}/theme.conf"
    fi
}

# 3. Install Fonts
install_fonts() {
    echo -e "${CYAN}${BOLD}  ->${RESET} Installing fonts..."
    sudo mkdir -p "${FONTS_DIR}/lingSDDM"
    if [ -d "${SCRIPT_PATH}/fonts" ]; then
        sudo cp -rf "${SCRIPT_PATH}/fonts"/* "${FONTS_DIR}/lingSDDM/"
        if command_exists fc-cache; then
            sudo fc-cache -f >/dev/null
        fi
    else
        echo -e "${YELLOW}No fonts directory found, skipping font installation.${RESET}"
    fi
}

# 4. Configure SDDM
configure_sddm() {
    echo -e "${CYAN}${BOLD}  ->${RESET} Configuring SDDM to use ${THEME_NAME}..."
    
    # Backup existing config
    if [ -f "$SDDM_CONF" ]; then
        sudo cp "$SDDM_CONF" "${SDDM_CONF}.bak"
        echo -e "${GREEN}    Backup created at ${SDDM_CONF}.bak${RESET}"
    fi

    # Ensure [Theme] and [General] sections exist and set values
    # Using a temporary file for safer editing
    TMP_CONF=$(mktemp)
    
    # Simple logic to update/add keys
    if [ -f "$SDDM_CONF" ]; then
        cp "$SDDM_CONF" "$TMP_CONF"
    else
        touch "$TMP_CONF"
    fi

    # Helper function to set ini value
    set_ini_value() {
        local section=$1
        local key=$2
        local value=$3
        local file=$4

        if grep -q "^\[$section\]" "$file"; then
            if grep -q "^$key=" "$file"; then
                sudo sed -i "/^\[$section\]/,/^\[/ s|^$key=.*|$key=$value|" "$file"
            else
                sudo sed -i "/^\[$section\]/a $key=$value" "$file"
            fi
        else
            echo -e "\n[$section]\n$key=$value" >> "$file"
        fi
    }

    set_ini_value "Theme" "Current" "$THEME_NAME" "$TMP_CONF"
    set_ini_value "General" "InputMethod" "qtvirtualkeyboard" "$TMP_CONF"
    set_ini_value "General" "GreeterEnvironment" "QML2_IMPORT_PATH=${THEMES_DIR}/${THEME_NAME}/components/,QT_IM_MODULE=qtvirtualkeyboard" "$TMP_CONF"

    sudo cp "$TMP_CONF" "$SDDM_CONF"
    rm "$TMP_CONF"
}

# Main Execution
install_dependencies
copy_theme
install_fonts
configure_sddm

echo -e "\n${GREEN}${BOLD}✔ lingSDDM has been successfully installed!${RESET}"
echo -e "${CYAN}Note:${RESET} You may need to restart your computer or restart the SDDM service to see the changes."
echo -e "${CYAN}Test the theme with:${RESET} sddm-greeter-qt6 --test-mode --theme ${THEMES_DIR}/${THEME_NAME}"
