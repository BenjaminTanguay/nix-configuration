#!/bin/bash

echo "Starting setup script..."

# Install Nix
if ! command -v nix &> /dev/null; then
    echo "Nix not found. Installing Nix..."
    sh <(curl -L https://nixos.org/nix/install) --daemon
    if [ $? -eq 0 ]; then
        echo "Nix installed successfully."
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        echo "Sourcing Nix profile to current shell..."
        echo "source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" >> ~/.bashrc
        echo "source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" >> ~/.zshrc
    else
        echo "Failed to install Nix."
        exit 1
    fi
else
    echo "Nix is already installed."
fi

# Enable Nix Flakes and Nix Command
echo "Checking if Nix Flakes and Nix Command are enabled..."
if [ ! -f ~/.config/nix/nix.conf ] || ! grep -q "experimental-features = nix-command flakes" ~/.config/nix/nix.conf; then
    echo "Nix Flakes and Nix Command not found in configuration. Enabling..."
    mkdir -p ~/.config/nix
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

    # Restart Nix daemon on macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Restarting Nix daemon on macOS to apply configuration changes..."
        sudo launchctl stop org.nixos.nix-daemon
        sudo launchctl start org.nixos.nix-daemon
        if [ $? -eq 0 ]; then
            echo "Nix daemon restarted successfully on macOS."
        else
            echo "Failed to restart Nix daemon on macOS."
            exit 1
        fi
    else
        echo "Restarting Nix daemon on Linux to apply configuration changes..."
        sudo systemctl restart nix-daemon
        if [ $? -eq 0 ]; then
            echo "Nix daemon restarted successfully on Linux."
        else
            echo "Failed to restart Nix daemon on Linux."
            exit 1
        fi
    fi
else
    echo "Nix Flakes and Nix Command are already enabled."
fi

# Install Nix-Darwin (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected macOS. Checking for Nix-Darwin installation..."
    if ! command -v darwin-rebuild &> /dev/null; then
        echo "Nix-Darwin not found. Installing Nix-Darwin..."
        nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
        if [ $? -eq 0 ]; then
            ./result/bin/darwin-installer
            echo "Nix-Darwin installed successfully."
        else
            echo "Failed to build Nix-Darwin installer."
            exit 1
        fi
    else
        echo "Nix-Darwin is already installed."
    fi

    # Ensure NIX_PATH includes both darwin and nixpkgs
    echo "Ensuring NIX_PATH includes darwin and nixpkgs..."
    NIX_PATH_ENTRY='export NIX_PATH=nixpkgs=https://nixos.org/channels/nixpkgs-unstable:darwin=https://github.com/LnL7/nix-darwin/archive/master.tar.gz'
    if ! grep -q "$NIX_PATH_ENTRY" ~/.bashrc; then
        echo "Adding NIX_PATH to ~/.bashrc..."
        echo "$NIX_PATH_ENTRY" >> ~/.bashrc
    else
        echo "NIX_PATH already present in ~/.bashrc."
    fi

    if ! grep -q "$NIX_PATH_ENTRY" ~/.zshrc; then
        echo "Adding NIX_PATH to ~/.zshrc..."
        echo "$NIX_PATH_ENTRY" >> ~/.zshrc
    else
        echo "NIX_PATH already present in ~/.zshrc."
    fi
fi

# Install Home Manager using Flakes and ensure it's in the profile
echo "Checking for Home Manager installation..."
if ! command -v home-manager &> /dev/null; then
    echo "Home Manager not found. Installing Home Manager using Flakes..."
    nix profile install nixpkgs#home-manager
    if [ $? -eq 0 ]; then
        echo "Home Manager installed successfully."
    else
        echo "Failed to install Home Manager."
        exit 1
    fi
else
    echo "Home Manager is already installed."
fi

# Source shell configurations to apply updates
echo "Sourcing shell configurations..."
source ~/.zshrc
source ~/.bashrc

# Log Versions for Nix and Home Manager
echo "============================"
echo "Version Information:"
echo "============================"
echo -n "Nix Version: "
nix --version
echo -n "Home Manager Version: "
home-manager --version
echo "============================"

echo "Setup script completed successfully."

