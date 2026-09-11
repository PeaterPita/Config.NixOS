{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.foot;
in
{
  options = {
    modules.foot.enable = lib.mkEnableOption "foot";
  };

  config = lib.mkIf cfg.enable {
    modules.starship.enable = true;

    modules.matugen.templates."foot" = {
      outputPath = "~/.config/foot/themes/matugen";
      reloadCmd = "pkill -SIGUSR1 foot";
      text = ''
        [colors-dark]
        cursor={{colors.on_surface_variant.default.hex_stripped}} {{colors.on_surface.default.hex_stripped}}

        foreground={{colors.on_surface.default.hex_stripped}}
        background={{colors.surface.default.hex_stripped}}
        selection-foreground={{colors.on_secondary.default.hex_stripped}}
        selection-background={{colors.secondary_fixed_dim.default.hex_stripped}}
        urls={{colors.primary.default.hex_stripped}}

        regular0=4c4c4c  
        regular1=ac8a8c  
        regular2=8aac8b  
        regular3=aca98a  
        regular4={{colors.primary.default.hex_stripped}}
        regular5=ac8aac  
        regular6=8aacab  
        regular7=f0f0f0  

        bright0=262626   
        bright1=c49ea0   
        bright2=9ec49f   
        bright3=c4c19e   
        bright4=a39ec4   
        bright5=c49ec4   
        bright6=9ec3c4   
        bright7=e7e7e7   
      '';
    };

    home.packages = [ pkgs.monocraft ];

    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "monocraft:size=12";
          include = "${config.xdg.configHome}/foot/themes/matugen";
        };
        scrollback.lines = 99999;
        mouse.hide-when-typing = "yes";
      };
    };

    #   shellIntegration.enableZshIntegration = true;
    #   extraConfig = "include themes/noctalia.conf";
    #   keybindings = {
    #     "ctrl+c" = "copy_or_interrupt";
    #
    #   };
    #   settings = {
    #     copy_on_select = "clipboard";
    #     strip_trailing_spaces = "smart";
    #
    #     confirm_os_window_close = "0";
    #   };
    # };
  };
}
