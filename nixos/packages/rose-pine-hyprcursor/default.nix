{
  lib,
  stdenv,
  pkgs,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rose-pine-hyprcursor";
  version = "0.3.2";
  src = pkgs.fetchFromGitHub {
    owner = "ndom91";
    repo = "rose-pine-hyprcursor";
    rev = "40ce26cb29206722ff73839ead0d871d94751e90";
    sha256 = "sha256-J5IYvKcdGRL/sBuST5WaoESEIl7KPv8aJK8aLY6C91E=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/rose-pine-hyprcursor
    cp -R . $out/share/icons/rose-pine-hyprcursor/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Soho vibes for Cursors";
    downloadPage = "https://github.com/ndom91/rose-pine-hyprcursor/releases";
    homepage = "https://rosepinetheme.com/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ndom91 ];
  };
})
