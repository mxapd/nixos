{ inputs, ... }:

{
  flake.nixosConfigurations.hearth =
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [

        ({ pkgs, lib, config, ... }: {
          networking.hostName = "hearth";
          time.timeZone = "Europe/Stockholm";

          services.openssh.enable = true;

	  boot.loader.systemd-boot.enable = true;
	  boot.loader.efi.canTouchEfiVariables = true;

          security.sudo.enable = true;

	  nixpkgs.config.allowUnfree = true;

	  environment.systemPackages = with pkgs; [
	    discord-canary
	  ];

        })
	
        inputs.self.nixosModules.user-xam
        inputs.self.nixosModules.hearth-hardware
	inputs.self.nixosModules.hyprland
	inputs.self.nixosModules.nvidia


      ];
  };
}
