{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.sound;
in
{
  options = {
    modules.sound.enable = lib.mkEnableOption "sound";
  };

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;
    environment.systemPackages = with pkgs; [
      playerctl
    ];

    nixpkgs.config.pipewire = {
      withLibBluetooth = true;
    };
    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      extraConfig.pipewire-pulse."context.properties" = {
        "bluez5.codecs" = [
          "ldac"
          "aac"
          "aptx"
          "aptx_hd"
          "sbc"
        ];
        "bluez5.default.rate" = 96000;
        "bluez5.default.channels" = 2;
        "bluez5.ad2dp.ldac.quality" = "hq";
      };
    };
  };
}
