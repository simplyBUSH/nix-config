{ pkgs, inputs, ... }:
{
  imports = [
#    ./discordo.nix
    ./element.nix
#    ./iamb.nix
    ./vesktop.nix
  ];
  home.packages = [
#    inputs.sable-next.packages.${pkgs.system}.sable
  ];
}
