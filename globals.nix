{ ... }:
{
  globals = {
    domains = rec {
      lionis = "lionis.net";
      start = "start.${lionis}";
      kanidm = "auth.${lionis}";
      paperless = "paper.${lionis}";
      git = "git.${lionis}";
    };
  };
}
