{ config, pkgs, ... }:

{
  imports = [
    ../cli/hyfetch.nix
    ../cli/nvim.nix
    ../cli/yazi.nix
    ../shell/tmux.nix
    ../shell/zsh.nix
  ];

  targets.genericLinux.enable = true;

  home = {
    username = "bush";
    homeDirectory = "/home/bush";
    stateVersion = "26.05";

    packages = with pkgs; [
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
        fend
    ];
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.home-manager.enable = true;
}
