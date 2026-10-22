{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;

    # "y" opens a shell wrapper that cds into yazi's cwd when you quit.
    # Very handy — type `y` instead of `yazi` and your shell follows you.
    shellWrapperName = "y";

    extraPackages = with pkgs; [
      ffmpegthumbnailer
      unar
      poppler-utils
      imagemagick
      zoxide
    ];

    settings = {
      manager = {
        ratio         = [ 1 3 6 ];
        sort_by       = "natural";
        sort_dir_first = true;
        show_hidden   = true;
        show_symlink  = true;
      };

      preview = {
        image_filter  = "lanczos3";
        image_quality = 85;
        max_width     = 800;
        max_height    = 1200;
      };

      opener = {
        edit = [
          { run = ''nvim "$@"''; block = true; desc = "nvim"; }
        ];
        open = [
          { run = ''xdg-open "$@"''; desc = "open"; }
        ];
        play = [
          { run = ''mpv "$@"''; orphan = true; desc = "mpv"; }
        ];
        extract = [
          { run = ''unar "$1"''; desc = "extract here"; }
        ];
      };

      open = {
        prepend_rules = [
          { mime = "text/*";             use = [ "edit" "open" ]; }
          { mime = "application/json";   use = [ "edit" "open" ]; }
          { mime = "video/*";            use = [ "play" "open" ]; }
          { mime = "audio/*";            use = [ "play" "open" ]; }
          { mime = "application/zip";    use = [ "extract" "open" ]; }
          { mime = "application/x-tar";  use = [ "extract" "open" ]; }
          { mime = "application/x-bzip2"; use = [ "extract" "open" ]; }
          { mime = "application/x-xz";   use = [ "extract" "open" ]; }
          { mime = "application/x-zstd"; use = [ "extract" "open" ]; }
          { mime = "*";                  use = [ "open" ]; }
        ];
      };
    };

    keymap = {
      mgr.prepend_keymap = [

        { on = [ "!" ]; run = ''shell "$SHELL" --block''; desc = "Open shell here"; }


        # ── rename without leaving the keyboard ──────────────────────────
        { on = [ "r" ]; run = "rename --cursor=before_ext"; desc = "Rename (cursor before ext)"; }

        # ── copy operations (vim-style yank) ─────────────────────────────
        { on = [ "y" ]; run = "yank";              desc = "Yank (copy)"; }
        { on = [ "Y" ]; run = "unyank";            desc = "Cancel yank"; }
        { on = [ "x" ]; run = "yank --cut";        desc = "Cut"; }

        # ── delete ───────────────────────────────────────────────────────
        # 'd' → trash (recoverable), 'D' → permanent
        { on = [ "d" ]; run = "remove";            desc = "Trash"; }
        { on = [ "D" ]; run = "remove --permanently"; desc = "Delete permanently"; }

        # ── help ─────────────────────────────────────────────────────────
        { on = [ "?" ]; run = "help"; desc = "Help"; }
      ];
    };
  };
}
