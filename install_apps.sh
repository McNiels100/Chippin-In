#!/bin/bash

# Make sure the script is running with root privileges
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

# Update package lists
echo "Updating package lists..."
apt update
apt upgrade -y
apt-get update
apt-get upgrade -y

# Install required dependencies
echo "Installing required dependencies..."
apt install -y curl build-essential rustc libssl-dev libyaml-dev zlib1g-dev libgmp-dev git

# Install Zed Editor
echo "Installing Zed Editor..."
curl -f https://zed.dev/install.sh | sh

# Install Brave Browser
echo "Installing Brave Browser..."
curl -fsS https://dl.brave.com/install.sh | sh

# Install LocalSend
echo "Installing LocalSend..."
snap install localsend

# Install Docker
echo "Installing Docker..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

groupadd docker
sudo usermod -aG docker $USER

# Install Mise Manager
echo "Installing Mise Manager..."
curl https://mise.run | MISE_QUIET=1 sh
if [ $? -ne 0 ]; then
  echo "Error: Mise installation failed!"
  exit 1
fi

echo "Activating Mise..."
eval "$(~/.local/bin/mise activate)"

if ! command -v mise &> /dev/null; then
  echo "Error: Mise is not in PATH.  Check your installation."
  exit 1
fi

# Install Ruby with Mise Manager
echo "Installing Ruby with Mise..."
mise install ruby@3
mise use -g ruby@3
if [ $? -ne 0 ]; then
  echo "Error: Failed to set Ruby version with Mise."
  exit 1
fi

# Install Ruby on Rails
echo "Installing Ruby on Rails..."
gem install rails
if [ $? -ne 0 ]; then
  echo "Error: Failed to install Rails gem."
  exit 1
fi

# Install Ruby LSP gem
gem install ruby-lsp

# Install rubocop LSP gem
gem install rubocop

# Install 1Password
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list

sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

sudo apt update && sudo apt install 1password -y

# Script end message
echo "Installation Complete!"
