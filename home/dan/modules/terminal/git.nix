{
  programs.git = {
    enable = true;
    userName = "Dan Lionis";
    ignores = [
      ".direnv"
      ".envrc"
      "result"
    ];

    delta.enable = true;
  };
}
