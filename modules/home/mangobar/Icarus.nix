{
  config,
  lib,
  osConfig,
  ...
}:

{
  config = lib.mkIf config.modules.mangobar.enable {
    services.mangobar = {
      settings = [
        {
          output = osConfig.monitors.primary.name;
          modules-right = lib.mkBefore [
            "battery"
          ];
        }
      ];
    };
  };
}
