{ config, pkgs, ... }:

{
  imports = [
    ../cli
    ../shell
  ];

  targets.genericLinux.enable = true;

  home = {
    username = "bush";
    homeDirectory = "/home/bush";
    stateVersion = "26.05";

    packages = with pkgs; [
      # Add any Pi-specific CLI packages here
    ];
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.home-manager.enable = true;
}
