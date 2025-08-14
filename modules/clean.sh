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
