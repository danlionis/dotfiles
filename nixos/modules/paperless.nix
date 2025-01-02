{ config, lib, ... }:
let
  cfg = config.modules.paperless;
  paperlessDir = "/var/lib/paperless";
  containerAddress = "10.0.0.2";
  hostAddress = "10.0.0.1";
  url = "paper.lionis.net";
in
{

  options.modules.paperless = {
    enable = lib.mkEnableOption "Paperless Module";
  };

  config = lib.mkIf cfg.enable {
    system.activationScripts = {
      paperlessDir = ''
        mkdir -p ${paperlessDir}
      '';
    };

    # environment.persistence."/persist" = {
    #   directories = [
    #     paperlessDir
    #   ];
    # };

    networking.hosts = {
      "${containerAddress}" = [ "paperless.localhost" ];
    };

    networking.nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "enp6s0";
      # Lazy IPv6 connectivity for the container
      enableIPv6 = true;
    };

    containers = {
      paperless = {
        privateNetwork = true;
        ephemeral = true;
        autoStart = true;
        localAddress = containerAddress;
        hostAddress = hostAddress;
        bindMounts = {
          "/var/lib/paperless" = {
            hostPath = paperlessDir;
            isReadOnly = false;
          };
        };
        config =
          {
            config,
            pkgs,
            lib,
            ...
          }:
          {
            # environment.etc."paperless-admin-pass".text = "admin";

            # $ sudo /var/lib/paperless/paperless-manage createsuperuser
            services.paperless = {
              enable = true;
              address = containerAddress;
              settings = {
                PAPERLESS_OCR_LANGUAGE = "deu+eng";
                PAPERLESS_URL = "https://${url}";
              };
            };

            networking = {
              firewall.allowedTCPPorts = [ config.services.paperless.port ];

              # Use systemd-resolved inside the container
              # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
              # useHostResolvConf = lib.mkForce false;
            };

          };
      };
    };

    services.caddy = {
      virtualHosts."${url}".extraConfig = ''
        reverse_proxy http://${containerAddress}:${toString config.services.paperless.port}
      '';
    };
  };
}
