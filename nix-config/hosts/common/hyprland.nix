{ pkgs, ... }: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    sway-audio-idle-inhibit
    dunst
    eww-wayland
    grim
    hyprpaper
    imagemagick
    libnotify
    networkmanagerapplet
    pavucontrol
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
