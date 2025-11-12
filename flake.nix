{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      };
  };

  outputs = { self, nixpkgs, stylix, home-manager, nixvim, ... } @ inputs:

  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in
  {

    # --DESKTOP--
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [	
	./common/global.nix
	./machines/desktop/configuration.nix
	./users/xam/xam.nix
	
	home-manager.nixosModules.home-manager {
          home-manager.backupFileExtension = "backup";
          home-manager.users.xam = import ./users/xam/home.nix;
          home-manager.sharedModules = [
              nixvim.homeModules.nixvim
          ];
        }

	stylix.nixosModules.stylix 
      ];
    };
  
    nixosConfigurations.ancient = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [	
	./common/global.nix
	./machines/ancient/configuration.nix
	./users/xam/xam.nix

	stylix.nixosModules.stylix 
      ];
    };
  };
}
