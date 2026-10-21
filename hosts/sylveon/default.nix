{ pkgs, ... }:

let
  accent = "#7B97A3";
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  home-manager.extraSpecialArgs = { inherit accent; };

  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "1h";
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    efibootmgr
    nh
    pciutils
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
    extraGroups = [ "wheel" "networkmanager" "video" "input" "uinput" "render" ];
    home = "/home/bush";
    shell = pkgs.zsh;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Warsaw";

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  security = {
    pam.howdy.enable = true;
    pam.services.hyprlock = {};
    pam.services.greetd.howdy.enable = false;
    pam.services.login.howdy.enable = false;
  };

  programs = {
    dconf.enable = true;
    hyprland ={
      enable = true;
      xwayland.enable = true;
    };
    steam.enable = true;
    xwayland.enable = true;
    zsh.enable = true;
  };

  services = {
    blueman.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    tlp.enable = true;

    howdy = {
      enable = true;
      control = "sufficient";
      settings.video.dark_threshold = 85;
    };

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

    logind.settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandleLidSwitchExternalPower = "suspend-then-hibernate";
      HandlePowerKey = "suspend-then-hibernate";
  };

    udev.packages = with pkgs; [
      brightnessctl
    ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;

    amd-npu = {
      enable = true;
      enableNPU = true;
      enableLemonade = true;
      gpuTarget = "gfx1152";
      lemonade.user = "bush";
    };

    graphics = {
      enable = true;
      enable32Bit = true;
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
    kernel.sysctl = { "vm.swappiness" = 180; };
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [ "iommu=pt" "amd_iommu=on" ];

    resumeDevice = "/dev/disk/by-uuid/d8bcb427-2025-4edd-9724-b1dc84413626";


    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };
 }
