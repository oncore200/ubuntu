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
