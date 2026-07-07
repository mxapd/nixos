{ inputs, lib, ... }:
{
  flake.modules.nixos.home-manager = { pkgs, config, ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      backupFileExtension = "backup";
      
      extraSpecialArgs = { inherit inputs; };
    };
  };
}
