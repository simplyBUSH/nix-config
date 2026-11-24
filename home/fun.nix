{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hollywood
    cmatrix
    cbonsai
    asciiquarium
    byobu
  ];
}
