{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.modules.gaming = {
    enable = lib.mkEnableOption "enable gaming";
  };

  config = lib.mkIf config.modules.gaming.enable {
    environment.systemPackages = with pkgs; [
      bottles
      mangohud
      r2modman
    ];

    # steam
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    programs.gamemode.enable = true;
  };
}
