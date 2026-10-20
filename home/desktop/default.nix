{ pkgs, ... }:
{
  imports = [
    ./eww.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./wofi.nix
#    ./sway.nix
  ];

  home.packages = with pkgs; [
    swaybg
    grimblast
  ];
}
