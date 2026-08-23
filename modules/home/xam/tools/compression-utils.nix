{ ... }:
{
  flake.nixosModules.compression-utils = { pkgs,... }: {
    home-manager.users.xam = {
      home.packages = with pkgs;[
        rar
	unzip
	zip
	p7zip
      ];
    };
  };
}
