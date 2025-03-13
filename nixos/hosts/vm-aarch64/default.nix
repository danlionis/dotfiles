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
    ./hardware-configuration.nix

    ./disko.nix
    inputs.disko.nixosModules.default

    ../../users/dan.nix

    ../../modules/docker.nix

    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  fileSystems = {
    "/mnt/utm" = {
      fsType = "9p";
      device = "share";
      options = [
        "trans=virtio"
        "version=9p2000.L"
        "rw"
        "_netdev"
        "nofail"
        "auto 0 0"
      ];
    };
    "/mnt/utm-user" = {
      fsType = "fuse.bindfs";
      device = "/mnt/utm";
      depends = [ "/mnt/utm" ];
      options = [
        "map=501/1000:@20/@100"
        "nofail"
      ];
    };
  };

  services.openssh.enable = true;

  users.users.dan = {
    hashedPasswordFile = lib.mkForce null;
    password = "dan";
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    git

    bindfs
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

  programs.command-not-found.enable = false;
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  age.identityPaths = lib.mkDefault [ "${config.users.users.dan.home}/.ssh/id_ed25519" ]; # https://github.com/ryantm/agenix/issues/45
}
