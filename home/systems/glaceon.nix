{ config, pkgs, ... }:

{
  imports = [
    ../shell
    ../cli
    ../aerospace.nix
  ];

  home.packages = with pkgs; [
    prismlauncher
  ];

  home.username = "bush";
  home.homeDirectory = "/Users/bush";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
