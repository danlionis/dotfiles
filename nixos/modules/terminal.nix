{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
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

  programs.direnv.enable = true;

  programs.starship.enable = true;

  programs.fish.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = pkgs.unstable.neovim-unwrapped;
  };

  programs.git.enable = true;
}
