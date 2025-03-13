{
  config,
  lib,
  pkgs,
  ...
}:

let
  port = 58080;
  domain = config.globals.domains.start;
in
{
  services.glance = {
    enable = true;
    package = pkgs.unstable.glance;
    settings = builtins.fromJSON (lib.readFile ./glance.json) // {
      server.port = port;
    };
  };

  services.caddy = {
    virtualHosts."${domain}".extraConfig = ''
      reverse_proxy http://localhost:${builtins.toString port}
    '';
  };
}
