{ pkgs, ... }:
{
  imports = [
    ./eww.nix
    ./hyprland.nix
    ./wofi.nix
#    ./sway.nix
  ];

  home.packages = with pkgs; [
    swaybg
    grimblast
  ];
}
