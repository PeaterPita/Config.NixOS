{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.office;
in
{
  options = {
    modules.office.enable = lib.mkEnableOption "office";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      libreoffice-fresh
      hunspell
      hunspellDicts.en_GB-ise
      hyphenDicts.en_US
      zotero
      openjdk21
    ];

  };
}
