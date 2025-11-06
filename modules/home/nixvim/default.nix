{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.nixvim;
in
{
  options = {
    modules.nixvim.enable = lib.mkEnableOption "nixvim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      colorschemes.gruvbox.enable = true;
      extraPlugins = with pkgs.vimPlugins; [
        nvim-treesitter

      ];

    };
  };
}
