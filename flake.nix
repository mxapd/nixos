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

    shared-hosts.url = "git+ssh://gitea@gitea.yggdrasil.com/vinx/Shared-Intranet-Host.git?ref=main";
  };

  outputs = { self, nixpkgs, stylix, home-manager, nixvim, shared-hosts, ... } @ inputs:

  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in
  {

    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [	
	./core/base.nix
	./core/tailscale.nix
	./core/users.nix
	
	./hosts/desktop/configuration.nix

	shared-hosts.outputs.nixosModules.sheardHosts

	home-manager.nixosModules.home-manager {
          home-manager.backupFileExtension = "backup";
          home-manager.users.xam = import ./home/users/xam/xam.nix;
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
	./core/global.nix
	./core/tailscale.nix
	./core/users.nix
	
	./hosts/ancient/configuration.nix

	shared-hosts.outputs.nixosModules.sheardHosts
      ];
    };

    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [	
	./core/base.nix
	./core/tailscale.nix
	./core/users.nix
	
	./hosts/laptop/configuration.nix
	
	shared-hosts.outputs.nixosModules.sheardHosts

	home-manager.nixosModules.home-manager {
          home-manager.backupFileExtension = "backup";
          home-manager.users.xam = import ./home/users/xam/xam.nix;
          home-manager.sharedModules = [
              nixvim.homeModules.nixvim
          ];
        }

	stylix.nixosModules.stylix 
      ];
    };
  };
}
