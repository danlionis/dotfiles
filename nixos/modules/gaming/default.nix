{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    gaming.enable = lib.mkEnableOption "enable gaming";
  };

  config = lib.mkIf config.gaming.enable {
    environment.systemPackages = with pkgs; [
      bottles
      mangohud
    ];

    # steam
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    programs.gamemode.enable = true;
  };
}
