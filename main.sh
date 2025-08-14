#!/bin/bash

# Load utils
source utils/core.sh
source utils/config.sh

# Load modules
source modules/update.sh
source modules/clean.sh
source modules/setup.sh

while true; do
    clear
    echo -e "${MAGENTA}╔════════════════════════════════════════╗${RESET}"
    echo -e "${MAGENTA}║      🛠  Ubuntu Maintenance Tool        ║${RESET}"
    echo -e "${MAGENTA}╠════════════════════════════════════════╣${RESET}"
    echo -e "${CYAN} 1)${RESET} Perform Full System Update"
    echo -e "${CYAN} 2)${RESET} Perform System Cleaning"
    echo -e "${CYAN} 3)${RESET} Setup Your Freshly Installed Ubuntu System"
    echo -e "${CYAN} 4)${RESET} Exit"
    echo -e "${MAGENTA}╚════════════════════════════════════════╝${RESET}"
    read -p "Enter your choice: " choice

    case $choice in
        1) full_system_update ;;
        2) system_cleaning ;;
        3) setup_ubuntu ;;
        4) echo -e "${GREEN}Goodbye!${RESET}"; exit 0 ;;
        *) echo -e "${RED}Invalid choice. Try again.${RESET}"; sleep 1 ;;
    esac
done
