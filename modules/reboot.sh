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
