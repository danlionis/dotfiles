{
  config,
  pkgs,
  ...
}:
{
  age.secrets."CLOUDFLARE_DNS_API_TOKEN".file = ../../secrets/CLOUDFLARE_DNS_API_TOKEN;

  services.caddy = {
    enable = true;
    package = pkgs.unstable.caddy.withPlugins {
      plugins = [
        "github.com/caddy-dns/cloudflare@v0.0.0-20240703190432-89f16b99c18e"
      ];
      hash = "sha256-W09nFfBKd+9QEuzV3RYLeNy2CTry1Tz3Vg1U2JPNPPc=";
    };
    globalConfig = ''
      acme_dns cloudflare {env.CLOUDFLARE_DNS_API_TOKEN}
    '';
  };

  systemd.services.caddy.serviceConfig = {
    EnvironmentFile = config.age.secrets."CLOUDFLARE_DNS_API_TOKEN".path;
  };
}
