{ pkgs, ... }:

{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:style=Regular:size=11";
        pad = "6x6";
      };

      csd = {
        preferred = "none";
      };

      colors-dark = {
        foreground = "f2f4f8";
        background = "000000"; 

        selection-foreground = "f2f4f8";
        selection-background = "2a2a2a";

        regular0 = "282828"; # black
        regular1 = "ee5396"; # red
        regular2 = "25be6a"; # green
        regular3 = "08bdba"; # yellow
        regular4 = "78a9ff"; # blue
        regular5 = "be95ff"; # magenta
        regular6 = "33b1ff"; # cyan
        regular7 = "dfdfe0"; # white

        bright0 = "484848"; # bright black
        bright1 = "f16da6"; # bright red
        bright2 = "46c880"; # bright green
        bright3 = "2dc7c4"; # bright yellow
        bright4 = "8cb6ff"; # bright blue
        bright5 = "c8a5ff"; # bright magenta
        bright6 = "52bdff"; # bright cyan
        bright7 = "e4e4e5"; # bright white

        # Extended colors
        "16" = "3ddbd9";
        "17" = "ff7eb6";
      };
    };
  };
}
