#!/bin/bash

# ===================================
#  CONFIGURATION
# ===================================
APT_PACKAGES=(vlc htop flatpak okular kwrite kate)
FLATPAK_PACKAGES=(
    org.mozilla.firefox
    org.libreoffice.LibreOffice
    org.localsend.localsend_app
    com.github.jeromerobert.pdfarranger
    org.telegram.desktop
)

# ===================================
#  COLORS & ICONS
# ===================================
GREEN="\e[32m" ; YELLOW="\e[33m" ; RED="\e[31m" ; CYAN="\e[36m" ; RESET="\e[0m"
CHECK="✅" ; INFO="ℹ️" ; WARN="⚠️"

# Message helper
msg() {
    case $1 in
        info)  echo -e "${CYAN}${INFO} ${2}${RESET}" ;;
        ok)    echo -e "${GREEN}${CHECK} ${2}${RESET}" ;;
        warn)  echo -e "${YELLOW}${WARN} ${2}${RESET}" ;;
        err)   echo -e "${RED}❌ ${2}${RESET}" ;;
    esac
}

# ===================================
#  FUNCTIONS
# ===================================

update_system() {
    msg info "Updating system..."
    sudo apt update -y && sudo apt upgrade -y
}

install_apt() {
    msg info "Installing APT packages..."
    for pkg in "${APT_PACKAGES[@]}"; do
        if dpkg -l | grep -qw "$pkg"; then
            msg ok "$pkg already installed"
        else
            sudo apt install -y "$pkg" && msg ok "$pkg installed"
        fi
    done
}

install_flatpak() {
    if ! command -v flatpak &>/dev/null; then
        msg warn "Flatpak not found. Installing..."
        sudo apt install -y flatpak
    fi

    if ! flatpak remote-list | grep -q flathub; then
        msg info "Adding Flathub repo..."
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi

    msg info "Installing Flatpak packages..."
    for pkg in "${FLATPAK_PACKAGES[@]}"; do
        if flatpak list --app | grep -qw "$pkg"; then
            msg ok "$pkg already installed"
        else
            flatpak install -y flathub "$pkg" && msg ok "$pkg installed"
        fi
    done
}

full_update() {
    msg info "Updating APT..."
    sudo apt update -y && sudo apt upgrade -y

    if command -v flatpak &>/dev/null; then
        msg info "Updating Flatpak..."
        flatpak update -y
    fi

    if command -v snap &>/dev/null; then
        msg info "Updating Snap..."
        sudo snap refresh
    fi


    echo -ne "${YELLOW}Do you want to exit the program? (y/n): ${RESET}"
    read choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        exit 0
    fi
}

system_cleanup() {
    msg info "Cleaning APT..."
    sudo apt autoremove -y && sudo apt autoclean -y && sudo apt clean -y

    if command -v flatpak &>/dev/null; then
        msg info "Removing unused Flatpaks..."
        flatpak uninstall --unused -y
    fi

    echo -ne "${YELLOW}Do you want to exit the program? (y/n): ${RESET}"
    read choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        exit 0
    fi
}

reboot_system() {
    msg warn "System will reboot in 10 seconds..."
    sleep 10
    sudo reboot
}

setup_ubuntu() {
    update_system
    install_apt
    install_flatpak


    echo -ne "${YELLOW}Do you want to exit the program? (y/n): ${RESET}"
    read choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        exit 0
    fi
}

# ===================================
#  MENU SYSTEM
# ===================================
while true; do
    clear
    echo -e "${GREEN}========= Ubuntu Maintenance Menu =========${RESET}"
    echo "1. Setup Freshly Installed Ubuntu"
    echo "2. Perform Full System Update (APT/Flatpaks/Snaps)"
    echo "3. Perform System Cleanup"
    echo "4. Reboot The System"
    echo "5. Exit From The Program"
    echo -ne "${YELLOW}Choose an option [1-5]: ${RESET}"
    read choice

    case $choice in
        1) setup_ubuntu ;;
        2) full_update ;;
        3) system_cleanup ;;
        4) reboot_system ;;
        5) exit 0 ;;
        *) msg err "Invalid choice!"; sleep 2 ;;
    esac
done
