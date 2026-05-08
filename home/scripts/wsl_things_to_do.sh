#!/bin/bash
# "Things To Do!" script for WSL (Fedora)

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
LOG_FILE="/var/log/wsl_things_to_do.log"
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

# Function to prompt for WSL restart
prompt_restart() {
    color_echo "yellow" "To apply all changes, restart WSL by running this command in PowerShell or CMD:"
    color_echo "blue" "  wsl --shutdown"
    color_echo "yellow" "Then open a new WSL session."
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

echo "";
echo "╔═════════════════════════════════════════════════════════════════════════════╗";
echo "║                                                                             ║";
echo "║   ░█▀▀░█▀▀░█▀▄░█▀█░█▀▄░█▀█░░░█░█░█▀█░█▀▄░█░█░█▀▀░▀█▀░█▀█░▀█▀░▀█▀░█▀█░█▀█░   ║";
echo "║   ░█▀▀░█▀▀░█░█░█░█░█▀▄░█▀█░░░█▄█░█░█░█▀▄░█▀▄░▀▀█░░█░░█▀█░░█░░░█░░█░█░█░█░   ║";
echo "║   ░▀░░░▀▀▀░▀▀░░▀▀▀░▀░▀░▀░▀░░░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░░▀░░▀░▀░░▀░░▀▀▀░▀▀▀░▀░▀░   ║";
echo "║   ░░░░░░░░░░░░▀█▀░█░█░▀█▀░█▀█░█▀▀░█▀▀░░░▀█▀░█▀█░░░█▀▄░█▀█░█░░░░░░░░░░░░░░░   ║";
echo "║   ░░░░░░░░░░░░░█░░█▀█░░█░░█░█░█░█░▀▀█░░░░█░░█░█░░░█░█░█░█░▀░░░░░░░░░░░░░   ║";
echo "║   ░░░░░░░░░░░░░▀░░▀░▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░░░░▀░░▀▀▀░░░▀▀░░▀▀▀░▀░░░░░░░░░░░░░   ║";
echo "║                                                                             ║";
echo "╚���════════════════════════════════════════════════════════════════════════════╝";
echo "";
echo "This script automates \"Things To Do!\" steps for WSL (Fedora)"
echo "ver. 25.08 / WSL Edition"
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

# SSH is typically installed by default in WSL but ensure it's available
color_echo "yellow" "Ensuring SSH is available..."
dnf install -y openssh-server
# WSL doesn't use systemd by default, so we configure sshd differently
if [ -f /etc/wsl.conf ]; then
    color_echo "blue" "wsl.conf already exists, skipping..."
else
    color_echo "yellow" "Creating wsl.conf for WSL configuration..."
    cat > /etc/wsl.conf << 'EOF'
[boot]
systemd=true

[interop]
enabled=true
appendWindowsPath=true

[automount]
enabled=true
options="metadata,umask=22"
mountFsTab=true
EOF
    color_echo "green" "wsl.conf created."
fi


# Enable RPM Fusion repositories to access additional software packages
color_echo "yellow" "Enabling RPM Fusion repositories..."
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf update @core -y


# App Installation
# Install essential applications for development
color_echo "yellow" "Installing essential applications..."
dnf install -y htop rsync fastfetch unzip unrar git wget curl
color_echo "green" "Essential applications installed successfully."

# Install development tools
color_echo "yellow" "Installing development tools..."
dnf install -y gcc gcc-c++ make cmake clang llvm
color_echo "green" "Development tools installed successfully."

# Install Docker
color_echo "yellow" "Installing Docker..."
dnf remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine --noautoremove
dnf -y install dnf-plugins-core
if command -v dnf4 &>/dev/null; then
  dnf4 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
else
  dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
fi
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Start Docker without systemd (WSL)
service docker start
color_echo "green" "Docker installed and started. Run 'service docker start' if needed."
color_echo "blue" "Note: If using Docker Desktop for Windows, this native Docker is optional."

color_echo "yellow" "Installing Podman..."
dnf install -y podman
color_echo "green" "Podman installed successfully."

color_echo "yellow" "Installing Zsh and Oh My Zsh..."
dnf install -y zsh
sudo -u $ACTUAL_USER sh -c "RUNZSH=no $(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
chsh -s $(which zsh) $ACTUAL_USER
sudo -u $ACTUAL_USER bash << EOF
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$ACTUAL_HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$ACTUAL_HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-$ACTUAL_HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$ACTUAL_HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sed -i 's/plugins=(git)/plugins=(dnf aliases genpass git zsh-autosuggestions zsh-autocomplete zsh-history-substring-search z zsh-syntax-highlighting)/' $ACTUAL_HOME/.zshrc
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="jonathan"/' $ACTUAL_HOME/.zshrc
EOF
color_echo "green" "Zsh and Oh My Zsh installed successfully."


# Custom user-defined commands
echo "Created with love for Open Source"
echo "WSL-optimized version"


# Before finishing, ensure we're in a safe directory
cd /tmp || cd $ACTUAL_HOME || cd /

# Finish
echo "";
echo "╔═════════════════════════════════════════════════════════════════════════╗";
echo "║                                                                         ║";
echo "║   ░█░█░█▀▀░█░░░█▀▀░█▀█░█▄█░█▀▀░░░▀█▀░█▀█░░░█▀▀░█▀▀░█▀▄░█▀█░█▀▄░█▀█░█░   ║";
echo "║   ░█▄█░█▀▀░█░░░█░░░█░█░█░█░█▀▀░░░░█░░█░█░░░█▀▀░█▀▀░█░█░█░█░█▀▄░█▀█░▀░   ║";
echo "║   ░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░░░░▀░░▀▀▀░░░▀░░░▀▀▀░▀▀░░▀▀▀░▀░▀░▀░▀░   ║";
echo "║                                                                         ║";
echo "╚═════════════════════════════════════════════════════════════════════════╝";
echo "";
color_echo "green" "All steps completed. Enjoy your WSL!"

# Prompt for WSL restart
prompt_restart