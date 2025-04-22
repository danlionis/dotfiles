# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{
  nixpkgs,
  inputs,
  outputs,
}:

{
  user,
  darwin ? false,
  home-manager ? false,
  config ? null,
}:
name:

let
  enableHomeManager = home-manager;

  machineConfig = if config == null then ../nixos/hosts/${name}/default.nix else config;
  # userOSConfig = ../home/${user}/${if darwin then "darwin" else "nixos"}.nix;
  userHMConfig = ../home/${user}/${name}.nix;

  # NixOS vs nix-darwin functionst
  systemFunc = if darwin then inputs.darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
  hm-module = if darwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;

  optionals = cond: list: if cond then list else [ ];
in
systemFunc rec {
  specialArgs = {
    inherit inputs outputs;
  };
  modules =
    [
      ../modules/globals.nix
      ../globals.nix

      {
        nixpkgs.overlays = builtins.attrValues outputs.overlays; # apply overlays
        nixpkgs.config.allowUnfree = true; # allow unfree packages.
      }

      inputs.agenix.nixosModules.default

      machineConfig
      {
        networking.hostName = name;
        environment.sessionVariables = {
          NIX_SYSTEM_NAME = name;
        };
      }

      # userOSConfig
    ]
    ++ optionals enableHomeManager [
      hm-module.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = import userHMConfig;
        home-manager.extraSpecialArgs = specialArgs;
      }
    ];
}
