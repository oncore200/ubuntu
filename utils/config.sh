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


#==================== Colors ====================#
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[93m"
BLUE="\e[34m"
CYAN="\e[36m"
MAGENTA="\e[35m"
RESET="\e[0m"
