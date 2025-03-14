{
  config,
  lib,
  pkgs,
  ...
}:

let
  port = 58080;
  domain = config.globals.domains.start;
  importYaml =
    file:
    builtins.fromJSON (
      builtins.readFile (
        pkgs.runCommandNoCC "converted-yaml.json" { } ''
          ${pkgs.yj}/bin/yj < "${file}" > "$out"
        ''
      )
    );
in
{
  services.glance = {
    enable = true;
    package = pkgs.unstable.glance;
    settings = (importYaml ./glance.yml) // {
      server.port = port;
    };
  };

  services.caddy = {
    virtualHosts."${domain}".extraConfig = ''
      reverse_proxy http://localhost:${builtins.toString port}
    '';
  };
}
