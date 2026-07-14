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

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      lib.optionals cfg.prism.enable [
        prismlauncher
        openjdk25
        cubiomes-viewer
      ]
      ++ lib.optional cfg.xenia.enable xenia-canary
      ++ lib.optional cfg.pcsx2.enable pcsx2
      ++ lib.optional cfg.ds.enable azahar
      ++ lib.optional cfg.vintagestory.enable vintagestory
      ++ lib.optional cfg.moonlight.enable moonlight-qt;

  };
}
