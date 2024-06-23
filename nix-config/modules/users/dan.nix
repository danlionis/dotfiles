{ pkgs, ... }: {

  users.users.dan = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "wireshark" ];
  };
}
