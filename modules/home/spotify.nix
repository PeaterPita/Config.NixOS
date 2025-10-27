{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.spotify;
in
{
  options = {
    modules.spotify.enable = lib.mkEnableOption "spotify";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ spotify ];

  };
}
