{ ... }:
{
  flake.nixosModules.compression-utils = { pkgs,... }: {
    home-manager.users.xam = {
      home.packages = with pkgs;[
        rar
	zip
      ];
    };
   
  };
}
