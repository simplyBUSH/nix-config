{ config, pkgs, lib, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_zen;
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

boot.kernelParams = [
    "iommu=pt"        # Fixes nvme 0000:bf:00.0 AMD-Vi IO_PAGE_FAULT storm on s2idle resume
    "amd_iommu=on"
  ];

  environment.systemPackages = with pkgs; [
    pciutils
  ];

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandlePowerKey = "suspend";
  };
}
