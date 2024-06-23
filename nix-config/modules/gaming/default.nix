{ pkgs, lib, config, ... }: {

  options = {
    gaming.enable = lib.mkEnableOption "enable gaming";
  };

  config = lib.mkIf config.gaming.enable {
    # steam
    programs.steam.enable = true;
  };
}
