#!/bin/bash
# System Cleanup Script for WSL (Fedora)

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
LOG_FILE="/var/log/wsl_system_cleanup.log"

# Function to generate timestamps
get_timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
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

echo "";
echo "╔═══════════════════════════════════════════════════════════════╗";
echo "║                                                               ║";
echo "║   ███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗       ║";
echo "║   ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║       ║";
echo "║   ███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║       ║";
echo "║   ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║       ║";
echo "║   ███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║       ║";
echo "║   ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝       ║";
echo "║                                                               ║";
echo "║   ██████╗██╗     ███████╗ █████╗ ███╗   ██╗██╗   ██╗██████╗   ║";
echo "║  ██╔════╝██║     ██╔════╝██╔══██╗████╗  ██║██║   ██║██╔══██╗  ║";
echo "║  ██║     ██║     █████╗  ███████║██╔██╗ ██║██║   ██║██████╔╝  ║";
echo "║  ██║     ██║     ██╔══╝  ██╔══██║██║╚██╗██║██║   ██║██╔═══╝   ║";
echo "║  ╚██████╗███████╗███████╗██║  ██║██║ ╚████║╚██████╔╝██║       ║";
echo "║   ╚═════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝       ║";
echo "║                                                               ║";
echo "╚═══════════════════════════════════════════════════════════════╝";
echo "";
echo "This script performs various system cleanup tasks on WSL (Fedora)"
echo ""
echo "Note: Old kernel removal is not available in WSL."
echo ""

# Function to clear DNF cache
clear_dnf_cache() {
    color_echo "yellow" "Clearing DNF cache..."
    dnf clean all
    handle_error "Failed to clear DNF cache"
    color_echo "green" "DNF cache cleared."
}

# Function to remove orphaned packages
remove_orphaned_packages() {
    color_echo "yellow" "Removing orphaned packages..."
    dnf autoremove -y
    handle_error "Failed to remove orphaned packages"
    color_echo "green" "Orphaned packages removed."
}

# Function to clear user cache
clear_user_cache() {
    color_echo "yellow" "Clearing user cache..."
    if [ -d "$ACTUAL_HOME/.cache" ]; then
        find "$ACTUAL_HOME/.cache" -type f -delete
        find "$ACTUAL_HOME/.cache" -type d -empty -delete
    fi
    handle_error "Failed to clear user cache"
    color_echo "green" "User cache cleared."
}

# Function to clear systemd journal logs (only if systemd is enabled)
clear_journal_logs() {
    color_echo "yellow" "Clearing systemd journal logs..."
    if command -v journalctl &>/dev/null; then
        journalctl --vacuum-time=7d
        handle_error "Failed to clear systemd journal logs"
        color_echo "green" "Journal logs cleared."
    else
        color_echo "blue" "journalctl not available, skipping..."
    fi
}

# Function to clear temporary files
clear_temp_files() {
    color_echo "yellow" "Clearing temporary files..."
    rm -rf /tmp/*
    handle_error "Failed to clear temporary files"
    color_echo "green" "Temporary files cleared."
}

# Function to update the system
update_system() {
    color_echo "blue" "Updating the system..."
    dnf upgrade -y
    handle_error "Failed to update the system"
    color_echo "green" "System updated."
}

# Main menu
while true; do
    echo ""
    echo "Please choose a cleanup option:"
    echo "1) Clear DNF cache"
    echo "2) Remove orphaned packages"
    echo "3) Clear user cache"
    echo "4) Clear systemd journal logs"
    echo "5) Clear temporary files"
    echo "6) Update system"
    echo "7) Perform all cleanup tasks"
    echo "8) Exit"
    read -p "Enter your choice (1-8): " choice

    case $choice in
        1) clear_dnf_cache ;;
        2) remove_orphaned_packages ;;
        3) clear_user_cache ;;
        4) clear_journal_logs ;;
        5) clear_temp_files ;;
        6) update_system ;;
        7)
            clear_dnf_cache
            remove_orphaned_packages
            clear_user_cache
            clear_journal_logs
            clear_temp_files
            update_system
            ;;
        8) 
            color_echo "blue" "Exiting system cleanup script."
            exit 0
            ;;
        *)
            color_echo "red" "Invalid option. Please try again."
            ;;
    esac
done