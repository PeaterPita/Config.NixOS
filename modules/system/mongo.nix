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

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "DB_A1" ];
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
      '';
      ensureUsers = [
        {
          name = "DB_A1";
          ensureDBOwnership = true;
        }
      ];
    };

    environment.systemPackages = with pkgs; [
      mongodb-ce
      mongodb-compass
    ];
  };

}
