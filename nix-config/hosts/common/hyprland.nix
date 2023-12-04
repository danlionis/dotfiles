{ pkgs, ... }: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    (callPackage ../../packages/sway-audio-idle-inhibit/default.nix { })
    dunst
    eww-wayland
    grim
    hyprpaper
    imagemagick
    libnotify
    networkmanagerapplet
    playerctl
    pywal
    rofi-wayland
    tofi
    slurp
    swappy
    swayidle
    swaylock-effects
    udiskie
    waybar
    wl-clipboard
    wlogout
    wlsunset
  ];

  services.udisks2.enable = true;
}
