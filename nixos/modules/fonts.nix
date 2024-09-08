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
  ];
}
