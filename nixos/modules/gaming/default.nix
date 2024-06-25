{ pkgs, lib, config, ... }: {

  options = {
    gaming.enable = lib.mkEnableOption "enable gaming";
  };

  config = lib.mkIf config.gaming.enable {
    environment.systemPackages = with pkgs; [
      bottles
    ];

    # steam
    programs.steam.enable = true;
  };
}
