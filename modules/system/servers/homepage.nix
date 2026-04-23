{
  config,
  lib,
  ...
}:

# #########################################################################################################
# #https://www.reddit.com/r/selfhosted/comments/1ers52q/homepage_is_amazing_finally_a_command_center_for/ #
# #########################################################################################################
let
  cfg = config.homelab.services.homepage;
  vars = config.homelab;

  mkGlance = host: metric: {
    widget = {
      type = "glances";
      inherit metric;
      url = "http://${host}:${toString vars.services.glances.port}";
      version = 4;
    };
  };

in

{
  options.homelab.services.homepage = {
    enable = lib.mkEnableOption "Enable the Homepage dashboard";
    port = lib.mkOption { default = 8082; };

    groups = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.attrs);
      default = { };
    };

    disks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = [ cfg.port ];

    homelab.services.authelia.rules = [
      {
        domain = [
          "home.${vars.baseDomain}"
        ];
        policy = "one_factor";
        subject = [
          "group:admin"
          "group:family"
        ];
      }
    ];
    services.homepage-dashboard = {
      enable = true;

      allowedHosts = lib.concatStringsSep "," [
        "home.${vars.baseDomain}"
        "home.${vars.baseDomain}:${toString cfg.port}"
        vars.baseDomain
        "${vars.baseDomain}:${toString cfg.port}"
        "127.0.0.1:${toString cfg.port}"
        vars.ingressIP
        "${vars.ingressIP}:${toString cfg.port}"
      ];

      customCSS = ''
        .information-widget-resource div[style*="width"] {
            background: linear-gradient(90deg, #4ade80 0%, #2dd4bf 40%, #3b82f6 75%, #b80fde 100%) !important;
            opacity: 0.40 !important;
            border-radius: 10px !important;
        }
         
        .information-widget-resource:nth-of-type(1) svg { color: #4ade80 !important; } 
        .information-widget-resource:nth-of-type(2) svg { color: #22d3ee !important; }
        .information-widget-resource:nth-of-type(3) svg { color: #ef4444 !important; }
        .information-widget-resource:nth-of-type(4) svg { color: #3b82f6 !important; }





        #tabs ul {
            width: fit-content !important;
            margin-left: auto !important;
            margin-right: auto !important;
            display: flex !important;            
            flex-direction: row !important;      
            flex-wrap: wrap !important;
            justify-content: center !important;  
            gap: 4px !important;
            border-radius: 50px !important;
            padding: 4px !important;
            background-color: rgba(58, 58, 58, 0.2);
        }
         
        #tabs ul li {
            width: auto !important;
            flex: 0 0 auto !important;
        }
         
        #tabs ul li button {
            width: auto !important;
            border-radius: 50px !important;
            padding: 6px 20px !important;
            min-height: unset !important;
            color: #ffffff83 !important; 
            background-color: transparent !important;
        }
         
        #tabs ul li button[aria-selected="true"] {
            color: #6aabbf !important;
            background-color: rgba(78, 59, 122, 0.15) !important;
            font-weight: bold !important;
        }
         
        @media (max-width: 768px) {
            #tabs ul li button {
                padding: 5px 10px !important; 
                font-size: 13px !important;   
            }
            #tabs ul {
                max-width: 100% !important;
            }
        }

                         
        /* Desktop and Tablet */
        @media (min-width: 768px) {
            .widget-container,
            .information-widget-logo,
            [class*="information-widget-glances"] {
                background-color: rgba(58, 58, 58, 0.2) !important;
                border-radius: 50px !important;
                border: 1px solid rgba(255, 255, 255, 0.08) !important;
                height: 42px !important;
                display: flex !important;
                align-items: center !important;
                padding: 0 16px !important;
                margin-top: 10px !important;
                box-shadow: none !important;
            }
        }
         
        /* Mobile */
        @media (max-width: 767px) {
            .widget-container,
            .information-widget-logo,
            [class*="information-widget-glances"] {
                background-color: rgba(58, 58, 58, 0.2) !important;
                border-radius: 25px !important;
                border: 1px solid rgba(255, 255, 255, 0.08) !important;
                height: auto !important;
                min-height: 40px !important;
                padding: 8px 12px !important;
                margin: 5px 0 !important;
                width: 100% !important;
            }
         
            .information-widget-inner, 
            [class*="information-widget-glances"] > div {
                flex-wrap: wrap !important;
                justify-content: center !important;
                gap: 8px !important;
            }
        }
         
        /* Global Alignment for Widgets */
        .information-widget-logo img {
            margin: 0 !important;
            max-height: 24px !important;
        }
         
        .information-widget-resource,
        .widget-inner-text,
        .resource-icon {
            display: flex !important;
            align-items: center !important;
            margin: 0 !important;
        }
         
        .information-widget-resource {
            margin-right: 12px !important;
        }

      '';
      settings = {
        title = "PeaterPita Home";
        theme = "dark";
        color = "slate";
        bookmarksStyle = "icons";
        headerStyle = "boxedWidgets";

        layout = [
          {
            "Media" = {
              tab = "Apps";
              style = "row";
              columns = 4;
            };
          }

          {
            "Tools" = {
              tab = "Apps";
              style = "row";
            };
          }

          {
            "Personal" = {
              tab = "Links";
              style = "row";
              iconsOnly = true;
            };
          }

          {
            "???" = {
              tab = "Media";
              header = false;
            };
          }

          {
            "Monitoring" = {
              tab = "System";
              style = "row";
              columns = 4;
              header = false;
            };
          }

          {
            "Infrastructure" = {
              tab = "System";
            };
          }
        ];
      };

      widgets = [
        {
          "glances" = {
            url = "http://${vars.coreIP}:${toString vars.services.glances.port}";
            version = 4;
            cpu = true;
            mem = true;
            cputemp = true;
            uptime = true;
          };
        }

        {
          "glances" = {
            url = "http://${vars.coreIP}:${toString vars.services.glances.port}";
            version = 4;
            cpu = false;
            mem = false;
            disk = [
              "/"
            ]

            ++ cfg.disks;
          };
        }

        {
          "glances" = {
            url = "http://${vars.ingressIP}:${toString vars.services.glances.port}";
            version = 4;
            cpu = true;
            mem = true;
          };
        }
      ];

      services = [
        {
          "Monitoring" = [
            { "CPU" = mkGlance vars.coreIP "cpu"; }
            { "TEMP" = mkGlance vars.coreIP "sensor:Package id 0"; }
            { "RAM" = mkGlance vars.coreIP "memory"; }
            { "Networking" = mkGlance vars.coreIP "network:enp1s0"; }
            { "Hermes" = mkGlance vars.ingressIP "info"; }

          ];
        }
      ]
      ++ lib.mapAttrsToList (name: items: { "${name}" = items; }) cfg.groups;

      bookmarks =

        [
          {
            Personal = [
              {
                Portfolio = [
                  {
                    abbr = "PO";
                    href = "https://${vars.baseDomain}";
                  }
                ];
              }
            ];
          }
        ];
    };

  };
}
