{ config, lib, ... }:

let

  cfg = config.modules.zellij;

in
{
  options = {
    modules.zellij.enable = lib.mkEnableOption "zellij";
  };

  config = lib.mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
    };
  };

}
