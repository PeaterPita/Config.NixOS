{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.modules.firefox;
in
{
  options = {
    modules.firefox.enable = lib.mkEnableOption "firefox";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      policies = {
        # Features
        DontCheckDefaultBrowser = true;
        HardwareAcceleration = true;
        GenerativeAI.enabled = false;

        # Privacy
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableFirefoxStudies = true;
        DisableFirefoxScreenshots = true;
        DisableSetDesktopBackground = true;
        DisableTelemetry = true;

        ExtensionSettings =
          let
            moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpl";
          in
          {
            "*".installation_mode = "blocked";

            "uBlock0@raymondhill.net" = {
              install_url = moz "ublock-origin";
              installation_mode = "force_installed";
              updates_disabled = true;
            };
          };

        profiles.default = {
          settings = {
            "privacy.trackingprotection.enabled" = true;
            "browser.startup.homepage" = "https://nixos.org";

          };

          search = {
            force = true;
            default = "DuckDuckGo";
            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "channel";
                        value = "25.05";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                    definedAliases = [ "@np" ];
                  }
                ];
              };
            };
          };
        };
      };
    };
  };
}
