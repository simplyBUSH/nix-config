{
  programs.vesktop = {
    enable = true;

    settings = {
      appBadge = false;
      arRPC = true;
      checkUpdates = false;
      minimizeToTray = false;
      hardwareAcceleration = false;
      discordBranch = "stable";
    };

    vencord.settings = {
      plugins = {
        FakeNitro = {
          enabled = true;
        };
        MessageLogger = {
          enabled = true;
          ignoreSelf = true;
        };
      };
    };
  };
}
