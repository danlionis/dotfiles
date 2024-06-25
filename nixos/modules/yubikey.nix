{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    yubikey-manager
    yubioath-flutter
  ];

  services.pcscd.enable = true;
}
