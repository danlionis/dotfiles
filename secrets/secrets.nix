let
  keys = import ../keys.nix;
in
{
  "restic/password".publicKeys = keys.dan ++ [ keys.kronos ];
  "restic/paperless-b2-env".publicKeys = keys.dan ++ [ keys.kronos ];

  "test.age".publicKeys = keys.dan ++ [ ];

  "CLOUDFLARE_DNS_API_TOKEN".publicKeys = keys.dan ++ [ keys.kronos ];

  "password-hash".publicKeys = keys.dan ++ [ keys.kronos ];

  "kanidm/key.pem".publicKeys = keys.dan ++ [ keys.kronos ];
  "kanidm/cert.pem".publicKeys = keys.dan ++ [ keys.kronos ];

  "forgejo/oauth_secret".publicKeys = keys.dan ++ [ keys.kronos ];
}
