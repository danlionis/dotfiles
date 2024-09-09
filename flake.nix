{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    ags.url = "github:Aylur/ags";
    ags.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      nix-darwin,
      home-manager,
      systems,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      forAllSystems =
        function: nixpkgs.lib.genAttrs (import systems) (system: function nixpkgs.legacyPackages.${system});
    in
    {

      overlays = import ./nixos/overlays { inherit inputs outputs; };

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            lua-language-server
            stylua

            nixd
            nixfmt-rfc-style
            nodePackages.typescript-language-server

            pyright
          ];
        };
      });

      nixosConfigurations =
        let
          mapHostname = builtins.mapAttrs (name: f: f name);
        in
        mapHostname {
          dan-laptop =
            hostname:
            nixpkgs.lib.nixosSystem {
              specialArgs = {
                inherit inputs outputs;
                meta = {
                  inherit hostname;
                };
              };
              modules = [
                ./nixos/hosts/laptop
                nixos-hardware.nixosModules.lenovo-thinkpad-t470s
              ];
            };
          dan-pc =
            hostname:
            nixpkgs.lib.nixosSystem {
              specialArgs = {
                inherit inputs outputs;
                meta = {
                  inherit hostname;
                };
              };
              modules = [
                ./nixos/hosts/desktop
                home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.dan = import ./home/dan/desktop.nix;
                }
              ];
            };

        };

      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#dan-mbp
      darwinConfigurations."dan-mbp" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./darwin/mbp

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.dan = import ./home/dan/mbp.nix;
          }
        ];
      };
    };
}
