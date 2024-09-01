{ config, pkgs, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{

  users.users.dan = {
    isNormalUser = true;
    initialPassword = "dan";
    shell = pkgs.fish;
    extraGroups = ifTheyExist [ "networkmanager" "wheel" "docker" "libvirtd" "wireshark" ];
  };

  programs.fish.enable = true;
}
