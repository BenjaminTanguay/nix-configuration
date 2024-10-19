{ config, pkgs, ... }:

{
  programs.neovim.enable = true;
  programs.neovim.package = pkgs.neovim;
  programs.neovim.plugins = with pkgs.vimPlugins; [
    vim-nix
    vim-airline
  ];
}

