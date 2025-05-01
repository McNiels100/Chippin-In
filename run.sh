#!/bin/bash

# Make sure the script is running with root privileges
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

echo "Installing terminal and desktop tools..."

# Install terminal tools
source ~/.local/share/chippin-in/install/terminal.sh

# Install desktop tools and tweaks
source ~/.local/share/chippin-in/install/desktop.sh

# Script end message
echo "Installation Complete!"
