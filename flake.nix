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

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    tokyo-night-sddm = {
      url = "github:deephack1982/tokyo-night-sddm/cdb0e515c1d5ba31446329b9e593b84c8c755cad";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ai-tools = {
      url = "github:numtide/nix-ai-tools";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, omarchy-nix, home-manager, timr-tui, zen-browser, tokyo-night-sddm, nix-ai-tools,... }@inputs:
  let
    systems = [ "aarch64-linux" "x86_64-linux" ];
    master-pkgs = system: import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/master.tar.gz";
    }){ inherit system; };
  in {
    # Your custom packages and modifications, exported as overlays
    # overlays = import ./overlays {inherit inputs;};

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      frame1 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs timr-tui zen-browser;
          master-pkgs = master-pkgs "x86_64-linux";
        };
        system = "x86_64-linux";
        modules = [
          {
            nixpkgs.overlays = [ tokyo-night-sddm.overlays.default ];
          }
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
        specialArgs = {inherit inputs timr-tui zen-browser; };
        system = "aarch64-linux";
        modules = [
          {
            nixpkgs.overlays = [ tokyo-night-sddm.overlays.default ];
          }
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
