{ config, pkgs, ... }:

{
  system.stateVersion = 5;

  # Enable the Nix Daemon for multi-user setup
  services.nix-daemon.enable = true;
  nix.useDaemon = true;

  environment.systemPackages = with pkgs; [
    wget
    git
  ];

  system.defaults = {
    dock.autohide = true;
  };
}

