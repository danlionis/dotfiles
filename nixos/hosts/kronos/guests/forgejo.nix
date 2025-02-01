{
  lib,
  config,
  ...
}:
let
  domain = config.globals.domains.git;
  cfg = config.services.forgejo;
in
{
  services.forgejo = {
    enable = true;
    # Enable support for Git Large File Storage
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = domain;
        # You need to specify this to remove the port from URLs in the web UI.
        ROOT_URL = "https://${domain}/";
        HTTP_PORT = 3000;
        # SSH_PORT = 2222;
      };
      # You can temporarily allow registration to create an admin user.
      service.DISABLE_REGISTRATION = true;
      # Add support for actions, based on act: https://github.com/nektos/act
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
    };
  };

  age.secrets.forgejo-oauth-secret = {
    file = ../../../../secrets/forgejo/oauth_secret;
    owner = cfg.user;
  };

  # https://github.com/NixOS/nixpkgs/issues/258371
  # systemd.services.forgejo.serviceConfig.Type = lib.mkForce "exec";
  systemd.services.forgejo.preStart =
    let
      cmd = "${lib.getExe cfg.package}";
      secret = config.age.secrets.forgejo-oauth-secret;
    in
    ''
      ${cmd} admin auth add-oauth --provider=openidConnect --name=Kanidm --key=git --secret="$(tr -d '\n' < ${secret.path})" --auto-discover-url=https://${config.globals.domains.kanidm}/oauth2/openid/git/.well-known/openid-configuration || true
    '';

  services.caddy = {
    virtualHosts."${domain}".extraConfig = ''
      reverse_proxy http://localhost:3000
    '';
  };
}
