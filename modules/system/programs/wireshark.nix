{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.wireshark;
in
{
  options = {
    modules.wireshark.enable = lib.mkEnableOption "wireshark";
  };

  config = lib.mkIf cfg.enable {
    programs.wireshark = {
      enable = true;
      dumpcap.enable = true;
      usbmon.enable = true;
      package = pkgs.wireshark-qt;
    };
  };
}
