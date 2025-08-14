confirm_action() {
    echo -ne "${YELLOW}$1 (y/n): ${RESET}"
    read ans
    [[ $ans =~ ^[Yy]$ ]]
}

pause_return() {
    echo -e "${CYAN}Press Enter to return to menu...${RESET}"
    read
}
