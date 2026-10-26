{ pkgs, accent, osConfig, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";

    settings = {
      "$mod" = "SUPER";
      "$term" = "foot";
      monitor = ", preferred, auto, 1";
      exec-once = [ 
          "swaybg -i ${../../resources/pictures/wallpaper.png} -m fill"
          "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%"
          "eww open-many bar corner-tl corner-tr corner-bl corner-br"
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
        resize_on_border = true;
        extend_border_grab_area = 15;
      };

      decoration = {
        rounding = 0;
        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          new_optimizations = true;
          noise = 0.04;
        };
        shadow = {
          enabled = false;
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
        touchpad.scroll_factor = 0.5;
        kb_layout = "pl";
        repeat_rate = 50;

        repeat_delay = 300;
      };


      gesture = [
        "3, horizontal, move"
        "3, vertical, move"
      ];
      
      layerrule = [
        "blur on, ignore_alpha 0.1, match:namespace ^(calendar)$"
        "blur on, ignore_alpha 0.1, match:namespace ^(control-menu)$"
        "blur on, ignore_alpha 0.1, match:namespace ^(pwr-menu)$"
      ];

      # Workspace switching
      bind = [
        "$mod, 1, exec, sh -c 'hyprctl dispatch workspace 1 && eww update desktop=1'"
        "$mod, 2, exec, sh -c 'hyprctl dispatch workspace 2 && eww update desktop=2'"
        "$mod, 3, exec, sh -c 'hyprctl dispatch workspace 3 && eww update desktop=3'"
        "$mod, 4, exec, sh -c 'hyprctl dispatch workspace 4 && eww update desktop=4'"
        "$mod, 5, exec, sh -c 'hyprctl dispatch workspace 5 && eww update desktop=5'"
        "$mod, 6, exec, sh -c 'hyprctl dispatch workspace 6 && eww update desktop=6'"
        "$mod, 7, exec, sh -c 'hyprctl dispatch workspace 7 && eww update desktop=7'"
        "$mod, 8, exec, sh -c 'hyprctl dispatch workspace 8 && eww update desktop=8'"
        "$mod, 9, exec, sh -c 'hyprctl dispatch workspace 9 && eww update desktop=9'"
        "$mod, 0, exec, sh -c 'hyprctl dispatch workspace 10 && eww update desktop=10'"

        # Move window to workspace
        "$mod ALT, 1, exec, sh -c 'hyprctl dispatch movetoworkspace 1 && eww update desktop=1'"
        "$mod ALT, 2, exec, sh -c 'hyprctl dispatch movetoworkspace 2 && eww update desktop=2'"
        "$mod ALT, 3, exec, sh -c 'hyprctl dispatch movetoworkspace 3 && eww update desktop=3'"
        "$mod ALT, 4, exec, sh -c 'hyprctl dispatch movetoworkspace 4 && eww update desktop=4'"
        "$mod ALT, 5, exec, sh -c 'hyprctl dispatch movetoworkspace 5 && eww update desktop=5'"
        "$mod ALT, 6, exec, sh -c 'hyprctl dispatch movetoworkspace 6 && eww update desktop=6'"
        "$mod ALT, 7, exec, sh -c 'hyprctl dispatch movetoworkspace 7 && eww update desktop=7'"
        "$mod ALT, 8, exec, sh -c 'hyprctl dispatch movetoworkspace 8 && eww update desktop=8'"
        "$mod ALT, 9, exec, sh -c 'hyprctl dispatch movetoworkspace 9 && eww update desktop=9'"
        "$mod ALT, 0, exec, sh -c 'hyprctl dispatch movetoworkspace 10 && eww update desktop=10'"

        # Focus
        "$mod, left, movefocus, l"
        "$mod, down, movefocus, d"
        "$mod, up, movefocus, u"
        "$mod, right, movefocus, r"

        # Swap
        "$mod ALT, left, swapwindow, l"
        "$mod ALT, right, swapwindow, r"

        # Layout
        "$mod SHIFT, F, togglefloating,"
        "$mod, F, fullscreen,"

        # Apps
        "$mod, Return, exec, $term"
        "$mod, M, exec, element-desktop"
        "$mod, R, exec, hyprctl reload"
        "$mod, T, exec, $term"
        "$mod, V, exec, vesktop"
        "$mod, W, exec, firefox"

        # Wofi launcher
        "$mod, space, exec, wofi --show drun"

        # Close window
        "$mod, Q, killactive,"
        "$mod SHIFT, Q, forcekillactive,"

        "$mod, L, exec, pkill hyprland"
        
        "$mod SHIFT, F23, exec, eww open --toggle activate-linux"

        ", XF86Launch7 , exec, ${pkgs.grimblast}/bin/grimblast copy area"
        "$mod SHIFT, S, exec, ${pkgs.grimblast}/bin/grimblast copy area"
        "$mod, P, exec, ${pkgs.grimblast}/bin/grimblast copy screen"

        ", XF86Calculator, exec, ${pkgs.gnome-calculator}/bin/gnome-calculator"

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

        ", XF86PowerOff, exec, sh -c 'if eww active-windows | grep -q 'pwr-menu'; then eww close pwr-menu closer || true; else eww close calendar control-menu || true; eww open closer; eww open pwr-menu; fi'"
      ];
      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && eww update volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print (/MUTED/ ? -1 : int($2 * 100))}')"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];

       windowrule = [
        "match:class org.gnome.Calculator, float on"
        "match:class org.gnome.Calculator, size 400 550"
      ];
    };
  };
}
