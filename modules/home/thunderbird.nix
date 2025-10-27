{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.thunderbird;
in
{
  options = {
    modules.thunderbird.enable = lib.mkEnableOption "thunderbird";
  };

  config = lib.mkIf cfg.enable {
    programs.thunderbird.enable = true;
    programs.thunderbird.profiles = {

    };

  };
}
