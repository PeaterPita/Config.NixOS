{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.misc;
in
{
  options.modules.misc = {
    ripping.enable = lib.mkEnableOption "Tools for ripping and archiving physcial media";
    videoediting.enable = lib.mkEnableOption "Davinci resolve | kdenlive editors";
    art.enable = lib.mkEnableOption "Inkscape | Aseprite";
  };

  config.home.packages =
    with pkgs;
    lib.optionals cfg.ripping.enable [
      asunder
      picard
      lrcget
      libdvdcss
    ]
    ++ lib.optionals cfg.videoediting.enable [
      pkgs.davinci-resolve
      pkgs.kdePackages.kdenlive
    ]
    ++ lib.optionals cfg.art.enable [
      inkscape
      aseprite
    ];
}
