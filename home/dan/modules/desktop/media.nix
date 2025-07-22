{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mpv
    qimgv
    vlc
  ];
}
