{ lib, pkgs, accent, osConfig, ... }:

let
  mkBind = keys: dispatcher: {
    _args = [
      (lib.generators.mkLuaInline keys)
      (lib.generators.mkLuaInline dispatcher)
    ];
  };

  mkBindFlags = keys: dispatcher: flags: {
    _args = [
      (lib.generators.mkLuaInline keys)
      (lib.generators.mkLuaInline dispatcher)
      flags
    ];
  };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    settings = {
      # Variables (generates: local mod = "SUPER", local term = "foot")
      mod = { _var = "SUPER"; };
      term = { _var = "foot"; };

      # Monitor (generates: hl.monitor({ ... }))
      monitor = [
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = 1;
        }
      ];

      # Startup commands (replaces exec-once)
      on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''
              function()
                hl.exec_cmd("swaybg -i ${../../resources/pictures/wallpaper.png} -m fill")
                hl.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%")
                hl.exec_cmd("eww open-many bar corner-tl corner-tr corner-bl corner-br")
              end
            '')
          ];
        }
      ];

      # Environment variables (generates: hl.env("KEY", "VALUE"))
      env = [
        { _args = [ "XCURSOR_THEME" "Adwaita" ]; }
        { _args = [ "XCURSOR_SIZE" "24" ]; }
      ];

      # Main configuration table (generates: hl.config({ ... }))
      config = {
        cursor = {
          no_hardware_cursors = true;
        };

        general = {
          gaps_in = 0;
          gaps_out = 0;
          border_size = 0;
          col = {
            active_border = "rgb(${builtins.substring 1 6 accent})";
            inactive_border = "rgb(444444)";
          };
          layout = "dwindle";
          resize_on_border = true;
          extend_border_grab_area = 15;
        };

        decoration = {
          rounding = 0;
          blur = {
            enabled = true;
            size = 4;
            passes = 1;
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
        };

        input = {
          follow_mouse = 1;
          accel_profile = if osConfig.networking.hostName == "sylveon" then "adaptive" else "flat";
          sensitivity = if osConfig.networking.hostName == "sylveon" then -0.1 else -0.5;
          touchpad = {
            scroll_factor = 0.5;
          };
          kb_layout = "pl";
          repeat_rate = 50;
          repeat_delay = 300;
        };
      };

      # Animation curves & leaves (replaces animations.bezier and animations.animation)
      curve = [
        {
          _args = [
            "ease"
            {
              type = "bezier";
              points = [
                [ 0.25 0.1 ]
                [ 0.25 1.0 ]
              ];
            }
          ];
        }
      ];

      animation = [
        { leaf = "windows"; enabled = true; speed = 4; curve = "ease"; }
        { leaf = "windowsOut"; enabled = true; speed = 4; curve = "ease"; style = "popin 80%"; }
        { leaf = "fade"; enabled = true; speed = 4; curve = "ease"; }
        { leaf = "workspaces"; enabled = true; speed = 3; curve = "ease"; }
      ];

      # Trackpad gestures (generates: hl.gesture({ ... }))
      gesture = [
        { fingers = 3; direction = "horizontal"; action = "move"; }
        { fingers = 3; direction = "vertical"; action = "move"; }
      ];

      # Layer rules (generates: hl.layer_rule({ ... }))
      layer_rule = [
        { match = { namespace = "^(calendar)$"; }; blur = true; ignore_alpha = 0.1; }
        { match = { namespace = "^(control-menu)$"; }; blur = true; ignore_alpha = 0.1; }
        { match = { namespace = "^(pwr-menu)$"; }; blur = true; ignore_alpha = 0.1; }
      ];

      # Window rules (generates: hl.window_rule({ ... }))
      window_rule = [
        {
          match = { class = "org.gnome.Calculator"; };
          float = true;
          size = "400 550";
        }
      ];

      # All key, mouse, and media binds (bind, bindm, bindel, bindl all map to hl.bind)
      bind =
        # Workspace switching ($mod + 1..0) and Move to workspace ($mod + ALT + 1..0)
        (builtins.concatLists (builtins.genList (i:
          let
            ws = i + 1;
            key = if ws == 10 then "0" else toString ws;
          in [
            (mkBind ''mod .. " + ${key}"'' ''
              function()
                hl.dispatch(hl.dsp.focus({ workspace = ${toString ws} }))
                hl.exec_cmd("eww update desktop=${toString ws}")
              end
            '')
            (mkBind ''mod .. " + ALT + ${key}"'' ''
              function()
                hl.dispatch(hl.dsp.window.move({ workspace = ${toString ws} }))
                hl.exec_cmd("eww update desktop=${toString ws}")
              end
            '')
          ]
        ) 10))
        ++ [
          # Focus
          (mkBind ''mod .. " + left"'' ''hl.dsp.focus({ direction = "left" })'')
          (mkBind ''mod .. " + down"'' ''hl.dsp.focus({ direction = "down" })'')
          (mkBind ''mod .. " + up"'' ''hl.dsp.focus({ direction = "up" })'')
          (mkBind ''mod .. " + right"'' ''hl.dsp.focus({ direction = "right" })'')

          # Swap
          (mkBind ''mod .. " + ALT + left"'' ''hl.dsp.window.swap({ direction = "left" })'')
          (mkBind ''mod .. " + ALT + right"'' ''hl.dsp.window.swap({ direction = "right" })'')

          # Layout
          (mkBind ''mod .. " + SHIFT + F"'' ''hl.dsp.window.float({ action = "toggle" })'')
          (mkBind ''mod .. " + F"'' ''hl.dsp.window.fullscreen()'')

          # Apps
          (mkBind ''mod .. " + Return"'' ''hl.dsp.exec_cmd(term)'')
          (mkBind ''mod .. " + M"'' ''hl.dsp.exec_cmd("element-desktop")'')
          (mkBind ''mod .. " + R"'' ''hl.dsp.exec_cmd("hyprctl reload")'')
          (mkBind ''mod .. " + T"'' ''hl.dsp.exec_cmd(term)'')
          (mkBind ''mod .. " + V"'' ''hl.dsp.exec_cmd("vesktop")'')
          (mkBind ''mod .. " + W"'' ''hl.dsp.exec_cmd("firefox")'')

          # Wofi launcher
          (mkBind ''mod .. " + space"'' ''hl.dsp.exec_cmd("wofi --show drun")'')

          # Close window
          (mkBind ''mod .. " + Q"'' ''hl.dsp.window.close()'')
          (mkBind ''mod .. " + SHIFT + Q"'' ''hl.dsp.window.kill()'')

          # Session & Eww
          (mkBind ''mod .. " + L"'' ''hl.dsp.exec_cmd("pkill hyprland")'')
          (mkBind ''mod .. " + SHIFT + F23"'' ''hl.dsp.exec_cmd("eww open --toggle activate-linux")'')

          # Screenshots & Calculator
          (mkBind ''"XF86Launch7"'' ''hl.dsp.exec_cmd("${pkgs.grimblast}/bin/grimblast copy area")'')
          (mkBind ''mod .. " + SHIFT + S"'' ''hl.dsp.exec_cmd("${pkgs.grimblast}/bin/grimblast copy area")'')
          (mkBind ''mod .. " + P"'' ''hl.dsp.exec_cmd("${pkgs.grimblast}/bin/grimblast copy screen")'')
          (mkBind ''"XF86Calculator"'' ''hl.dsp.exec_cmd("${pkgs.gnome-calculator}/bin/gnome-calculator")'')

          # Mouse binds (replaces bindm via { mouse = true })
          (mkBindFlags ''mod .. " + mouse:272"'' ''hl.dsp.window.drag()'' { mouse = true; })
          (mkBindFlags ''mod .. " + mouse:273"'' ''hl.dsp.window.resize()'' { mouse = true; })

          # Repeating + Locked media binds (replaces bindel via { repeating = true, locked = true })
          (mkBindFlags ''"XF86MonBrightnessUp"'' ''hl.dsp.exec_cmd([[brightnessctl set 5%+ && eww update brightness=$(brightnessctl -m | cut -d, -f4 | tr -d %)]])'' { repeating = true; locked = true; })
          (mkBindFlags ''"XF86MonBrightnessDown"'' ''hl.dsp.exec_cmd([[brightnessctl set 5%- && eww update brightness=$(brightnessctl -m | cut -d, -f4 | tr -d %)]])'' { repeating = true; locked = true; })
          (mkBindFlags ''"XF86AudioRaiseVolume"'' ''hl.dsp.exec_cmd([[wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ && eww update volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print (/MUTED/ ? -1 : int($2 * 100))}')]])'' { repeating = true; locked = true; })
          (mkBindFlags ''"XF86AudioLowerVolume"'' ''hl.dsp.exec_cmd([[wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && eww update volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print (/MUTED/ ? -1 : int($2 * 100))}')]])'' { repeating = true; locked = true; })
          (mkBindFlags ''"XF86PowerOff"'' ''hl.dsp.exec_cmd([[if eww active-windows | grep -q 'pwr-menu'; then eww close pwr-menu closer || true; else eww close calendar control-menu || true; eww open closer; eww open pwr-menu; fi]])'' { repeating = true; locked = true; })

          # Locked media binds (replaces bindl via { locked = true })
          (mkBindFlags ''"XF86AudioMute"'' ''hl.dsp.exec_cmd([[wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && eww update volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print (/MUTED/ ? -1 : int($2 * 100))}')]])'' { locked = true; })
          (mkBindFlags ''"XF86AudioMicMute"'' ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")'' { locked = true; })
        ];
    };
  };
}
