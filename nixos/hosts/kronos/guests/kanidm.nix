{ config, ... }:
let
  domain = config.globals.domains.kanidm;
in
{
  age.secrets = {
    "kanidm_cert" = {
      file = ../../../../secrets/kanidm/cert.pem;
      owner = "kanidm";
    };

    "kanidm_key" = {
      file = ../../../../secrets/kanidm/key.pem;
      owner = "kanidm";
    };
  };

  services.kanidm = {
    enableServer = true;
    serverSettings = {
      tls_chain = config.age.secrets."kanidm_cert".path;
      tls_key = config.age.secrets."kanidm_key".path;
      domain = domain;
      origin = "https://${domain}";
      trust_x_forward_for = true;

      online_backup = {
        versions = 7;
      };
    };
  };

  services.caddy = {
    virtualHosts."${domain}".extraConfig = ''
      reverse_proxy https://localhost:8443 {
          transport http {
              tls_insecure_skip_verify
          }
      }
    '';
  };
}
