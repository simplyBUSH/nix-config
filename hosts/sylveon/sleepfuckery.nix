{ config, pkgs, lib, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_zen;
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  boot.kernelParams = [
    #force s2
    "mem_sleep_default=s2idle"

    #enable smart trace buffer
    "amd_pmc.enable_stb=1"

    #reset keyboard
    "i8042.reset"
    "i8042.nomux"
    "i8042.nopnp"
    "i8042.noloop"

    #prevent the wifi card from hanging on pcie
    "mt7921e.disable_aspm=1"
    "mt7925e.disable_aspm=1"

    "iommu=pt"
  ];

  environment.systemPackages = with pkgs; [
    amd-debug-tools
    pciutils
  ];

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", DRIVER=="xhci_hcd", ATTR{power/wakeup}="disabled"
  '';

  boot.resumeDevice = "/dev/disk/by-uuid/d8bcb427-2025-4edd-9724-b1dc84413626";

  #Configure systemd to use suspend-then-hibernate on lid close
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend";
    HandlePowerKey = "suspend-then-hibernate";
    # Note: If you use hypridle to trigger sleep, omit IdleAction here so logind and hypridle don't fight
    IdleAction = "suspend-then-hibernate";
    IdleActionSec = "30min";
  };
  #Set how long the laptop stays in s2idle before automatically waking to write RAM to disk
  systemd.sleep.settings.Sleep = {
    AllowSuspend = "yes";
    AllowHibernation = "yes";
    AllowSuspendThenHibernate = "yes";
    HibernateDelaySec = "90min";
  };
}
