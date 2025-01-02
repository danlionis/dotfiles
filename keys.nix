rec {
  dan-desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJx4XvyBnsone/e2O6oGxuRQQNzZwlobeOWGAtSO3EN9";
  dan-mbp = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG9P2/XJxMMoeS3rwpaJ0OXckAa6p//1sDsYmv2cKV/M"; # macbook

  kronos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIP+5lDeQUQLd9jriFQLqpWjSpkn1kAk2QfzSINut7cR";

  dan = [
    dan-desktop
    dan-mbp
  ];
}
