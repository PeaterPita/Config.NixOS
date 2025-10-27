{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.bluetooth;
in
{
  options = {
    modules.bluetooth.enable = lib.mkEnableOption "bluetooth";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          ControllerMode = "dual";
        };
      };
    };

    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [ helvum ];
  };

}
