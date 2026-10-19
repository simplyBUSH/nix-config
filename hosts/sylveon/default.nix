{ pkgs, ... }:

let
  accent = "#F5AAB9";
in
{
  imports = [
    ./hardware-configuration.nix
    ./sleepfuckery.nix
  ];
  home-manager.extraSpecialArgs = { inherit accent; };

  environment.systemPackages = with pkgs; [
    efibootmgr
    brightnessctl
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
  networking = {
  hostName = "sylveon";
  networkmanager = { enable = true; };
  firewall.trustedInterfaces = [ "tailscale0" ];
};

  users.users.bush = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" "uinput" ];
    home = "/home/bush";
    shell = pkgs.zsh;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Warsaw";

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs = {
    dconf.enable = true;
    hyprland ={
      enable = true;
      xwayland.enable = true;
    };
    steam.enable = true;
    xwayland.enable = true;
    zsh.enable = true;
    kdeconnect.enable = true;
  };

  services = {
    blueman.enable = true;
    openssh.enable = true;
    tailscale.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --background matrix --remember --cmd start-hyprland";
          user = "greeter";
          };
        };
      };

    keyd = {
      enable = true; 
      keyboards = {
        default = {
          ids = [ "*" ]; 
          settings = {
            main = {
              capslock = "leftmeta";
            };
          };
        };
      };
    };

    avahi = {
      enable = true;
      publish.enable = true;
      publish.userServices = true;
    };

    tlp = {
      enable = true;
    };

    udev.packages = with pkgs; [
      brightnessctl
    ];
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
      mesa.opencl
      ];
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    uinput.enable = true;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
    algorithm = "zstd";
    priority = 100;
  };


  boot = {
    initrd.kernelModules = [ "usbhid" "hid_generic" "cpuid" ];
    kernel.sysctl = {
        "vm.swappiness" = 180;
      };

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };
 }
