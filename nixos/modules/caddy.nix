{
  config,
  pkgs,
  ...
}:
{
  age.secrets."CF_API_KEY".file = ../../secrets/CF_API_KEY;

  services.caddy = {
    enable = true;
    package = pkgs.unstable.caddy.withPlugins {
      plugins = [
        "github.com/caddy-dns/cloudflare@v0.0.0-20240703190432-89f16b99c18e"
      ];
      hash = "sha256-WGV/Ve7hbVry5ugSmTYWDihoC9i+D3Ct15UKgdpYc9U=";
    };
    globalConfig = ''
      acme_dns cloudflare {env.CF_API_KEY}
    '';
  };

  systemd.services.caddy.serviceConfig = {
    EnvironmentFile = config.age.secrets."CF_API_KEY".path;
  };
}
