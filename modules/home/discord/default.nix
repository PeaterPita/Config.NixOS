{
  config,
  pkgs,
  lib,
  ...
}:

# Through my own investigation and the following post:
# https://www.reddit.com/r/discordapp/comments/1xi1ucl/linux_fixed_discord_h264_video_corrupted_from_mac/
# I have come to find discord client is broken.
# The asset manager downloads Cisco's openh264 2.7.0
# However, the client hard codes needing openh264 2.5.1
# The asset manager also REMOVES 2.5.1
# The following installs 2.5.1 and manages the whole openh264 directory itself.
let
  cfg = config.modules.discord;

  openh264-2-5-1 = pkgs.runCommand "libopenh264-2.5.1-linux64.7.so" {
    src = pkgs.fetchurl {
      url = "http://ciscobinary.openh264.org/libopenh264-2.5.1-linux64.7.so.bz2";
      hash = "sha256-guQ224YGQz4/gjx//zJpxDs7o/ElEKhR73sVa4CtGxE=";
    };

    nativeBuildInputs = [ pkgs.bzip2 ];
  } "bunzip2 -c $src > $out";

  openh264Dir = pkgs.linkFarm "discord-h264" [
    {
      name = "libopenh264-2.5.1-linux64.7.so";
      path = openh264-2-5-1;
    }

  ];

in
{
  options = {
    modules.discord.enable = lib.mkEnableOption "discord";
  };

  config = lib.mkIf cfg.enable {

    home.file.".config/discord/discord_asset_cache/openh264".source = openh264Dir;

    home.packages = with pkgs; [
      pkgs.unstable.discord
      (pkgs.element-desktop.override {
        commandLineArgs = [ "--password-store=basic" ];
      })
    ];

  };
}
