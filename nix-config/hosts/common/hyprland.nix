{ pkgs, ... }: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    ags
    dunst
    eww
    grim
    unstable.hypridle
    unstable.hyprlock
    hyprpaper
    imagemagick
    libnotify
    networkmanagerapplet
    pavucontrol
    playerctl
    pywal
    rofi-wayland
    slurp
    swappy
    sway-audio-idle-inhibit
    # swayidle
    # swaylock-effects
    tofi
    udiskie
    waybar
    wl-clipboard
    wlogout
    wlsunset
  ];

  services.udisks2.enable = true;
}
