{ pkgs, accent, ... }:

{
  programs.hyprlock = {
    enable = true;

    settings = {

      animations = {
        enabled = true;
        fade_in = {
          duration = 300;
          bezier = "easeOutQuint";
        };
        fade_out = {
          duration = 300;
          bezier = "easeOutQuint";
        };
      };

      image = [
        {
          path = "${../../resources/pictures/FurryID_crop.png}"; 
          roounding = "-1";
          position = "0, 80";
          monitor = "";
          border_color = "rgb(${builtins.substring 1 6 accent})";
          outer_color = "rgb(${builtins.substring 1 6 accent})";
          outline_thickness = 0;
          shadow_passes = 0;
        }
      ];

      background = [
        {
          path = "${../../resources/pictures/leashed.jpg}";
          blur_passes = 3;
          blur_size = 4;
        }
      ];

      input-field = [
        {
          size = "300, 50";
          rounding = "15";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(${builtins.substring 1 6 accent})";
          outline_thickness = 2;
          shadow_passes = 1;
        }
      ];
    };
  };
}
