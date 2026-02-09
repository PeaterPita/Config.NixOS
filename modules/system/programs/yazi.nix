{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.yazi;
in
{
  options = {
    modules.yazi.enable = lib.mkEnableOption "yazi";
  };

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      settings.yazi = {
        mgr = {
          show_hidden = true;
          show_symlink = true;
          scrolloff = 10;
          sort_dir_first = true;
          sort_by = "natural";
        };

        preview = {
          max_width = 600;
          image_filter = "laczos3";
          image_quality = 90;

        };

        opener = {
          edit = [
            {
              run = ''$EDITOR "$@"'';
              block = true;
              desc = "Edit";
            }
          ];
          play = [
            {
              run = ''mpv "$@"'';
              orphan = true;
              for = "unix";
              desc = "Play";
            }
          ];
          open = [
            {
              run = ''xdg-open "$@"'';
              desc = "Open";
            }
          ];
        };

      };

    };

  };
}
