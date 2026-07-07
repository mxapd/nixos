{ inputs, ... }:

{
  flake.nixosConfigurations.hearth =
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [

        ({ pkgs, ... }: {
          networking.hostName = "hearth";
          time.timeZone = "Europe/Stockholm";

          services.openssh.enable = true;

	  boot.loader.systemd-boot.enable = true;
	  boot.loader.efi.canTouchEfiVariables = true;

          security.sudo.enable = true;
        })
	
        inputs.self.nixosModules.user-xam
        inputs.self.nixosModules.hearth-hardware
      ];
    };
}
