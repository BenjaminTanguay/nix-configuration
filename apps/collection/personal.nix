{ config, pkgs, ... }:

{
  imports = [
    ./base-cli.nix
    ./base-nix-ui.nix
    ./base-mac-ui.nix
  ];
}

