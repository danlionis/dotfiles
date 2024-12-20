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
  ];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  services.qemuGuest.enable = true;

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
