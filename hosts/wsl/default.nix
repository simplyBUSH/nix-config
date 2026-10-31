{ pkgs, ... }:

let
  accent = "#FFFF00";
in
{
  home-manager.extraSpecialArgs = { inherit accent; };

  wsl = {
    enable = true;
    defaultUser = "bush";
  };

  environment.systemPackages = with pkgs; [
    nh
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";

  networking = {
    hostName = "wsl";
  };

  users.users.bush = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "render" ];
    home = "/home/bush";
    shell = pkgs.zsh;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Warsaw";

  programs.zsh.enable = true;

  services = {
    openssh.enable = true;
  };
}
