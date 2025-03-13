{
  config,
  pkgs,
  lib,
  outputs,
  inputs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")

    inputs.disko.nixosModules.default
    ./disko.nix

    ./hardware-configuration.nix

    ../../users/dan.nix

    ../../modules/tailscale.nix
    ../../modules/caddy.nix

    ./guests/paperless.nix
    ./guests/kanidm.nix
    ./guests/forgejo.nix
    ./guests/glance
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.qemuGuest.enable = true;

  services.fail2ban.enable = true;

  environment.systemPackages = with pkgs; [
    atuin
    carapace
    fd
    git
    neovim
    nushell
    starship
    yazi
    zoxide
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    persistent = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  system.stateVersion = "24.11";

  nixpkgs.overlays = builtins.attrValues outputs.overlays;
}
