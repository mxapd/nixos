{ inputs, lib, ... }:
{
  flake.modules.nixos.home-manager = { pkgs, config, ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      extraSpecialArgs = { inherit inputs; };

      # pull in every dendritic home-manager module that's been
      # registered anywhere else in the flake
      sharedModules = lib.attrValues config.flake.modules.homeManager or { };
    };
  };
}
