{ inputs, ... }:

{
  flake.nixosConfigurations.ancient =
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
	inputs.self.nixosModules.ancient-hardware
        inputs.self.nixosModules.ancient-nvidia
        inputs.self.nixosModules.user-xam

        inputs.self.nixosModules.ssh
        inputs.self.nixosModules.jellyfin
        inputs.self.nixosModules.samba
        inputs.self.nixosModules.ancient-syncthing
        inputs.self.nixosModules.gitea

        ({ config, pkgs, ... }: {
          networking.hostName = "ancient"; # Define your hostname.

	  nixpkgs.config.allowUnfree = true;

	  boot.loader.grub = {
	    enable = true;
	    device = "/dev/sda";
	    useOSProber = true;
	  };

	  networking.firewall = {
	    enable = true;
	    allowPing = true;
	    allowedTCPPorts = [
	      445
	      3000 # for gitea
	      2222 # also for gitea but not sure if needed
	      8384 # Syncthing Web UI
	      5232 # redicale calendar
	      # 80
	      # 22000 # Syncthing sync port (TCP, usually opened by #yncthing.openFirewall = true)
	    ];
	  };

	  # Configure keymap in X11
	  services.xserver.xkb = {
	    layout = "us";
	    variant = "";
	  };

	  boot.swraid.enable = true;
	  boot.swraid.mdadmConf = ''
		MAILADDR root
		ARRAY /dev/md0 metadata=1.2 UUID=c2372504:3357ee60:294af604:572ab5f2
	  '';

	  # mount syncthing lv
	  fileSystems."/mnt/syncthing" = {
	    device = "/dev/disk/by-uuid/f37bb345-eeff-4ff4-863a-027b25e3587a";
	    fsType = "ext4";
	    options = [ "defaults" "nofail" ];
	  };

	  # mount media lv
	  fileSystems."/mnt/media" = {
	    device = "/dev/raid_storage_vg/media";
	    fsType = "ext4";
	    options = [ "defaults" "nofail" ];
	  };

	  # mount git
	  fileSystems."/mnt/git" = {
	    device = "/dev/raid_storage_vg/git";
	    fsType = "ext4";
	    options = [ "defaults" "nofail" ];
	  };

	  services.radicale = {
	    enable = true;
	    settings = {
	      server.hosts = [ "0.0.0.0:5232" ];
	      auth.type = "none";
	    };
	  };
	})
      ];
    };
}

