{ inputs, osConfig, ... }:
{
  lsp.servers.nixd =
    let
      flake = "${inputs.self}";
      host = osConfig.networking.hostName;
    in
    {
      enable = true;
      config.settings.nixd = {
        options = {
          nixos.expr = ''(builtins.getFlake "${flake}").nixosConfigurations.${host}.options'';
          home_manager.expr = ''(builtins.getFlake "${flake}").nixosConfigurations.${host}.options.home-manager.users.type.getSubOptions [ ]'';
        };
      };
    };

}
