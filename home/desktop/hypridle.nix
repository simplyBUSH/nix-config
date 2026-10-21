{ pkgs, accent, osConfig, ... }:
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on"; 
        ignore_dbus_inhibit = false;
      };
      listener = [
        {
          timeout = 500;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 530;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 540;
          on-timeout = "systemctl suspend-then-hibernate";
        }
      ];
    };
  };
}
