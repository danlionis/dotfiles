{ pkgs, ... }:
{

  fonts.fontDir.enable = true; # https://wiki.nixos.org/wiki/Fonts#Flatpak_applications_can't_find_system_fonts

  # fonts
  fonts.packages = with pkgs; [
    noto-fonts
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "Meslo"
      ];
    })
    (google-fonts.override {
      fonts = [
        "SUSE" # looks cool, but google-fonts in nixpkgs is out of date
        "Inter"
        "Oswald"
        "Roboto"
      ];
    })
  ];
}
