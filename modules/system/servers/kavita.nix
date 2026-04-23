{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.services.kavita;
  vars = config.homelab;
in

{
  options.homelab.services.kavita = {
    enable = lib.mkEnableOption "Enable the kavita reading platform";
    port = lib.mkOption { default = 5000; };
  };

  config = lib.mkIf cfg.enable {

    sops.secrets."kavita/token_key" = {
      sopsFile = ../../../secrets/services.yaml;
      owner = "kavita";
      group = "kavita";
      mode = "0400";
    };

    homelab.services.homepage.disks = [ "/mnt/media/books" ];

    systemd.tmpfiles.rules = [
      "d /mnt/media/books 2775 root media - - "
    ];

    users.users.kavita.extraGroups = [ "media" ];
    homelab.services.homepage.groups."Media" = [
      {
        Kavita = {
          icon = "kavita.png";
          href = "http://books.${vars.baseDomain}";
          description = "Book Reading";
          ping = "http://127.0.0.1:${builtins.toString cfg.port}";
        };
      }
    ];

    homelab.services.authelia.rules = [
      {
        domain = [
          "books.${vars.baseDomain}"
        ];
        policy = "one_factor";
        subject = [
          "group:family"
          "group:admin"
        ];
      }
    ];
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    services.kavita = {
      enable = true;
      tokenKeyFile = config.sops.secrets."kavita/token_key".path;
      settings = {
        Port = cfg.port;
      };
    };
  };

}
