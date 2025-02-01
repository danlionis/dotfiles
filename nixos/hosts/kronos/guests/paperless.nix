{ config, lib, ... }:
let
  paperlessDir = "/var/lib/paperless";
  url = config.globals.domains.paperless;
  exportDir = "/tmp/paperless-export";
in
{

  system.activationScripts = {
    paperlessDir = ''
      mkdir -p ${paperlessDir}
    '';
  };

  containers = {
    paperless = {
      privateNetwork = true;
      ephemeral = true;
      autoStart = true;
      localAddress = "10.0.0.2";
      hostAddress = "10.0.0.1";
      bindMounts = {
        "/var/lib/paperless" = {
          hostPath = paperlessDir;
          isReadOnly = false;
        };
      };
      config =
        {
          config,
          ...
        }:
        {
          # $ sudo /var/lib/paperless/paperless-manage createsuperuser
          services.paperless = {
            enable = true;
            address = "0.0.0.0";
            settings = {
              PAPERLESS_OCR_LANGUAGE = "deu+eng";
              PAPERLESS_URL = "https://${url}";
            };
          };

          networking = {
            firewall.allowedTCPPorts = [ config.services.paperless.port ];

            # Use systemd-resolved inside the container
            # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
            useHostResolvConf = lib.mkForce false;
          };

        };
    };
  };

  services.caddy = {
    virtualHosts."${url}".extraConfig = ''
      reverse_proxy http://${config.containers.paperless.localAddress}:${toString config.services.paperless.port}
    '';
  };

  age.secrets."restic/password".file = ../../../../secrets/restic/password;
  age.secrets."restic/paperless-b2-env".file = ../../../../secrets/restic/paperless-b2-env;

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
