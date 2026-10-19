{ pkgs, accent, osConfig, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";

    settings = {
      "$mod" = "SUPER";
      "$term" = "alacritty";
      monitor = ", preferred, auto, 1";
      exec-once = [ 
          "swaybg -i ${../../resources/pictures/wallpaper.png} -m fill"
          "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%"
          "eww open bar"
        ];
      cursor = {
        no_hardware_cursors = true;
      };

      env = [
        "XCURSOR_THEME,Adwaita"
        "XCURSOR_SIZE,24"
      ];

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 0;
        "col.active_border" = "rgb(${builtins.substring 1 6 accent})";
        "col.inactive_border" = "rgb(444444)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;
        blur = {
          enabled = false;
          size = 5;
          passes = 2;
        };
        shadow = {
          enabled = true;
          range = 8;
          render_power = 2;
        };
      };

      animations = {
        enabled = true;
        bezier = "ease, 0.25, 0.1, 0.25, 1.0";
        animation = [
          "windows, 1, 4, ease"
          "windowsOut, 1, 4, ease, popin 80%"
          "fade, 1, 4, ease"
          "workspaces, 1, 3, ease"
        ];
      };


      input = {
        follow_mouse = 1;
        accel_profile = if osConfig.networking.hostName == "sylveon" then "adaptive" else "flat";
        sensitivity = if osConfig.networking.hostName == "sylveon" then -0.1 else -0.5;
        kb_layout = "pl";
        repeat_rate = 50;

        repeat_delay = 300;
      };

      # Workspace switching
      bind = [
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move window to workspace
        "$mod ALT, 1, movetoworkspace, 1"
        "$mod ALT, 2, movetoworkspace, 2"
        "$mod ALT, 3, movetoworkspace, 3"
        "$mod ALT, 4, movetoworkspace, 4"
        "$mod ALT, 5, movetoworkspace, 5"
        "$mod ALT, 6, movetoworkspace, 6"
        "$mod ALT, 7, movetoworkspace, 7"
        "$mod ALT, 8, movetoworkspace, 8"
        "$mod ALT, 9, movetoworkspace, 9"
        "$mod ALT, 0, movetoworkspace, 10"

        # Focus
        "$mod, left, movefocus, l"
        "$mod, down, movefocus, d"
        "$mod, up, movefocus, u"
        "$mod, right, movefocus, r"

        # Swap
        "$mod ALT, left, swapwindow, l"
        "$mod ALT, right, swapwindow, r"

        # Layout
        "$mod ALT, space, togglefloating,"
        "$mod, F, fullscreen,"

        # Apps
        "$mod, E, exec, nautilus"
        "$mod, Return, exec, $term"
        "$mod, M, exec, element-desktop"
        "$mod, R, exec, hyprctl reload"
        "$mod, S, exec, XDG_CURRENT_DESKTOP=GNOME gnome-control-center"
        "$mod, T, exec, $term"
        "$mod, V, exec, vesktop"
        "$mod, W, exec, firefox"

        # Wofi launcher
        "$mod, space, exec, wofi --show drun"

        # Close window
        "$mod, Q, killactive,"

        ", XF86Cut, exec, ${pkgs.grimblast}/bin/grimblast copy area"
        "$mod SHIFT, S, exec, ${pkgs.grimblast}/bin/grimblast copy area"

      ];

      # Mouse binds
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

bindel = [
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+ && eww update brightness=$(brightnessctl -m | cut -d, -f4 | tr -d %)"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%- && eww update brightness=$(brightnessctl -m | cut -d, -f4 | tr -d %)"
        ", XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ && eww update volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print (/MUTED/ ? -1 : int($2 * 100))}')"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && eww update volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print (/MUTED/ ? -1 : int($2 * 100))}')"
      ];
      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && eww update volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print (/MUTED/ ? -1 : int($2 * 100))}')"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];
    };
  };
}
