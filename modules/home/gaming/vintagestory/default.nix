{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.gaming.vintagestory;
in
{
  options = {
    modules.gaming.vintagestory.enable = lib.mkEnableOption "vintagestory";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (vintagestory.overrideAttrs (old: rec {
        version = "1.21.5";
        src = fetchurl {
          url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${version}.tar.gz";
          hash = "sha256-dG1D2Buqht+bRyxx2ie34Z+U1bdKgi5R3w29BG/a5jg=";
        };
      }))
    ];
  };
}
