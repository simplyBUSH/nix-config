{ pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
    curl
    eza
    fastfetch
    fd
    ffmpeg
    fzf
    gping
    jq
    mosh
    ripgrep
    speedtest-cli
    tree
    iw
    uv
    wget
  ];

  imports = [
    ./git.nix
    ./hyfetch.nix
    ./nvim.nix
    ./yazi.nix
  ];
}
