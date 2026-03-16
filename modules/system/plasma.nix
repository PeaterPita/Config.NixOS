{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.plasma;
in
{
  options = {
    modules.plasma.enable = lib.mkEnableOption "plasma";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      konsole
      kdeconnect-kde
      elisa
      gwenview
      kate
      okular
    ];
  };
}
