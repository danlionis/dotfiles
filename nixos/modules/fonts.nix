{ pkgs, ... }:
{
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
