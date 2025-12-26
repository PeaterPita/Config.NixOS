{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.qute;
in
{
  options = {
    modules.qute.enable = lib.mkEnableOption "qute";
  };

  config = lib.mkIf cfg.enable {
    programs.qutebrowser = {
      enable = true;

      settings = {
        confirm_quit = [ "always" ];
        content.blocking.enabled = true;
      };

      searchEngines = {
        w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
        aw = "https://wiki.archlinux.org/?search={}";
        nw = "https://wiki.nixos.org/index.php?search={}";
        g = "https://www.google.com/search?hl=en&q={}";
      };
    };
  };
}
