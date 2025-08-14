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
confirm_action() {
    echo -ne "${YELLOW}$1 (y/n): ${RESET}"
    read ans
    [[ $ans =~ ^[Yy]$ ]]
}

pause_return() {
    echo -e "${CYAN}Press Enter to return to menu...${RESET}"
    read
}

