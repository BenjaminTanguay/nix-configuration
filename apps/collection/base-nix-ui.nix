{ config, pkgs, ... }:

{
  # Example of packages that may include GUI apps managed by Nix
  home.packages = with pkgs; [
    firefox
  ];
}

