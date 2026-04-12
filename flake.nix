{
  description = "NixOS configuration with dendritic architecture using flake-parts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    stylix.url = "github:danth/stylix";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";
    hermes-agent.url = "github:NousResearch/hermes-agent";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      flake = {
        # Dendritic module structure - manually defined for now
        # Features: cross-cutting functionality
        nixosModules = {
          # Base system configuration
          features-base = import ./modules/features/base/default.nix;
          features-users = import ./modules/features/users/default.nix;
          features-stylix = import ./modules/features/stylix/default.nix;

          # Host configurations - orchestrate features
          hosts-desktop = import ./modules/hosts/desktop/default.nix;
          hosts-laptop = import ./modules/hosts/laptop/default.nix;
          hosts-ancient = import ./modules/hosts/ancient/default.nix;
          hosts-hermes = import ./modules/hosts/hermes/default.nix;
        };

        # Home-manager modules (for future expansion)
        homeModules = {
          features-base = import ./modules/features/base/home.nix;
          features-users = import ./modules/features/users/home.nix;
          features-stylix = import ./modules/features/stylix/home.nix;
        };

        nixosConfigurations = {
          desktop = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./hosts/desktop/configuration.nix
              ./hosts/desktop/hardware-configuration.nix

              inputs.home-manager.nixosModules.home-manager
              {
                home-manager.backupFileExtension = "backup";
                home-manager.users.xam = import ./home/users/xam/xam.nix;
                home-manager.sharedModules = [
                  inputs.nixvim.homeModules.nixvim
                ];
              }

              inputs.agenix.nixosModules.default
              inputs.stylix.nixosModules.stylix

              # Import dendritic host module
              inputs.self.nixosModules.hosts-desktop
            ];
          };

          laptop = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./hosts/laptop/configuration.nix
              ./hosts/laptop/hardware-configuration.nix

              inputs.home-manager.nixosModules.home-manager
              {
                home-manager.backupFileExtension = "backup";
                home-manager.users.xam = import ./home/users/xam/xam.nix;
                home-manager.sharedModules = [
                  inputs.nixvim.homeModules.nixvim
                ];
              }

              inputs.agenix.nixosModules.default
              inputs.stylix.nixosModules.stylix

              inputs.self.nixosModules.hosts-laptop
            ];
          };

          ancient = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./hosts/ancient/configuration.nix
              ./hosts/ancient/hardware-configuration.nix

              inputs.agenix.nixosModules.default

              inputs.self.nixosModules.hosts-ancient
            ];
          };

          hermes = inputs.nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./hosts/hermes/configuration.nix
              ./hosts/hermes/hardware-configuration.nix

              inputs.agenix.nixosModules.default
              inputs.hermes-agent.nixosModules.default

              inputs.self.nixosModules.hosts-hermes
            ];
          };
        };
      };
    };
}
