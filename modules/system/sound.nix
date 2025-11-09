{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.sound;
  blueToothEnabled = config.modules.bluetooth.enable;
in
{
  options = {
    modules.sound.enable = lib.mkEnableOption "sound";
  };

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;
    environment.systemPackages = with pkgs; [
      playerctl
      pavucontrol
    ];

    nixpkgs.config.pipewire.withLibBluetooth = lib.mkIf blueToothEnabled true;

    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      extraConfig.pipewire-pulse."context.properties" = lib.mkIf blueToothEnabled {
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
