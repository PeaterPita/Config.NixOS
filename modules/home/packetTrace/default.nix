{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.packetTrace;
in
{
  options = {
    modules.packetTrace.enable = lib.mkEnableOption "packetTrace";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ciscoPacketTracer8
    ];
    nixpkgs.config.permittedInsecurePackages = [
      "ciscoPacketTracer8-8.2.2"
    ];
  };
}
