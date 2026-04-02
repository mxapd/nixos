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
    agenix.url = "github:ryantm/agenix";

    shared-hosts.url = "git+ssh://gitea@gitea.yggdrasil.com/vinx/Shared-Intranet-Host.git?ref=main";
  };

  outputs = { self, nixpkgs, stylix, home-manager, nixvim, shared-hosts, agenix, ... } @ inputs:

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
	./core/stylix.nix
	
	./hosts/desktop/configuration.nix

	home-manager.nixosModules.home-manager {
          home-manager.backupFileExtension = "backup";
          home-manager.users.xam = import ./home/users/xam/xam.nix;
          home-manager.sharedModules = [
              nixvim.homeModules.nixvim
          ];
        }
	
	agenix.nixosModules.default
	shared-hosts.outputs.nixosModules.sheardHosts
	stylix.nixosModules.stylix 
      ];
    };
  
    nixosConfigurations.ancient = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [	
	./core/base.nix
	./core/tailscale.nix
	./core/users.nix

	./hosts/ancient/configuration.nix

	agenix.nixosModules.default
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
	./core/stylix.nix
	
	./hosts/laptop/configuration.nix
	
	home-manager.nixosModules.home-manager {
          home-manager.backupFileExtension = "backup";
          home-manager.users.xam = import ./home/users/xam/xam.nix;
          home-manager.sharedModules = [
              nixvim.homeModules.nixvim
          ];
        }
	agenix.nixosModules.default
	shared-hosts.outputs.nixosModules.sheardHosts

	stylix.nixosModules.stylix 
      ];
    };
  };
}
