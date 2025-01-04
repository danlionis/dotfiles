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
let
  keys = (import ../../../keys.nix).dan;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko.nix
    ./hardware-configuration.nix

    ../../modules/users/dan.nix

    ../../modules/tailscale.nix
    ../../modules/paperless.nix
    ../../modules/caddy.nix

  ];

  modules.paperless.enable = true;

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

  users.users.root = {
    openssh.authorizedKeys.keys = keys;
  };

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
