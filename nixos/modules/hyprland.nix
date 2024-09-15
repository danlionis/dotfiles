{ pkgs, inputs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # package = pkgs.unstable.hyprland;
  };

  environment.systemPackages = with pkgs; [
    inputs.ags.packages."x86_64-linux".ags # https://github.com/NixOS/nixpkgs/issues/306446
    adw-gtk3

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
    waybar
    wl-clipboard
    wlogout
    wlsunset

    unstable.hypridle
    unstable.hyprlock
  ];

  services.udisks2.enable = true;
}
