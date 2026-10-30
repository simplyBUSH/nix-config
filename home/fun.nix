{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hollywood
    cmatrix
    cbonsai
    asciiquarium
    byobu
    cl-wordle
    pong3d
    benhsm-minesweeper
    _4d-minesweeper
  ];
}
