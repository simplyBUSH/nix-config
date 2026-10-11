{ pkgs, ... }:

{
  programs.git = {
    
    enable = true;
    
    settings = {
      user = {
        name = "Piotr Malowiecki";       
        email = "malowiecki.piotr@gmail.com";     
      };

    alias = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      lg = "log --oneline --graph --decorate --all";
    };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";

    };
  };
}
