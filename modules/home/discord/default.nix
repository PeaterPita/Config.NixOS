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
    programs.vesktop.enable = true;

  };

}
