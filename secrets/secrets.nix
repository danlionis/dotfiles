let
  dan-desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJx4XvyBnsone/e2O6oGxuRQQNzZwlobeOWGAtSO3EN9";
  users = [
    dan-desktop
  ];

  systems = [
  ];
in
{
  "test.age".publicKeys = [ dan-desktop ];
}
