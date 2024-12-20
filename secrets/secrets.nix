let
  keys = import ../keys.nix;
in
{
  "restic/password".publicKeys = keys.dan ++ [ keys.server-zeus ];

  "test.age".publicKeys = keys.dan ++ [ ];
}
