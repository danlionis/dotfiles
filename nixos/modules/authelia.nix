{ config, lib, ... }:

let
  instance = "kronos";
  stateDir = "/var/lib/authelia-${instance}";
  domain = "auth.lionis.net";
  port = 9091;
  containerAddress = "10.0.0.3";
  hostAddress = "10.0.0.1";
in
{
  system.activationScripts = {
    autheliaDir = ''
      mkdir -p ${stateDir}
    '';
  };

  containers = {
    authelia = {
      privateNetwork = true;
      ephemeral = true;
      autoStart = true;
      localAddress = containerAddress;
      hostAddress = hostAddress;
      bindMounts = {
        "${stateDir}" = {
          hostPath = stateDir;
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
          services.authelia.instances.${instance} = {
            enable = true;

            secrets = {
              jwtSecretFile = "${pkgs.writeText "jwtSecretFile" "00000000000000000000"}";
              storageEncryptionKeyFile = "${pkgs.writeText "storageEncryptionKeyFile" "00000000000000000000"}";
            };

            settings = {
              theme = "auto";

              server = {
                address = "tcp://:${toString port}";
              };
              default_2fa_method = "webauthn";

              access_control = {
                default_policy = "one_factor";
              };

              authentication_backend = {
                file = {
                  watch = true;
                  path = "${stateDir}/users.yaml";
                };
              };

              session = {
                cookies = [
                  {
                    domain = "lionis.net";
                    authelia_url = "https://${domain}";
                  }
                ];
              };

              storage = {
                local.path = "${stateDir}/db.sqlite3";
              };

              notifier.filesystem.filename = "${stateDir}/notifications.txt";

            };
          };

          networking = {
            firewall.allowedTCPPorts = [ port ];

            # Use systemd-resolved inside the container
            # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
            # useHostResolvConf = lib.mkForce false;
          };
        };
    };
  };

  services.caddy = {
    virtualHosts."${domain}".extraConfig = ''
      reverse_proxy http://${containerAddress}:${toString port}
    '';

    extraConfig = ''
      (forward_auth) {
          forward_auth authelia:9091 {
              uri /api/authz/forward-auth
              ## The following commented line is for configuring the Authelia URL in the proxy. We strongly suggest
              ## this is configured in the Session Cookies section of the Authelia configuration.
              # uri /api/authz/forward-auth?authelia_url=https://auth.example.com/
              copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
          }
      }
    '';
  };

}
