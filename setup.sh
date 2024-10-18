#!/bin/bash
# Install Nix
if ! command -v nix &> /dev/null
then
    echo "Installing Nix..."
    sh <(curl -L https://nixos.org/nix/install) --daemon
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    echo "source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" >> ~/.bashrc
else
    echo "Nix already installed."
fi

# Install Nix-Darwin (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! command -v darwin-rebuild &> /dev/null
  then
      echo "Installing Nix-Darwin..."
      nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
      ./result/bin/darwin-installer
  else
      echo "Nix-Darwin already installed."
  fi

  # Ensure NIX_PATH includes both darwin and nixpkgs
  if [[ -z "${NIX_PATH##*darwin=*}" || -z "${NIX_PATH##*nixpkgs=*}" ]]; then
      echo "Setting up NIX_PATH for Nix-Darwin and nixpkgs..."
      export NIX_PATH=nixpkgs=https://nixos.org/channels/nixpkgs-unstable:darwin=https://github.com/LnL7/nix-darwin/archive/master.tar.gz
      echo 'export NIX_PATH=nixpkgs=https://nixos.org/channels/nixpkgs-unstable:darwin=https://github.com/LnL7/nix-darwin/archive/master.tar.gz' >> ~/.bashrc
      echo 'export NIX_PATH=nixpkgs=https://nixos.org/channels/nixpkgs-unstable:darwin=https://github.com/LnL7/nix-darwin/archive/master.tar.gz' >> ~/.zshrc
  fi
fi

source ~/.zshrc
source ~/.bashrc
