{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.matugen;
in
{
  options.modules.matugen = {
    enable = lib.mkEnableOption "matugen ++ waypaper ++ awww";

    ################################################################
    #            A lot of templates were borrowed from:            #
    # https://github.com/InioX/matugen-themes/blob/main/templates/ #
    ################################################################
    templates = lib.mkOption {
      description = "Matugen Templates";
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            text = lib.mkOption { };
            source = lib.mkOption { };
            outputPath = lib.mkOption { };
            reloadCmd = lib.mkOption { };
          };
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      matugen
      waypaper
    ];

    services.awww.enable = true;

    xdg.configFile = {
      "waypaper/config.ini".text = ''
        [Settings]
        language = en
        backend = awww
        folder = ~/Pictures/wallpapers/
        monitors = All
        show_path_in_tooltip = True
        fill = fill
        sort = name
        color = #ffffff
        subfolders = False
        all_subfolders = False
        show_hidden = False
        show_gifs_only = False
        zen_mode = True
        post_command = matugen image $wallpaper
        number_of_columns = 3
        swww_transition_type = any
        swww_transition_step = 63
        swww_transition_angle = 0
        swww_transition_duration = 2
        swww_transition_fps = 60
        use_xdg_state = True
      '';

      "matugen/config.toml".text = ''

        [config]

        ${lib.concatStringsSep "\n\n" (
          lib.mapAttrsToList (name: value: ''
            [templates.${name}]
            input_path = "${pkgs.writeText "matugen-${name}" value.text}"
            output_path = "${value.outputPath}"

            ${lib.optionalString (value.reloadCmd != null) "post_hook = \"${value.reloadCmd}\""}
          '') cfg.templates
        )}
      '';
    };
  };
}
