Here's the README formatted in Markdown:

---

# Nix Configuration Repository

This repository manages system and user-space configurations using the Nix package manager. It provides a declarative way to set up environments on both macOS (M3 chips) and Linux virtual machines without relying on NixOS. The goal is to easily install applications, customize system settings, and manage configuration files consistently across different environments.

## Disclaimer

This is a work in progress. I will outline below what I want to do but make no promise of whether this achieves it or not.

## Objectives

- **Declarative Setup**: Use Nix to declare configurations for applications and the system, making it easy to replicate setups across multiple machines.
- **Environment-Specific Configuration**: Apply different configurations based on whether the system is a home computer, work computer, or Linux virtual machine.
- **User-Space Application Management**: Prefer installing applications in user space, making it easier to manage updates and dependencies without affecting the system environment.
- **Cross-Platform Compatibility**: Ensure that configurations can be easily adapted for macOS (aarch64 architecture) and Linux.

## Folder Structure

The following is the planned directory structure for this repository:

```
nix-config/
  apps/
    homebrew/
      firefox.nix      # Configuration for GUI apps managed via Homebrew
      spotify.nix      # More GUI apps configured similarly
    home-manager/
      neovim.nix       # Configuration for CLI tools managed via Home Manager
      tmux.nix         # More CLI apps configured similarly
    collection/
      base-cli.nix     # Collection of essential command-line tools for all systems
      base-nix-ui.nix  # Essential GUI apps, prioritizing Nix-managed apps for better replicability
      base-mac-ui.nix  # GUI apps specific to macOS environments
      personal.nix     # Personal set of applications for the personal home computer
      work.nix         # Work set of applications for work environments
  variables/
    environment/       # Environment-specific variables, managed by Home Manager
      personal.nix     # Variables unique to the personal environment
      work.nix         # Variables unique to the work environment
    profile/           # System profile variables used by Nix scripts
      personal.nix     # Profile configurations for personal setups
      work.nix         # Profile configurations for work setups
  system/
    mac/
      common.nix       # Common macOS settings applied across all macOS environments
      personal.nix     # macOS settings specific to the personal home computer
      work.nix         # macOS settings specific to work use
    linux/
      common.nix       # Common Linux settings applied across all Linux environments
    detect.nix         # Logic to detect the current system environment and architecture
  flake.nix            # Central configuration file using Nix Flakes
  README.md            # Documentation for the setup, usage, and configuration process
```

### Explanation of Each Folder

- **`apps/`**: Contains configurations for applications. Split into subfolders based on the method of installation:
  - **`homebrew/`**: For GUI applications managed by Homebrew.
  - **`home-manager/`**: For command-line tools managed via Home Manager.
  - **`collection/`**: Organizes app collections (e.g., `base-cli.nix` for essential tools, `personal.nix` for personal-specific apps).

- **`variables/`**: Manages environment-specific and profile-specific variables.
  - **`environment/`**: Variables that vary by environment (e.g., personal vs. work).
  - **`profile/`**: Nix-internal variables that influence profile behavior (e.g., usernames, email).

- **`system/`**: Contains configurations for system-level settings, organized by platform (macOS and Linux).
  - **`mac/`**: Platform-specific settings for macOS, split into `common`, `personal`, and `work` configurations.
  - **`linux/`**: Common Linux settings applied across all Linux environments.
  - **`detect.nix`**: Script for environment detection to apply the correct settings based on the system (home/work computer, VM, macOS/Linux).

- **`flake.nix`**: The central configuration file that integrates inputs (like `nixpkgs`, `home-manager`, and `darwin`) and outputs, specifying how to apply packages and configurations based on detected environments.

## Getting Started

To set up your environment, follow these steps:

1. **Install Nix**:
   Run the following command:
   ```bash
   sh <(curl -L https://nixos.org/nix/install) --daemon
   ```

2. **Enable Experimental Features**:
   Ensure Nix Flakes and `nix-command` are enabled by adding the following line to `~/.config/nix/nix.conf`:
   ```conf
   experimental-features = nix-command flakes
   ```

3. **Install Nix-Darwin (macOS Only)**:
   To install Nix-Darwin, run:
   ```bash
   nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
   ./result/bin/darwin-installer
   ```

4. **Install Home Manager**:
   To install Home Manager, run:
   ```bash
   nix-shell '<home-manager>' -A install
   ```

5. **Configure Your Environment Using `flake.nix`**:
   Use the template provided to set up `flake.nix` in the root of your Nix configuration directory. Run `nix flake check` to verify, and use `nix build` to test the default package installation.

## Goals

1. **Consistency**: Ensure consistent configurations across all systems.
2. **Simplicity**: Maintain a modular and easy-to-update structure.
3. **Reproducibility**: Make it easy to replicate the setup on new machines by relying on Nix's declarative syntax.

Feel free to customize the configurations and structures as needed to suit specific environments or preferences.
