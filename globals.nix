{ ... }:
{
  globals = {
    domains = rec {
      lionis = "lionis.net";
      kanidm = "auth.${lionis}";
      paperless = "paper.${lionis}";
    };
  };
}
