{ pkgs, ... }:

{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:style=Regular";
        pad = "6x6";
      };

      csd = {
        preferred = "none";
      };

      colors = {
        background = "000000";
      };
    };
  };
}
