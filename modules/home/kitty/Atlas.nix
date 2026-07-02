{
  config,
  lib,
  ...
}:

let
  kittyEnabled = config.modules.kitty.enable;
in
{
  config = lib.mkIf kittyEnabled {

    programs.kitty.settings = {
      background_opacity = "0.8";
      background_blur = "32";
    };
  };
}
