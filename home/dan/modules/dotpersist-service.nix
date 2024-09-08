{ pkgs, ... }:
let
  script = pkgs.writeShellApplication {

    name = "symlink-dotpersist";
    runtimeInputs = [ pkgs.coreutils ];

    text = ''
      shopt -s dotglob # include hidden files in globs

      PERSIST_DIR="$HOME/.persist"
      TARGET_DIR="$HOME"

      # Iterate over all files and directories in .persist
      for item in "$PERSIST_DIR"/*; do
          # Extract the basename of the item
          base_item=$(basename "$item")
          echo linking "$base_item"

          # Create a symlink in the target directory
          ln -sfn "$item" "$TARGET_DIR/$base_item"
      done
    '';
  };
in
{

  home.packages = [ script ];

  systemd.user.services.dotpersist = {
    Unit = {
      Description = "Symlink all files from .persist to home";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${script}/bin/symlink-dotpersist";
      Type = "oneshot";
    };
  };
}
