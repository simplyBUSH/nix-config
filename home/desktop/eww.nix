{ pkgs, ... }:
{
  programs.eww = {
    enable = true;
#    package = pkgs.eww;

#    yuckConfig = builtins.readFile ./eww/eww.yuck;
#    scssConfig = builtins.readFile ./eww/eww.scss;
  };
}
