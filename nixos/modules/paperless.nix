{ config, lib, ... }:
let
  paperlessDir = "/var/lib/paperless";
  containerAddress = "10.0.0.2";
  hostAddress = "10.0.0.1";
  url = "paper.lionis.net";
  exportDir = "/tmp/paperless-export";
in
{

  system.activationScripts = {
    paperlessDir = ''
      mkdir -p ${paperlessDir}
    '';
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

  age.secrets."restic/password".file = ../../secrets/restic/password;
  age.secrets."restic/paperless-b2-env".file = ../../secrets/restic/paperless-b2-env;

  services.restic.backups = {
    paperless-b2-daily = {
      initialize = true;

      repository = "s3:s3.eu-central-003.backblazeb2.com/danlionis-restic-paperless";
      environmentFile = config.age.secrets."restic/paperless-b2-env".path;
      passwordFile = config.age.secrets."restic/password".path;

      backupPrepareCommand = ''
        mkdir -p ${exportDir} 
        ${paperlessDir}/paperless-manage document_exporter -d ${exportDir}
      '';

      paths = [
        exportDir
      ];

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
      ];
    };
  };

}
