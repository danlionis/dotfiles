{ pkgs, ... }: {
  programs.direnv.enable = true;

  programs.starship.enable = true;

  programs.fish.enable = true;

  programs.git.enable = true;
}
