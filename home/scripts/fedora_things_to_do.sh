#!/bin/bash
# "Things To Do!" script for a fresh Fedora Workstation installation

set -euo pipefail

# Check if the script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo"
    exit 1
fi

# Funtion to echo colored text
color_echo() {
    local color="$1"
    local text="$2"
    case "$color" in
        "red")     echo -e "\033[0;31m$text\033[0m" ;;
        "green")   echo -e "\033[0;32m$text\033[0m" ;;
        "yellow")  echo -e "\033[1;33m$text\033[0m" ;;
        "blue")    echo -e "\033[0;34m$text\033[0m" ;;
        *)         echo "$text" ;;
    esac
}

# Set variables
ACTUAL_USER=$SUDO_USER
ACTUAL_HOME=$(eval echo ~$SUDO_USER)
LOG_FILE="/var/log/fedora_things_to_do.log"
INITIAL_DIR=$(pwd)

# Function to generate timestamps
get_timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# Function to log messages
log_message() {
    local message="$1"
    echo "$(get_timestamp) - $message" | tee -a "$LOG_FILE"
}

# Function to handle errors
handle_error() {
    local exit_code=$?
    local message="$1"
    if [ $exit_code -ne 0 ]; then
        color_echo "red" "ERROR: $message"
        exit $exit_code
    fi
}

# Function to prompt for reboot
prompt_reboot() {
    if sudo -u $ACTUAL_USER bash -c 'read -p "It is time to reboot the machine. Would you like to do it now? (y/n): " choice; [[ $choice == [yY] ]]'; then
        color_echo "green" "Rebooting..."
        reboot
    else
        color_echo "red" "Reboot canceled."
    fi
}

# Function to backup configuration files
backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        cp "$file" "$file.bak"
        handle_error "Failed to backup $file"
        color_echo "green" "Backed up $file"
    fi
}

# Function to fix ownership of user directories created as root
fix_home_ownership() {
    color_echo "yellow" "Fixing home directory ownership..."
    local dirs=(
        "$ACTUAL_HOME/.local"
        "$ACTUAL_HOME/.config"
        "$ACTUAL_HOME/.cache"
        "$ACTUAL_HOME/.npm"
        "$ACTUAL_HOME/.nvm"
    )
    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            chown -R "$ACTUAL_USER:$ACTUAL_USER" "$dir" 2>/dev/null || true
        fi
    done
    color_echo "green" "Home directory ownership fixed."
}

echo "";
echo "╔═════════════════════════════════════════════════════════════════════════════╗";
echo "║                                                                             ║";
echo "║   ░█▀▀░█▀▀░█▀▄░█▀█░█▀▄░█▀█░░░█░█░█▀█░█▀▄░█░█░█▀▀░▀█▀░█▀█░▀█▀░▀█▀░█▀█░█▀█░   ║";
echo "║   ░█▀▀░█▀▀░█░█░█░█░█▀▄░█▀█░░░█▄█░█░█░█▀▄░█▀▄░▀▀█░░█░░█▀█░░█░░░█░░█░█░█░█░   ║";
echo "║   ░▀░░░▀▀▀░▀▀░░▀▀▀░▀░▀░▀░▀░░░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░░▀░░▀░▀░░▀░░▀▀▀░▀▀▀░▀░▀░   ║";
echo "║   ░░░░░░░░░░░░▀█▀░█░█░▀█▀░█▀█░█▀▀░█▀▀░░░▀█▀░█▀█░░░█▀▄░█▀█░█░░░░░░░░░░░░░░   ║";
echo "║   ░░░░░░░░░░░░░█░░█▀█░░█░░█░█░█░█░▀▀█░░░░█░░█░█░░░█░█░█░█░▀░░░░░░░░░░░░░░   ║";
echo "║   ░░░░░░░░░░░░░▀░░▀░▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░░░░▀░░▀▀▀░░░▀▀░░▀▀▀░▀░░░░░░░░░░░░░░   ║";
echo "║                                                                             ║";
echo "╚═════════════════════════════════════════════════════════════════════════════╝";
echo "";
echo "This script automates \"Things To Do!\" steps after a fresh Fedora Workstation installation"
echo "ver. 25.08 / 100 Stars Edition"
echo ""
echo "Don't run this script if you didn't build it yourself or don't know what it does."
echo ""
read -p "Press Enter to continue or CTRL+C to cancel..."

# System Upgrade
color_echo "blue" "Performing system upgrade... This may take a while..."
dnf upgrade -y


# System Configuration
# Optimize DNF package manager for faster downloads and efficient updates
color_echo "yellow" "Configuring DNF Package Manager..."
backup_file "/etc/dnf/dnf.conf"
dnf -y install dnf-plugins-core
# Max Parallel Downloads
echo "max_parallel_downloads=10" | tee -a /etc/dnf/dnf.conf > /dev/null
# Select Fastest Mirror
echo "fastestmirror=True" | tee -a /etc/dnf/dnf.conf > /dev/null
# Default Yes
echo "defaultyes=True" | tee -a /etc/dnf/dnf.conf > /dev/null

# Enable and configure automatic system updates to enhance security and stability
color_echo "yellow" "Enabling DNF autoupdate..."
dnf install dnf-automatic -y
sed -i 's/apply_updates = no/apply_updates = yes/' /etc/dnf/automatic.conf
systemctl enable --now dnf-automatic.timer

# Replace Fedora Flatpak Repo with Flathub for better package management and apps stability
color_echo "yellow" "Replacing Fedora Flatpak Repo with Flathub..."
dnf install -y flatpak
flatpak remote-delete fedora --force || true
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak repair
flatpak update

# Install and enable SSH server for secure remote access and file transfers
color_echo "yellow" "Installing and enabling SSH..."
dnf install -y openssh-server
systemctl enable --now sshd

# Check and apply firmware updates to improve hardware compatibility and performance
color_echo "yellow" "Checking for firmware updates..."
fwupdmgr refresh --force
fwupdmgr get-updates
fwupdmgr update -y

# Enable RPM Fusion repositories to access additional software packages and codecs
color_echo "yellow" "Enabling RPM Fusion repositories..."
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf update @core -y

# Install multimedia codecs to enhance multimedia capabilities
color_echo "yellow" "Installing multimedia codecs..."
dnf swap ffmpeg-free ffmpeg --allowerasing -y
dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
dnf update @sound-and-video -y

# Install Hardware Accelerated Codecs for AMD GPUs. This improves video playback and encoding performance on systems with AMD graphics.
color_echo "yellow" "Installing AMD Hardware Accelerated Codecs..."
dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y
dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y

# Install virtualization tools to enable virtual machines and containerization
color_echo "yellow" "Installing virtualization tools..."
dnf install -y @virtualization


# App Installation
# Install essential applications
color_echo "yellow" "Installing essential applications..."
dnf install -y btop htop rsync fastfetch unzip unrar git wget curl
color_echo "green" "Essential applications installed successfully."

# Install Internet & Communication applications
color_echo "yellow" "Installing Brave..."
dnf install -y dnf-plugins-core
if command -v dnf4 &>/dev/null; then
  dnf4 config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
else
  dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
fi
rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
dnf install -y brave-browser
color_echo "green" "Brave installed successfully."
color_echo "yellow" "Installing Discord..."
flatpak install -y flathub com.discordapp.Discord
color_echo "green" "Discord installed successfully."

# Install Development Tools
color_echo "yellow" "Installing zoxide..."
dnf install -y zoxide
color_echo "green" "zoxide installed successfully."

color_echo "yellow" "Installing neovim..."
dnf install -y neovim
color_echo "green" "neovim installed successfully."

color_echo "yellow" "Installing lazygit..."
dnf copr enable atim/lazygit -y
dnf install -y lazygit
color_echo "green" "lazygit installed successfully."

color_echo "yellow" "Installing golang..."
dnf install -y golang
color_echo "green" "golang installed successfully."

color_echo "yellow" "Installing nvm and Node.js..."
sudo -u "$ACTUAL_USER" bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash'
sudo -u "$ACTUAL_USER" bash -c 'source "$HOME/.nvm/nvm.sh" && nvm install --lts'
color_echo "green" "nvm and Node.js installed successfully."

# Install AI Coding CLIs
color_echo "yellow" "Installing opencode..."
sudo -u "$ACTUAL_USER" bash -c 'source "$HOME/.nvm/nvm.sh" && npm i -g opencode-ai@latest'
color_echo "green" "opencode installed successfully."

color_echo "yellow" "Installing gemini cli..."
sudo -u "$ACTUAL_USER" bash -c 'source "$HOME/.nvm/nvm.sh" && npm i -g @google/gemini-cli'
color_echo "green" "gemini cli installed successfully."

color_echo "yellow" "Installing codex cli..."
sudo -u "$ACTUAL_USER" bash -c 'source "$HOME/.nvm/nvm.sh" && npm i -g @openai/codex'
color_echo "green" "codex cli installed successfully."

color_echo "yellow" "Installing claude cli..."
sudo -u "$ACTUAL_USER" bash -c 'curl -fsSL https://claude.ai/install.sh | bash'
color_echo "green" "claude cli installed successfully."

# Install Office Productivity applications
color_echo "yellow" "Installing LibreOffice..."
dnf remove -y libreoffice*
flatpak install -y flathub org.libreoffice.LibreOffice
flatpak install -y --reinstall org.freedesktop.Platform.Locale/x86_64/24.08
flatpak install -y --reinstall org.libreoffice.LibreOffice.Locale
color_echo "green" "LibreOffice installed successfully."
color_echo "yellow" "Installing Bitwarden..."
flatpak install -y flathub com.bitwarden.desktop
color_echo "green" "Bitwarden installed successfully."

# Install Coding and DevOps applications
color_echo "yellow" "Installing Docker..."
dnf remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine --noautoremove
dnf -y install dnf-plugins-core
if command -v dnf4 &>/dev/null; then
  dnf4 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
else
  dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
fi
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker
systemctl enable --now containerd
groupadd docker
usermod -aG docker $ACTUAL_USER
rm -rf $ACTUAL_HOME/.docker
echo "Docker installed successfully. Please log out and back in for the group changes to take effect."
color_echo "green" "Docker installed successfully."
# Note: Docker group changes will take effect after logging out and back in
color_echo "yellow" "Installing Podman..."
dnf install -y podman
color_echo "green" "Podman installed successfully."

# Install Media & Graphics applications
color_echo "yellow" "Installing VLC..."
flatpak install -y flathub org.videolan.VLC
color_echo "green" "VLC installed successfully."
color_echo "yellow" "Installing Spotify..."
flatpak install -y flathub com.spotify.Client
color_echo "green" "Spotify installed successfully."
color_echo "yellow" "Installing MPV..."
flatpak install -y flathub io.mpv.Mpv
color_echo "green" "MPV installed successfully."

# Install Gaming & Emulation applications
color_echo "yellow" "Installing Steam..."
dnf install -y steam
color_echo "green" "Steam installed successfully."

# Install Remote Networking applications
color_echo "yellow" "Installing Remmina..."
flatpak install -y flathub org.remmina.Remmina
color_echo "green" "Remmina installed successfully."

# Install File Sharing & Download applications
color_echo "yellow" "Installing qBittorrent..."
flatpak install -y flathub org.qbittorrent.qBittorrent
color_echo "green" "qBittorrent installed successfully."

# Install System Tools applications
color_echo "yellow" "Installing Flatseal..."
flatpak install -y flathub com.github.tchx84.Flatseal
color_echo "green" "Flatseal installed successfully."
color_echo "yellow" "Installing Protontricks..."
flatpak install -y flathub com.github.Matoking.protontricks
color_echo "green" "Protontricks installed successfully."
color_echo "yellow" "Installing ProtonUp-Qt..."
flatpak install -y flathub net.davidotek.pupgui2
color_echo "green" "ProtonUp-Qt installed successfully."


# Customization
# Install Microsoft Windows fonts (core)
color_echo "yellow" "Installing Microsoft Fonts (core)..."
dnf install -y curl cabextract xorg-x11-font-utils fontconfig
rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
color_echo "green" "Microsoft Fonts (core) installed successfully."

# Install Google fonts collection
color_echo "yellow" "Installing Google Fonts..."
wget -O /tmp/google-fonts.zip https://github.com/google/fonts/archive/main.zip
mkdir -p $ACTUAL_HOME/.local/share/fonts/google
unzip /tmp/google-fonts.zip -d $ACTUAL_HOME/.local/share/fonts/google
rm -f /tmp/google-fonts.zip
chown -R "$ACTUAL_USER:$ACTUAL_USER" "$ACTUAL_HOME/.local/share/fonts/google"
fc-cache -fv
color_echo "green" "Google Fonts installed successfully."

# Install Adobe fonts collection
color_echo "yellow" "Installing Adobe Fonts..."
mkdir -p $ACTUAL_HOME/.local/share/fonts/adobe-fonts
git clone --depth 1 https://github.com/adobe-fonts/source-sans.git $ACTUAL_HOME/.local/share/fonts/adobe-fonts/source-sans
git clone --depth 1 https://github.com/adobe-fonts/source-serif.git $ACTUAL_HOME/.local/share/fonts/adobe-fonts/source-serif
git clone --depth 1 https://github.com/adobe-fonts/source-code-pro.git $ACTUAL_HOME/.local/share/fonts/adobe-fonts/source-code-pro
chown -R "$ACTUAL_USER:$ACTUAL_USER" "$ACTUAL_HOME/.local/share/fonts/adobe-fonts"
fc-cache -f
color_echo "green" "Adobe Fonts installed successfully."


# Custom user-defined commands
echo "Created with ❤️ for Open Source"


# Fix home directory ownership before finishing
fix_home_ownership

# Before finishing, ensure we're in a safe directory
cd /tmp || cd $ACTUAL_HOME || cd /

# Finish
echo "";
echo "╔═════════════════════════════════════════════════════════════════════════╗";
echo "║                                                                         ║";
echo "║   ░█░█░█▀▀░█░░░█▀▀░█▀█░█▄█░█▀▀░░░▀█▀░█▀█░░░█▀▀░█▀▀░█▀▄░█▀█░█▀▄░█▀█░█░   ║";
echo "║   ░█▄█░█▀▀░█░░░█░░░█░█░█░█░█▀▀░░░░█░░█░█░░░█▀▀░█▀▀░█░█░█░█░█▀▄░█▀█░▀░   ║";
echo "║   ░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░░░░▀░░▀▀▀░░░▀░░░▀▀▀░▀▀░░▀▀▀░▀░▀░▀░▀░▀░   ║";
echo "║                                                                         ║";
echo "╚═════════════════════════════════════════════════════════════════════════╝";
echo "";
color_echo "green" "All steps completed. Enjoy!"

# Prompt for reboot
prompt_reboot
