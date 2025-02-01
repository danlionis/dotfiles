{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.globals = {
    domains = mkOption {
      description = "Domain name";
      type = types.attrsOf types.str;
    };
  };
}
