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
            text = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
            };
            source = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
            };
            outputPath = lib.mkOption { };
            reloadCmd = lib.mkOption {
              default = "";

            };
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
        post_command = bash -c "${pkgs.matugen}/bin/matugen image \"$wallpaper\" --source-color-index 0 --type scheme-vibrant";
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
        prefer = "saturation"
        fallback_color = "#ffbf9b"
        source_color_index = 2

        ${lib.concatStringsSep "\n\n" (
          lib.mapAttrsToList (name: value: ''
            [templates.${name}]
            input_path = "${
              if value.source != null then
                value.source
              else if value.text != null then
                pkgs.writeText "matugen-${name}" value.text
              else
                throw "Error"
            }"
            output_path = "${value.outputPath}"

            ${lib.optionalString (value.reloadCmd != "") "post_hook = \"${value.reloadCmd}\""}
          '') cfg.templates
        )}
      '';
    }
    // lib.genAttrs' [ "5" "6" ] (
      name:
      lib.nameValuePair "qt${name}ct/qt${name}ct.conf" {
        text = ''
          color_scheme_path=${config.home.homeDirectory}/.local/share/color-schemes/matugen.colors
          custom_palette=true
          icon_theme=breeze
          style=Breeze
        '';
      }
    );

    modules.matugen.templates."qt" = {
      outputPath = "~/.local/share/color-schemes/matugen.colors";
      source = ./qt.colors.ini;
    };
  };
}
