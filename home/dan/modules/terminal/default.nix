{ pkgs, lib, ... }:
{
  imports = [
    ./direnv.nix
    ./git.nix
  ];

  home.packages =
    let
      commonPackages = with pkgs; [
        atuin
        bat
        bitwarden-cli
        btop
        carapace
        comma
        dig
        eza
        fd
        file
        fzf
        gdu
        jq
        lazygit
        man-pages
        man-pages-posix
        navi
        nushell
        prettierd
        ripgrep
        starship
        tldr
        unzip
        wget
        xclip
        yazi
        yt-dlp
        zip
        zoxide
      ];
      linuxPackages = with pkgs; [
        distrobox
        kanidm
      ];
      darwinPackages = [ ];
    in
    commonPackages
    ++ lib.optionals pkgs.stdenv.isLinux linuxPackages
    ++ lib.optionals pkgs.stdenv.isDarwin darwinPackages;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = pkgs.unstable.neovim-unwrapped;
  };

}
