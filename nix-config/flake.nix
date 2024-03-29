{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # # Home manager
    # home-manager.url = "github:nix-community/home-manager/release-23.05";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let inherit (self) outputs; in {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'

      overlays = import ./overlays {
        inherit inputs outputs;
      };

      nixosConfigurations = {
        dan-laptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; }; # Pass flake inputs to our config
          # > Our main nixos configuration file <
          modules = [
            ./hosts/laptop
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
    };
}
