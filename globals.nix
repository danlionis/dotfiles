{ ... }:
{
  globals = {
    domains = rec {
      lionis = "lionis.net";
      paperless = "paper.${lionis}";
    };
  };
}
