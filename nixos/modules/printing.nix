{ pkgs, ... }:
{
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing.drivers = [
    pkgs.brlaser
    pkgs.brgenml1lpr
    pkgs.brgenml1cupswrapper
  ];
}
