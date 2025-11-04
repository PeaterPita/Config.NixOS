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
      ensureDatabases = [ "db_a1" ];
      enableTCPIP = true;
      ensureUsers = [
        {
          name = "db_a1";
          ensureDBOwnership = true;
        }
      ];
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all 127.0.0.1/32 trust
      '';
    };

    environment.systemPackages = with pkgs; [
      mongodb-ce
      pgweb
      mongodb-compass
    ];
  };

}
