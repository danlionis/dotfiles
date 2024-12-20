{ config, pkgs, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  keys = (import ../../../keys.nix).dan;
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
