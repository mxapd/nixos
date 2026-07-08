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

        inputs.self.nixosModules.hearth-hardware
	inputs.self.nixosModules.user-xam
	
	inputs.self.nixosModules.nvidia

	inputs.self.nixosModules.home-manager
	inputs.self.nixosModules.hm-xam
	
	inputs.self.nixosModules.hyprland
	inputs.self.nixosModules.hyprmoon
	inputs.self.nixosModules.hyprland-core
	inputs.self.nixosModules.stylix
	inputs.self.nixosModules.waybar
	
	inputs.nixvim.nixosModules.nixvim
	inputs.self.nixosModules.nixvim

	inputs.self.nixosModules.tailscale-communal
      ];
  };
}
