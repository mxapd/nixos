{
  description = "A very basic flake";

  inputs = {
    shared-hosts.url = "git+ssh://gitea@gitea.yggdrasil.com/vinx/Shared-Intranet-Host.git?ref=main";

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

  outputs = { self, nixpkgs, stylix, home-manager, nixvim, shared-hosts, ... } @ inputs:

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
	
	shared-hosts.outputs.nixosModules.sheardHosts

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

	shared-hosts.outputs.nixosModules.sheardHosts

	stylix.nixosModules.stylix 
      ];
    };

    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [	
	./common/global.nix
	./machines/laptop/configuration.nix
	./users/xam/xam.nix
	
	shared-hosts.outputs.nixosModules.sheardHosts

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
  };
}
