{
  description = "Entrypoint into Deephack's host configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    omarchy-nix = {
      url = "github:deephack1982/omarchy-nix-deephack";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    timr-tui.url = "github:sectore/timr-tui";
  };

  outputs = { self, nixpkgs, omarchy-nix, home-manager, timr-tui, ... }@inputs: let
    master-pkgs = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/master.tar.gz";
    }) {};
    inherit (self) outputs;
    # # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  in {
    # Your custom packages and modifications, exported as overlays
    # overlays = import ./overlays {inherit inputs;};

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      frame1 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs master-pkgs timr-tui;};
        system = "x86_64-linux";
        modules = [
          ./hosts/frame1/default.nix
          ./hosts/frame1/omarchy.nix
          ./hosts/frame1/home.nix
          ./modules/defaults.nix
          omarchy-nix.nixosModules.default
          home-manager.nixosModules.home-manager

          {
            nixpkgs.config.allowUnfree = true;
          }
        ];
      };
      dickie = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs master-pkgs timr-tui;};
        system = "aarch64-linux";
        modules = [
          ./hosts/dickie/default.nix
          ./hosts/dickie/omarchy.nix
          ./hosts/dickie/home.nix
          ./modules/defaults.nix
          omarchy-nix.nixosModules.default
          home-manager.nixosModules.home-manager

          {
            nixpkgs.config.allowUnfree = true;
          }
        ];
      };
    };
  };
}
