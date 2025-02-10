{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    rocmOverrideGfx = "11.0.1";
  };

  # WARNING: https://github.com/NixOS/nixpkgs/issues/379354 https://github.com/NixOS/nixpkgs/issues/380636
  # services.open-webui = {
  #   enable = true;
  #   port = 11111;
  #   package = pkgs.unstable.open-webui;
  # };
}
