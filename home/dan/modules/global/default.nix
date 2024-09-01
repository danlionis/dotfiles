{ ... }: {
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = "dan";
    homeDirectory = "/home/dan";
    sessionVariables = {
      FLAKE = "$HOME/Documents/NixConfig";
    };
    packages = [ ];
  };
} 
