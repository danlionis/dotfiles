{ config, pkgs, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  keys = (import ../../../keys.nix).dan;
in
{
  age.secrets."password-hash".file = ../../../secrets/password-hash;

  users.users.dan = {
    isNormalUser = true;
    hashedPasswordFile = config.age.secrets."password-hash".path;
    extraGroups = ifTheyExist [
      "networkmanager"
      "wheel"
      "docker"
      "libvirtd"
      "wireshark"
    ];
    openssh.authorizedKeys.keys = keys;
    shell = pkgs.nushell;
  };
}
