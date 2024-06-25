{ lib
, fetchFromGitHub
, stdenv
, meson
, pkg-config
, libpulseaudio
, wayland-protocols
, wayland
, ninja
}:

stdenv.mkDerivation {
  pname = "sway-audio-idle-inhibit";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayAudioIdleInhibit";
    rev = "c850bc4812216d03e05083c69aa05326a7fab9c7";
    sha256 = "sha256-MKzyF5xY0uJ/UWewr8VFrK0y7ekvcWpMv/u9CHG14gs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libpulseaudio
    wayland
    wayland-protocols
  ];

  meta = with lib; {
    description = "Inhibit swayidle when audio is played";
    license = licenses.gpl3Only;
    maintainers = [ ];
  };
}
