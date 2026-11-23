{ pkgs, accent, ... }:

{
  programs.wofi = {
    enable = true;

    settings = {
      show = "drun";
      width = 500;
      height = 400;
      layer = "overlay";
      allow_images = true;
      image_size = 20;
      hide_scroll = true;
      no_actions = true;
      always_parse_args = true;
      show_all = true;
      print_command = true;
      insensitive = true;
      prompt = "Search...";
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 14px;
      }

      window {
        margin: 0px;
        border: none;
        border-radius: 16px;
        background-color: rgba(30, 30, 30, 0.8);
        color: #ffffff;
      }

      #outer-box {
        margin: 0px;
        padding: 14px;
        border: none;
        background-color: transparent;
      }

      #input {
        margin: 0px 0px 10px 0px;
        padding: 8px 16px;
        border: none;
        border-radius: 999px;
        background-color: rgba(255, 255, 255, 0.08);
        color: #ffffff;
        box-shadow: none;
        outline: none;
        transition: background-color 150ms ease-in-out;
      }

      #input:focus {
        background-color: rgba(255, 255, 255, 0.12);
        box-shadow: none;
        outline: none;
      }

      #input image {
        color: ${accent};
        margin-right: 8px;
      }

      #scroll {
        margin: 0px;
        padding: 0px;
        border: none;
        background-color: transparent;
      }

      #inner-box {
        margin: 0px;
        padding: 0px;
        border: none;
        background-color: transparent;
      }

      #entry {
        margin: 2px 0px;
        padding: 8px 12px;
        border: none;
        border-radius: 10px;
        background-color: transparent;
        color: #ffffff;
        outline: none;
        transition: background-color 150ms ease-in-out, color 150ms ease-in-out;
      }

      #entry:selected {
        background-color: ${accent};
        color: #000000;
        outline: none;
      }

      #img {
        margin-right: 10px;
        background-color: transparent;
      }

      #text {
        color: inherit;
        font-weight: 500;
        background-color: transparent;
      }

      #text:selected {
        color: #000000;
      }
    '';
  };
}
