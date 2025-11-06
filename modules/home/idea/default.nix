{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.idea;
in
{
  options = {
    modules.idea.enable = lib.mkEnableOption "idea";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ jetbrains.idea-ultimate ];

  };
}
