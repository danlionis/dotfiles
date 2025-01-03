{ pkgs, pkgs-unstable, ... }:
let
  my-google-fonts = (
    pkgs.google-fonts.overrideAttrs # TODO: check back if SUSE is available
      (
        finalAttrs: previousAttrs: {
          version = "unstable-2024-10-11";

          src = pkgs.fetchFromGitHub {
            owner = "google";
            repo = "fonts";
            rev = "d5ee1e8889c47de07a13a8101e734abcfb368676";
            hash = "sha256-xcocMFAcus/csQkOluwahp4Rxl5iz49su00rOQbx+uY=";
          };
        }
      )
  );
  nerdfonts = with pkgs-unstable.nerd-fonts; [
    jetbrains-mono
    meslo-lg
  ];
in
{

  fonts.fontDir.enable = true; # https://wiki.nixos.org/wiki/Fonts#Flatpak_applications_can't_find_system_fonts

  # fonts
  fonts.packages =
    with pkgs;
    [
      noto-fonts
      comic-relief
      (my-google-fonts.override {
        fonts = [
          "SUSE"
          "Inter"
          "Oswald"
          "Roboto"
          "Pacifico"
        ];
      })
    ]
    ++ nerdfonts;
}
