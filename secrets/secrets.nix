let
  keys = import ../keys.nix;
in
{
  "restic/password".publicKeys = keys.dan ++ [ keys.kronos ];

  "test.age".publicKeys = keys.dan ++ [ ];

  "CF_API_KEY".publicKeys = keys.dan ++ [ keys.kronos ];
}
