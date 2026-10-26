{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    rquickshare
  ];

  home.file.".local/share/dev.mandre.rquickshare/.settings.json" = {
    text = builtins.toJSON {
      port = 54321;
    };
  };
}
