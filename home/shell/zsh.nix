{ pkgs, lib, accent, ... }:
{
  programs.zsh = {
    enable = true;
    
    enableCompletion = true; 
    
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    localVariables = {
      PROMPT = "[%n@%F{${accent}}%m%f %~] %% ";
    };

    history = {
      size = 100000;
      save = 100000;
      ignoreDups = true;
      share = true;
    };

    shellAliases = {
      cls = "pyroclear";
      clear = "pyroclear";
      gc="sudo nix-collect-garbage -d && sudo nix store optimise";
      iamb = "iamb -C ~/.config"; 
      kys = "tmux kill-server";
      ll = "eza -lha --git"; 
      ns = "nix shell";
      q = "exit";
      ts = "tailscale";
      caffeinate = "systemd-inhibit --what=idle sleep infinity";
    };
    
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PATH = "$HOME/.cargo/bin:$PATH";
    };

    initContent = '' eval "$(${pkgs.direnv}/bin/direnv hook zsh)" '';
  };
}
