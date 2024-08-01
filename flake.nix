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
    # home-manager.url = "github:nix-community/home-manager/release-23.05";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, nixos-hardware, nix-darwin, ... }@inputs:
    let inherit (self) outputs; in {

      overlays = import ./nixos/overlays {
        inherit inputs outputs;
      };

      devShells.x86_64-linux.default =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in
        pkgs.mkShell {
          buildInputs = with pkgs;
            [
              lua-language-server
              nil
              nixpkgs-fmt
              nodePackages.typescript-language-server
              pyright
            ];
        };


      nixosConfigurations =
        let
          mapHostname = builtins.mapAttrs (name: f: f name);
        in
        mapHostname {
          dan-laptop = hostname: nixpkgs.lib.nixosSystem {
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
          dan-pc = hostname: nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs outputs;
              meta = {
                inherit hostname;
              };
            };
            modules = [
              ./nixos/hosts/desktop
            ];
          };

        };

      # # Standalone home-manager configuration entrypoint
      # # Available through 'home-manager --flake .#your-username@your-hostname'
      # homeConfigurations = {
      #   # FIXME replace with your username@hostname
      #   "dan@dan-laptop" = home-manager.lib.homeManagerConfiguration {
      #     pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      #     extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
      #     # > Our main home-manager configuration file <
      #     modules = [ ./home-manager/home.nix ];
      #   };
      # };

      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#dan-mbp
      darwinConfigurations."dan-mbp" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        modules = [ ./darwin/mbp ];
      };
    };
}
