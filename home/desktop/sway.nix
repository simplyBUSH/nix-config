{ pkgs, accent, ... }:

let
  mod = "Mod4";
  alt = "Mod1";
  term = "alacritty";
in
{
  wayland.windowManager.sway = {
    enable = true;

    config = {
      modifier = mod;
      terminal = term;

      # Disable default Sway bar
      # bars = [];

      # Wallpaper
      output = {
        "*" = {
          bg = "${../../resources/pictures/wallpaper.png} fill";
        };
      };

      # Keyboard and mouse
      input = {
        "type:keyboard" = {
          xkb_layout = "pl";
          repeat_rate = "50";
          repeat_delay = "300";
        };

        "type:pointer" = {
          pointer_accel = "-0.5";
        };
      };

      focus.followMouse = true;

      # Window appearance
      window = {
        border = 3;
        titlebar = false;
      };

      gaps = {
        inner = 4;
        outer = 4;
      };

      colors = {
        focused = {
          border = accent;
          background = accent;
          text = "#ffffff";
          indicator = accent;
          childBorder = accent;
        };

        unfocused = {
          border = "#444444";
          background = "#444444";
          text = "#ffffff";
          indicator = "#444444";
          childBorder = "#444444";
        };
      };

      # Mouse window movement and resizing
      floating.modifier = mod;

      # Keybindings
      keybindings =
        let
          workspaceBindings = builtins.listToAttrs (
            map (n: {
              name = "${mod}+${toString (if n == 10 then 0 else n)}";
              value = "workspace number ${toString n}";
            }) (builtins.genList (i: i + 1) 10)
          );

          moveBindings = builtins.listToAttrs (
            map (n: {
              name = "${mod}+${alt}+${toString (if n == 10 then 0 else n)}";
              value = "move container to workspace number ${toString n}";
            }) (builtins.genList (i: i + 1) 10)
          );
        in
        workspaceBindings // moveBindings // {
          # Focus
          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";

          # Move windows
          "${mod}+${alt}+Left" = "move left";
          "${mod}+${alt}+Right" = "move right";

          # Layout
          "${mod}+${alt}+space" = "floating toggle";
          "${mod}+${alt}+f" = "fullscreen toggle";

          # Apps
          "${mod}+e" = "exec nautilus";
          "${mod}+Return" = "exec ${term}";
          "${mod}+m" = "exec element-desktop";
          "${mod}+r" = "reload";
          "${mod}+s" = "exec env XDG_CURRENT_DESKTOP=GNOME gnome-control-center";
          "${mod}+t" = "exec ${term}";
          "${mod}+v" = "exec vesktop";
          "${mod}+w" = "exec firefox";

          # Launcher
          "${mod}+space" = "exec wofi --show drun";

          # Close window
          "${mod}+q" = "kill";
        };
    };

    extraConfig = ''
      default_border pixel 3
      default_floating_border pixel 3
    '';
  };

  # Required utilities
  home.packages = with pkgs; [
    swaybg
    wofi
  ];
}
