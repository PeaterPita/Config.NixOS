{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.git;
in
{
  options = {
    modules.git.enable = lib.mkEnableOption "git";
    userSettings.gitName = lib.mkOption {
    };
    userSettings.gitEmail = lib.mkOption {
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git.enable = true;
    programs.git.settings = {
      user.name = config.userSettings.gitName;
      user.email = config.userSettings.gitEmail;
    };
  };
}
