{
  config,
  pkgs,
  lib,
  outputs,
  inputs,
  meta,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko.nix
    ./hardware-configuration.nix

    ../../modules/users/dan.nix

    ../../modules/tailscale.nix
    ../../modules
  ];

  modules = {
    paperless.enable = true;
    caddy.enable = true;
  };

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

  networking.hostName = meta.hostname; # Define your hostname.

  environment.systemPackages = with pkgs; [
    git
    neovim
    starship
    zoxide
    atuin
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
}
