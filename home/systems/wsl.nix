{ config, pkgs, ... }:

{
  imports = [
    ../cli
    ../shell/tmux.nix
    ../shell/zsh.nix
  ];

  home.username = "bush";
  home.homeDirectory = "/home/bush";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
