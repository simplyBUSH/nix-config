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
          timeout = 120; # 2 minutes
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 300; # 5 minutes
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 306; # 5.1 minutes
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
