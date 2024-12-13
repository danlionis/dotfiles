{
  pkgs,
  inputs,
  outputs,
  ...
}:
let
  self = inputs.self;
in
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    clang-tools
    eza
    fish
    lazygit
    neovim
    obsidian
    shellcheck
    shfmt
    starship

    nodePackages.bash-language-server
  ];

  environment.variables = {
  };

  nixpkgs.overlays = builtins.attrValues outputs.overlays;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.dan = {
    # shell = pkgs.fish;
    home = "/Users/dan";
  };
  # programs.fish.enable = true;
  # environment.shells = [ pkgs.fish ];

  homebrew = {
    enable = true;
    autoUpdate = true;
    # updates homebrew packages on activation,
    # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
    casks = [
      "brave-browser"
      "kitty"
      "nikitabobko/tap/aerospace"
      "raycast"
    ];
    brews = [
      "xcodegen"
      "swiftlint"
      "swiftformat"
    ];
  };
}
