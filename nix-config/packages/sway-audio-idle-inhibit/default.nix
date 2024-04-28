{ callPackage
, writeShellScriptBin

}:

let
  unwrapped = callPackage ./unwrapped.nix { };
in

writeShellScriptBin "sway-audio-idle-inhibit" ''
  while true
  do
  	${unwrapped}/bin/sway-audio-idle-inhibit
  	sleep 1
  done
''
