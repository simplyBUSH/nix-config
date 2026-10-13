{
  programs.hyfetch = {
    enable = true;

    settings = {
      preset = "pansexual";
      mode = "rgb";
      light_dark = "dark";
      backend = "fastfetch";
      pride_month_disable = true;
      lightness = 0.65;
      color_align = {
        mode = "horizontal";
      };
    };
  };
}
