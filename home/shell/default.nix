{ pkgs, ...}:
{
  imports = [
#    ./alacritty.nix
    ./tmux.nix
    ./zsh.nix
    ./foot.nix
  ];

  home.packages = with pkgs; [
    antigravity-cli
  ];

}
