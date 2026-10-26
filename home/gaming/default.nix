{ pkgs, ... }:

{
  home.packages = with pkgs; [
    prismlauncher
    protonplus
    olympus
  #  r2modman
  ];
}
