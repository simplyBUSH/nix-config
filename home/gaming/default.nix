{ pkgs, ... }:

{
  home.packages = with pkgs; [
    prismlauncher
    protonplus
    olympus
    adwsteamgtk
  #  r2modman
  ];
}
