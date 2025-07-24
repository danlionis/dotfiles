{ config, ... }:
{
  age.secrets."restic/password".file = ../../../secrets/restic/password;

  services.restic.backups = {
    daily-local = {
      initialize = true;

      repository = "/mnt/backup/dan";

      passwordFile = config.age.secrets."restic/password".path;

      paths = [
        "${config.users.users.dan.home}/Documents"
        "${config.users.users.dan.home}/Pictures"
        "${config.users.users.dan.home}/Videos"
        "${config.users.users.dan.home}/dev"
        "${config.users.users.dan.home}/uni"
      ];

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
      ];

      exclude = [
        ".venv"
        "node_modules"
      ];
    };
  };
}
