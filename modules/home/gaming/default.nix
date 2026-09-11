{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.gaming;
in
{
  options.modules.gaming = {
    enable = lib.mkEnableOption "Enable gaming settings";
    prism.enable = lib.mkEnableOption "Prism Launcher for minecraft";
    xenia.enable = lib.mkEnableOption "Xenia | Xbox360 emulator";
    ds.enable = lib.mkEnableOption "Azahar | Nintendo 3DS emulator";
    pcsx2.enable = lib.mkEnableOption "pcsx2 | PS2 emulator";
    vintagestory.enable = lib.mkEnableOption "vintagestory";
    moonlight.enable = lib.mkEnableOption "Moonlight Streaming";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {

        home.packages =
          with pkgs;
          lib.optional cfg.vintagestory.enable unstable.vintagestory
          ++ lib.optional cfg.xenia.enable xenia-canary
          ++ lib.optional cfg.pcsx2.enable pcsx2
          ++ lib.optional cfg.ds.enable azahar
          ++ lib.optional cfg.moonlight.enable moonlight-qt;

      }

      (lib.mkIf cfg.prism.enable {

        home.packages = with pkgs; [
          prismlauncher
          cubiomes-viewer
          openjdk25
        ];

        modules.matugen.templates."prism" = {
          outputPath = "~/.local/share/PrismLauncher/themes/Matugen/theme.json";
          text = ''
            {
              "colors": {
                "AlternateBase": "{{colors.surface.default.hex}}",
                "Base": "{{colors.surface.default.hex}}",
                "BrightText": "{{colors.secondary.default.hex}}",
                "Button": "{{colors.surface_variant.default.hex}}",
                "ButtonText": "{{colors.on_surface.default.hex}}",
                "Highlight": "{{colors.primary.default.hex}}",
                "HighlightedText": "{{colors.on_primary.default.hex}}",
                "Link": "{{colors.primary.default.hex}}",
                "Text": "{{colors.on_surface.default.hex}}",
                "ToolTipBase": "{{colors.surface_variant.default.hex}}",
                "ToolTipText": "{{colors.on_surface.default.hex}}",
                "Window": "{{colors.surface.default.hex}}",
                "WindowText": "{{colors.on_surface.default.hex}}",
                "fadeAmount": 0.5,
                "fadeColor": "{{colors.surface_variant.default.hex}}"
              },
              "name": "Matugen",
              "widgets": "Fusion"
            }
          '';
        };
      })
    ]
  );
}
