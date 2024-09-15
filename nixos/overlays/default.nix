{ outputs, inputs }:
{
  modifications = final: prev: {
    libfprint = prev.libfprint.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        # TheWeirdDev/libfprint/tree/55b4-experimental
        owner = "TheWeirdDev";
        repo = "libfprint";
        rev = "92168daeed1c9cf4afb7ebbd27ab34e3d7b2419d";
        # If you don't know the hash, the first time, set:
        # hash = "";
        # then nix will fail the build with such an error message:
        # hash mismatch in fixed-output derivation '/nix/store/m1ga09c0z1a6n7rj8ky3s31dpgalsn0n-source':
        # specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
        # got:    sha256-173gxk0ymiw94glyjzjizp8bv8g72gwkjhacigd1an09jshdrjb4
        hash = "sha256-HaLNHEumpj0fgsiYFDs+vktWzbfdbHv5ejQcBpMHMfk=";
      };
    });
    # sway-audio-idle-inhibit = prev.callPackage ./../packages/sway-audio-idle-inhibit { };
    rose-pine-hyprcursor = prev.callPackage ./../packages/rose-pine-hyprcursor { };
  };

  # https://discourse.nixos.org/t/use-unstable-version-for-some-packages/32880
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
