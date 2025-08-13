# 🛠 Ubuntu Maintenance Tool

A simple yet powerful **Bash script** for maintaining, cleaning, and setting up your Ubuntu system.
It provides a colorful menu-driven interface for easy system updates, cleanup, and initial setup.

---

## ✨ Features

- **Full System Update**
  - Updates APT, Flatpak, and Snap packages (if installed).
- **System Cleaning**
  - Removes unused packages and cleans cache.
- **Fresh Ubuntu Setup**
  - Installs your predefined APT & Flatpak packages.
  - Adds custom shell aliases (only if not already present).
- **Reboot Option**
  - Safe reboot with countdown.
- **Colorful Menu**
  - Easy-to-read and user-friendly.

---

## 📦 Preconfigured Software

**APT Packages:**
vlc, htop, flatpak, okular, kwrite, kate, kdeconnect


**Flatpak Packages:**
org.mozilla.firefox, org.libreoffice.LibreOffice,
org.localsend.localsend_app, com.github.jeromerobert.pdfarranger,
org.telegram.desktop


**Custom Aliases:**
refresh, updates, upgrade, failed, flist, flistapps,
fupdate, ll, update, clean


---

## 📋 Requirements

- Ubuntu or Ubuntu-based distro
- `bash` shell
- `sudo` privileges
- Internet connection

---

## 🚀 Installation & Usage

1. **Clone the Repository**
   ```bash
   git clone https://github.com/oncore200/ubuntu.git
   cd ubuntu
   ```

2. **Make the Script Executable**
   ```bash
   chmod +x manage-ubuntu.sh
   ```
3. **Run the Script**
   ```bash
   ./manage-ubuntu.sh
   ```
## 📋 Menu Options

| Option | Description                         |
| ------ | ----------------------------------- |
| 1      | Perform Full System Update          |
| 2      | Perform System Cleaning             |
| 3      | Setup Fresh Ubuntu (apps + aliases) |
| 4      | Reboot System                       |
| 5      | Exit Tool                           |


## ⚠️ Notes

-Aliases are added only if they don't already exist in your shell configuration (.bashrc or .zshrc).
-Flatpak and Snap updates are skipped if not installed.
-Setup Ubuntu checks for missing packages before installing.

## 📜 License

This project is released under the MIT License.


