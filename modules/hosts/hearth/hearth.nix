{ inputs, ... }:

{
  flake.nixosConfigurations.hearth =
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
	inputs.self.nixosModules.boot
        inputs.self.nixosModules.hearth-hardware
	inputs.self.nixosModules.user-xam
	
	inputs.self.nixosModules.networking
	inputs.self.nixosModules.sops
	inputs.self.nixosModules.nix-maintenance
	
	inputs.self.nixosModules.ssh
	inputs.self.nixosModules.sudo
	inputs.self.nixosModules.nvidia
	inputs.self.nixosModules.home-manager
	inputs.self.nixosModules.hm-xam
	inputs.self.nixosModules.hyprland
	inputs.self.nixosModules.hyprmoon
	inputs.self.nixosModules.waybar
	
	inputs.self.nixosModules.stylix
	
	inputs.self.nixosModules.ssh-authorized-keys
	inputs.self.nixosModules.ssh-access-hearth
	inputs.self.nixosModules.git-access
	
	inputs.self.nixosModules.syncthing
	inputs.self.nixosModules.tailscale-communal
	# inputs.self.nixosModules.virtualbox
	inputs.self.nixosModules.fonts
	
	inputs.self.nixosModules.audio
	inputs.self.nixosModules.bluetooth
	
	inputs.self.nixosModules.torzu
	inputs.self.nixosModules.flatpak
	inputs.self.nixosModules.steam
	inputs.self.nixosModules.firefox
        
	({ pkgs, ... }: {
	  networking.hostName = "hearth";
      	  
	    # --TIME--
      	  time.timeZone = "Europe/Stockholm";
      	    
      	    # internationalisation
      	  i18n = {
      	    defaultLocale = "en_US.UTF-8";
      	    extraLocaleSettings = {
      	      LC_ADDRESS = "sv_SE.UTF-8";
      	      LC_IDENTIFICATION = "sv_SE.UTF-8";
      	      LC_MEASUREMENT = "sv_SE.UTF-8";
      	      LC_MONETARY = "sv_SE.UTF-8";
      	      LC_NAME = "sv_SE.UTF-8";
      	      LC_NUMERIC = "sv_SE.UTF-8";
      	      LC_PAPER = "sv_SE.UTF-8";
      	      LC_TELEPHONE = "sv_SE.UTF-8";
      	      LC_TIME = "sv_SE.UTF-8";
      	    };
      	  };
      	  
	 services.printing.enable = true;
	 security.polkit.enable = true;
	 
	 services.ratbagd.enable = true;
	 
	 nix.settings.extra-platforms = [ "aarch64-linux" ];

      	    # --NIX--
      	 system.stateVersion = "26.05"; 
      	 nix.settings.experimental-features = [ "nix-command" "flakes"];
      	 nixpkgs.config.allowUnfree = true;
      	 
      	 # --PROGRAMS--
      	 environment.systemPackages = with pkgs; [
      	   discord-canary
	   wl-clipboard
	   tree
	   btop
      	   vim
      	   git
      	   tmux
      	   htop
      	   wget
      	   parted
      	   feh
      	   ripgrep
      	   file
      	   fzf
      	   zoxide
      	   fastfetch
      	 ];
      	})
      ];
  };
}
