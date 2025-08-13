#!/bin/bash

#==================== Colors ====================#
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[93m"
BLUE="\e[34m"
CYAN="\e[36m"
MAGENTA="\e[35m"
RESET="\e[0m"

#==================== Custom Packages ====================#
APT_PACKAGES=(
    vlc
    htop
    flatpak
    okular
    kwrite
    kate
    kdeconnect
)

FLATPAK_PACKAGES=(
    org.mozilla.firefox
    org.libreoffice.LibreOffice
    org.localsend.localsend_app
    com.github.jeromerobert.pdfarranger
    org.telegram.desktop
)

CUSTOM_ALIASES=(
    "refresh='sudo apt update'"
    "updates='apt list --upgradable'"
    "upgrade='sudo apt upgrade'"
    "failed='systemctl --failed'"
    "flist='flatpak list'"
    "flistapps='flatpak list --app'"
    "fupdate='flatpak update'"
    "ll='ls -la --color=auto'"
    "update='sudo apt update && sudo apt upgrade -y'"
    "clean='sudo apt autoremove -y && sudo apt clean'"
)

#==================== Helper Functions ====================#
apt_update() { sudo apt update -y && sudo apt upgrade -y; }
flatpak_update() { flatpak update -y; }
snap_update() { sudo snap refresh; }
setup_flatpak() {
    sudo apt install -y flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}
install_apt_packages() { sudo apt install -y "$@"; }
install_flatpak_packages() { flatpak install -y flathub "$@"; }
cleaning() {
    sudo apt autoremove -y && sudo apt autoclean -y && sudo apt clean
    flatpak remove --unused -y
}
rebooting() { sudo reboot; }

#==================== Utility Functions ====================#
confirm_action() {
    echo -ne "${YELLOW}$1 (y/n): ${RESET}"
    read ans
    [[ $ans =~ ^[Yy]$ ]]
}

pause_return() {
    echo -e "${CYAN}Press Enter to return to menu...${RESET}"
    read
}

#==================== Modules ====================#
full_system_update() {
    if confirm_action "Perform Full System Update. Are you sure?"; then
        echo -e "${BLUE}Updating APT packages...${RESET}"
        apt_update

        if command -v flatpak &>/dev/null; then
            echo -e "${BLUE}Updating Flatpak packages...${RESET}"
            flatpak_update
        else
            echo -e "${RED}Flatpak not installed, skipping.${RESET}"
        fi

        if command -v snap &>/dev/null; then
            echo -e "${BLUE}Updating Snap packages...${RESET}"
            snap_update
        else
            echo -e "${RED}Snap not installed, skipping.${RESET}"
        fi

        echo -e "${GREEN}System update complete.${RESET}"
    else
        echo -e "${RED}Cancelled.${RESET}"
    fi
    pause_return
}

system_cleaning() {
    if confirm_action "Perform Full System Cleaning. Are you sure?"; then
        echo -e "${BLUE}Cleaning system...${RESET}"
        cleaning
        echo -e "${GREEN}Cleanup complete.${RESET}"
    else
        echo -e "${RED}Cancelled.${RESET}"
    fi
    pause_return
}

setup_ubuntu() {
    if confirm_action "Setup Your New Ubuntu System. Are you sure?"; then

        echo -e "${BLUE}Updating base system...${RESET}"
        apt_update

        if ! command -v flatpak &>/dev/null; then
            echo -e "${BLUE}Installing and setting up Flatpak...${RESET}"
            setup_flatpak
        fi

        echo -e "${BLUE}Installing APT software...${RESET}"
        missing_apt=()
        for pkg in "${APT_PACKAGES[@]}"; do
            dpkg -l | grep -qw "$pkg" || missing_apt+=("$pkg")
        done
        [[ ${#missing_apt[@]} -gt 0 ]] && install_apt_packages "${missing_apt[@]}"

        echo -e "${BLUE}Installing Flatpak software...${RESET}"
        missing_flatpak=()
        for pkg in "${FLATPAK_PACKAGES[@]}"; do
            flatpak list | grep -qw "$pkg" || missing_flatpak+=("$pkg")
        done
        [[ ${#missing_flatpak[@]} -gt 0 ]] && install_flatpak_packages "${missing_flatpak[@]}"

        echo -e "${BLUE}Adding custom aliases...${RESET}"
        SHELL_RC="$HOME/.bashrc"
        [[ $SHELL == *zsh ]] && SHELL_RC="$HOME/.zshrc"

        for alias_cmd in "${CUSTOM_ALIASES[@]}"; do
            alias_name="${alias_cmd%%=*}"
            if ! grep -Fq "alias $alias_name=" "$SHELL_RC"; then
                echo "alias ${alias_cmd}" >> "$SHELL_RC"
                echo -e "${GREEN}Added:${RESET} alias ${alias_cmd}"
            else
                echo -e "${YELLOW}Alias already exists:${RESET} alias ${alias_cmd}"
            fi
        done

        echo -e "${CYAN}Reload your shell or run: source $SHELL_RC${RESET}"
        echo -e "${GREEN}Ubuntu setup complete.${RESET}"
    else
        echo -e "${RED}Cancelled.${RESET}"
    fi
    pause_return
}

system_reboot() {
    if confirm_action "Perform System Reboot. Are you sure?"; then
        echo -e "${YELLOW}System will reboot in 10 seconds... Press Ctrl+C to cancel.${RESET}"
        for ((i=10; i>0; i--)); do
            echo -ne "${CYAN}Rebooting in $i seconds...    \r${RESET}"
            sleep 1
        done
        echo -e "\n${BLUE}Rebooting now...${RESET}"
        rebooting
    else
        echo -e "${RED}Cancelled.${RESET}"
    fi
    pause_return
}

#==================== Menu ====================#
while true; do
    clear
    echo -e "${MAGENTA}╔════════════════════════════════════════╗${RESET}"
    echo -e "${MAGENTA}║      🛠  Ubuntu Maintenance Tool        ║${RESET}"
    echo -e "${MAGENTA}╠════════════════════════════════════════╣${RESET}"
    echo -e "${CYAN} 1)${RESET} Perform Full System Update"
    echo -e "${CYAN} 2)${RESET} Perform System Cleaning"
    echo -e "${CYAN} 3)${RESET} Setup Your Freshly Installed Ubuntu System"
    echo -e "${CYAN} 4)${RESET} Reboot System"
    echo -e "${CYAN} 5)${RESET} Exit"
    echo -e "${MAGENTA}╚════════════════════════════════════════╝${RESET}"
    read -p "Enter your choice: " choice

    case $choice in
        1) full_system_update ;;
        2) system_cleaning ;;
        3) setup_ubuntu ;;
        4) system_reboot ;;
        5) echo -e "${GREEN}Goodbye!${RESET}"; exit 0 ;;
        *) echo -e "${RED}Invalid choice. Try again.${RESET}"; sleep 1 ;;
    esac
done
