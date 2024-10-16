{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixd
    nixfmt-rfc-style
    shellcheck
    shfmt

    nodePackages.bash-language-server
  ];
}
