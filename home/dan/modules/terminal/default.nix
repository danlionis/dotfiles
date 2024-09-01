{ pkgs, ... }: {
  imports = [
    ./git.nix
  ];

  home.packages = with pkgs;
    [
      atuin
      bat
      btop
      comma
      dig
      eza
      fd
      file
      fzf
      gdu
      jq
      man-pages
      man-pages-posix
      navi
      nushell
      ripgrep
      tldr
      unzip
      vim
      wget
      xclip
      yazi
      yt-dlp
      zip
      zoxide
    ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = pkgs.unstable.neovim-unwrapped;
  };
}
