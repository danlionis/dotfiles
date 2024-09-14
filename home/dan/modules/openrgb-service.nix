{ pkgs, ... }:
let
  script = pkgs.writeShellScript "openrgb-default-profile" ''
    ${pkgs.openrgb}/bin/openrgb -p $HOME/.config/OpenRGB/default.orp
  '';
in
{
  systemd.user.services.openrgb-default-profile = {
    Unit = {
      Description = "Load default OpenRGB profile";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${script}";
      Type = "oneshot";
    };
  };
}
