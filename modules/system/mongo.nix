{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.mongo;
in
{
  options = {
    modules.mongo.enable = lib.mkEnableOption "mongo";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      mongodb-ce
      mongodb-compass
    ];
  };

}
