{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.discord;
in
{
  options = {
    modules.discord.enable = lib.mkEnableOption "discord";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.unstable.discord
      (pkgs.element-desktop.override {
        commandLineArgs = [ "--password-store=basic" ];
      })
    ];

  };
}
