{ config, pkgs, ... }:

{
  imports = [
    ../chat
    ../cli
    ../desktop
    ../shell
    ../gaming
#    ../rquickshare.nix
  ];

  home = {
    username = "bush";
    homeDirectory = "/home/bush";
    stateVersion = "26.05";

    packages = with pkgs; [
      firefox
      gnome-calculator
    ];

    pointerCursor = {
      enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
      gtk.enable = true;
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };


  gtk = {
    enable = true;
    gtk4.theme = null;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-icon-theme;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  programs.home-manager.enable = true;
}
