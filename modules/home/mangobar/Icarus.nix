{
  config,
  lib,
  osConfig,
  ...
}:

{
  config = lib.mkIf config.modules.manogbar.enable {
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
