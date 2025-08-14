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
