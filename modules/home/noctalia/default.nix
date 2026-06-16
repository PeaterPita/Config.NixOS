{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:

let
  cfg = config.modules.noctalia;
in
{
  options = {
    modules.noctalia.enable = lib.mkEnableOption "noctalia";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      monocraft
    ];

    programs.noctalia = {
      enable = true;
      settings = {
        bar.default.monitor = builtins.listToAttrs (
          map (monitor: {
            name = monitor.name;
            value = {
              match = monitor.name;
              enabled = false;
            };
          }) (builtins.filter (monitor: !monitor.primary) osConfig.monitors)
        );

        widget = {
          workspaces.display = "name";
          taskbar = {
            group_by_workspace = true;
            workspace_label_placement = "inside";
            show_active_indicator = false;
          };
        };

        control_center = {
          shortcuts = [
            { type = "notification"; }
            { type = "wallpaper"; }
          ];
        };

        theme = {
          mode = "dark";
          source = "wallpaper";
          wallpaper_scheme = "rainbow";

          templates = {
            enable_builtin_templates = true;
            builtin_ids = [
              "hyprland"
              "gtk4"
              "gtk3"
              "kitty"
              "kcolorscheme"
            ];

            enable_community_templates = true;
            community_ids = [
              "vesktop"
              "discord"
              "neovim"
            ];
          };
        };

        wallpaper = {
          default.path = ../../../assets/wallpapers/default.png;
          directory = ../../../assets/wallpapers;
        };

        shell = {
          font_family = "monocraft";
          launch_apps_as_systemd_services = true;

          screenshot = {
            copy_to_clipboard = true;
          };

          panel = {
            transparency_mode = "glass";
            launcher_placement = "centered";
            launcher_categories = false;
          };
        };

        audio = {
          enable_overdrive = true;
          enable_sounds = true;
        };

        calendar.enabled = false;
        weather.enabled = false;

      };
    };
  };
}
