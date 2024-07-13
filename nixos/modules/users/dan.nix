{ pkgs, ... }: {

  users.users.dan = {
    isNormalUser = true;
    initialPassword = "dan";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "wireshark" ];
  };
}
