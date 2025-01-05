let
  keys = import ../keys.nix;
in
{
  "restic/password".publicKeys = keys.dan ++ [ keys.kronos ];
  "restic/paperless-b2-env".publicKeys = keys.dan ++ [ keys.kronos ];

  "test.age".publicKeys = keys.dan ++ [ ];

  "CF_API_KEY".publicKeys = keys.dan ++ [ keys.kronos ];

  "password-hash".publicKeys = keys.dan ++ [ keys.kronos ];
}
