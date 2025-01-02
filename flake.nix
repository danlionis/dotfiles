{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    ags.url = "github:Aylur/ags/v1"; # WARNING: migrate to v2, please do so soon...

    impermanence.url = "github:nix-community/impermanence";
    disko = {
      url = "github:nix-community/disko";
    };

    # # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    systems.url = "github:nix-systems/default";

    agenix = {
      url = "github:ryantm/agenix";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      # inputs.nixpkgs-stable.follows = "nixpkgs";
      # inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    };

  };

  outputs =
    {
      self,
      nixpkgs-stable,
      nixpkgs-unstable,
      disko,
      nix-darwin,
      home-manager,
      systems,
      agenix,
      ghostty,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = function: nixpkgs-stable.lib.genAttrs (import systems) (system: function system);
    in
    {

      overlays = import ./nixos/overlays { inherit inputs outputs; };

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs-stable.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs =
              with pkgs;
              [
                lua-language-server
                stylua

                nixd
                nixfmt-rfc-style
                nodePackages.typescript-language-server

                pyright
              ]
              ++ [ agenix.packages.${system}.default ];
          };
        }
      );

      nixosConfigurations =
        let
          mapHostname = builtins.mapAttrs (name: f: f name);
        in
        mapHostname {
          kronos =
            hostname:
            nixpkgs-stable.lib.nixosSystem {
              specialArgs = {
                inherit inputs outputs;
                meta = {
                  inherit hostname;
                };
              };
              system = "aarch64-linux";
              modules = [
                ./nixos/hosts/kronos
                disko.nixosModules.default
                agenix.nixosModules.default
              ];
            };
          dan-pc =
            hostname:
            nixpkgs-stable.lib.nixosSystem rec {
              specialArgs = {
                inherit inputs outputs;
                meta = {
                  inherit hostname;
                };
                pkgs-unstable = import nixpkgs-unstable {
                  inherit system;
                  config.allowUnfree = true;
                };
              };
              system = "x86_64-linux";
              modules = [
                ./nixos/hosts/desktop
                home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.dan = import ./home/dan/desktop.nix;
                }

                agenix.nixosModules.default
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
