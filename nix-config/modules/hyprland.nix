{ pkgs, ... }: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    ags
    brightnessctl
    dunst
    eww
    grim
    hyprpaper
    imagemagick
    libnotify
    libsForQt5.polkit-kde-agent
    networkmanagerapplet
    pavucontrol
    playerctl
    pywal
    rofi-wayland
    slurp
    swappy
    sway-audio-idle-inhibit
    tofi
    udiskie
    unstable.hypridle
    unstable.hyprlock
    waybar
    wl-clipboard
    wlogout
    wlsunset
  ];

  services.udisks2.enable = true;
}
