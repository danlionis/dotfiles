# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, outputs, inputs, meta, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./impermanence.nix
      ./disko.nix

      inputs.disko.nixosModules.default
      inputs.impermanence.nixosModules.impermanence

      ../../modules/gaming
      ../../modules/hyprland.nix
      ../../modules/libvirt.nix
      ../../modules/podman.nix
      ../../modules/terminal.nix
      ../../modules/users/dan.nix
      ../../modules/yubikey.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 30;

  # kernel version
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostName = meta.hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.extraHosts =
    ''
      100.91.107.48 athena
    '';


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.networkmanager.dns = "none";
  # networking.nameservers = [ "127.0.0.1" "::1" ];
  # networking.dhcpcd.extraConfig = "nohook resolv.conf";

  # https://nixos.wiki/wiki/WireGuard#Setting_up_WireGuard_with_NetworkManager
  # networking.firewall.checkReversePath = "loose";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # # Configure keymap in X11
  # services.xserver = {
  #   layout = "eu";
  #   xkbVariant = "";
  # };

  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };

  # Configure console keymap
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.brlaser
    pkgs.brgenml1lpr
    pkgs.brgenml1cupswrapper
  ];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };


  # services.https-dns-proxy.enable = true;
  # services.https-dns-proxy.port = 53;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = builtins.attrValues outputs.overlays;

  environment.shells = with pkgs; [ fish ];

  environment.systemPackages = with pkgs; [
    # dev
    beautysh
    distrobox
    gcc
    gnumake
    lazygit
    lua-language-server
    nil
    nixpkgs-fmt
    nodejs
    pyright
    python3
    ruff
    rustup

    # gui / desktop
    brave
    brightnessctl
    ungoogled-chromium
    discord
    firefox
    kitty
    libreoffice
    obsidian
    piper
    spotify
    wireshark

    # other
    comma
    openssl
    pkg-config
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "mnjggcdmjocbbbhaepdhchncahnbgone" # sponsorblock
    ];
  };

  # List services that you want to enable:

  services.flatpak.enable = true;

  # programs.nix-ld.enable = true;

  # steam
  gaming.enable = true;

  environment.variables = {
    # NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
    # PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    persistent = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # fonts
  fonts.packages = with pkgs; [
    noto-fonts
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  services.tailscale.enable = true;

  security.polkit.enable = true;

  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };

  services.ratbagd.enable = true; # service for piper (gaming mouse)

  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  programs.command-not-found.enable = false;
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.wireshark.enable = true;


  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
  };
}
