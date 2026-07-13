{ inputs, ... }:

{
  flake.nixosConfigurations.sojourn =
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        inputs.self.nixosModules.boot
        inputs.self.nixosModules.sojourn-hardware
        inputs.self.nixosModules.user-xam

        inputs.self.nixosModules.audio
        inputs.self.nixosModules.bluetooth
        inputs.self.nixosModules.networking
        inputs.self.nixosModules.fonts
        inputs.self.nixosModules.locale
        inputs.self.nixosModules.sops
        inputs.self.nixosModules.nix-maintenance
        inputs.self.nixosModules.ssh
        inputs.self.nixosModules.sudo
        inputs.self.nixosModules.nvidia
        inputs.self.nixosModules.stylix
        inputs.self.nixosModules.unfree

        inputs.self.nixosModules.home-manager
        inputs.self.nixosModules.hm-xam
        inputs.self.nixosModules.hyprmoon

        inputs.self.nixosModules.ssh-authorized-keys
        inputs.self.nixosModules.ssh-access-sojourn 
        inputs.self.nixosModules.git-access

        inputs.self.nixosModules.syncthing
        inputs.self.nixosModules.tailscale

        # inputs.self.nixosModules.virtualbox
	inputs.self.nixosModules.torzu
	# inputs.self.nixosModules.flatpak
	# inputs.self.nixosModules.steam
        inputs.self.nixosModules.firefox

	({ pkgs, ... }:	{
	  networking.hostName = "sojourn"; # other options: nomad, voyager, pilgrim
	  system.stateVersion = "26.05";
	  
	  console.keyMap = "sv-latin1";
	  services = {
	    # xserver.libinput.enable = true;
	    xserver.enable = true;
	    xserver.xkb = {
	      layout = "se";
	      variant = "";
	    };
	  };

	  environment.systemPackages = with pkgs; [
	    gotop
	    htop
	    fastfetch
	    
	    obsidian
	    discord-canary
	    slack
	    spotify
	    libreoffice
	   
	    thinkfan
	    auto-cpufreq
	    brightnessctl
	    lm_sensors
	    playerctl
	  ];
	})
      ];
    };
}
