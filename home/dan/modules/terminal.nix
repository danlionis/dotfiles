{ pkgs, ... }: {
  home.packages = with pkgs; [
    atuin
    bat
    btop
    dig
    eza
    fd
    file
    fzf
    gdu
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
