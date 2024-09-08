{ pkgs, ... }:
let
  binds = {
    kitty = {
      binding = "<Super>Return";
      command = "kitty -o allow_remote_control=yes";
      name = "kitty";
    };
    brave = {
      binding = "<Super>b";
      command = "brave";
      name = "brave";
    };
  };
  bindsWithPrefix = builtins.listToAttrs (
    builtins.map (k: {
      name = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${k}";
      value = binds.${k};
    }) (builtins.attrNames binds)
  );
  extensions = with pkgs; [
    # gnomeExtensions.gsconnect.extensionUuid

    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-dock

    unstable.gnomeExtensions.focus-follows-workspace
  ];
in
{

  home.packages = extensions;

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
      edge-tiling = true;
      workspaces-only-on-primary = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 9;
    };

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
      switch-to-application-6 = [ ];
      switch-to-application-7 = [ ];
      switch-to-application-8 = [ ];
      switch-to-application-9 = [ ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
      switch-to-workspace-8 = [ "<Super>8" ];
      switch-to-workspace-9 = [ "<Super>9" ];

      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      move-to-workspace-5 = [ "<Shift><Super>5" ];
      move-to-workspace-6 = [ "<Shift><Super>6" ];
      move-to-workspace-7 = [ "<Shift><Super>7" ];
      move-to-workspace-8 = [ "<Shift><Super>8" ];
      move-to-workspace-9 = [ "<Shift><Super>9" ];

      close = [ "<Super>q" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      search = [ "<Super>space" ];
      custom-keybindings = builtins.map (name: "/${name}/") (builtins.attrNames bindsWithPrefix);
      screensaver = [ "<Super>Escape" ];
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = map (e: e.extensionUuid) extensions;
    };

  } // bindsWithPrefix;
}
