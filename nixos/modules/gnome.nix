{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  services.displayManager.defaultSession = "gnome";

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.dash-to-dock
  ];

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gedit # text editor
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);

  programs.dconf.enable = true;
}
