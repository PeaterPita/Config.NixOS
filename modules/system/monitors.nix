{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkOption types;

  monitorSubMod = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        example = "DP-1";
      };
      primary = mkOption {
        type = types.bool;
        default = false;
      };
      width = mkOption {
        type = types.int;
        example = 1920;
      };
      height = mkOption {
        type = types.int;
        example = 1080;
      };
      refreshRate = mkOption {
        type = types.int;
        default = 60;
      };
      position = mkOption {
        type = types.str;
        default = "auto";
      };
      scale = mkOption {
        type = types.str;
        default = "1";
      };
      enabled = mkOption {
        type = types.bool;
        default = true;
      };
    };

  };
in
{

  options.monitors = mkOption {
    type = types.submodule {
      options = {
        all = mkOption {
          default = [ ];

          type = types.listOf monitorSubMod;

        };
        primary = mkOption {
          type = types.nullOr monitorSubMod;
          readOnly = true;
        };
      };
    };
  };

  config = {
    monitors.primary = builtins.head (builtins.filter (monitor: monitor.primary) config.monitors.all);

    assertions = [
      {
        assertion =
          ((lib.length config.monitors.all) != 0)
          -> ((lib.length (lib.filter (m: m.primary) config.monitors.all)) == 1);
        message = "Exactly one monitor must be set to primary";
      }
    ];
  };
}
