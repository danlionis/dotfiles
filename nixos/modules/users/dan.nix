{ config, pkgs, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJx4XvyBnsone/e2O6oGxuRQQNzZwlobeOWGAtSO3EN9 dan@dan" # pc
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG9P2/XJxMMoeS3rwpaJ0OXckAa6p//1sDsYmv2cKV/M" # macbook
  ];
in
{
  users.users.dan = {
    isNormalUser = true;
    initialPassword = "dan";
    extraGroups = ifTheyExist [
      "networkmanager"
      "wheel"
      "docker"
      "libvirtd"
      "wireshark"
    ];
    openssh.authorizedKeys.keys = keys;
  };

  programs.fish.enable = true;
}
