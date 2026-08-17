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
      background_opacity = "1.0";
      background_blur = "32";
    };
  };
}
