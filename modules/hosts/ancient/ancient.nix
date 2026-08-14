{ inputs, ... }:

{
  flake.nixosConfigurations.ancient =
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [

        inputs.self.nixosModules.ancient-boot
        inputs.self.nixosModules.ancient-hardware
        inputs.self.nixosModules.ancient-raid
        inputs.self.nixosModules.ancient-nvidia
	inputs.self.nixosModules.user-xam
	inputs.self.nixosModules.sops
        inputs.self.nixosModules.locale
        inputs.self.nixosModules.sudo
        inputs.self.nixosModules.tailscale
        inputs.self.nixosModules.nix-maintenance
        inputs.self.nixosModules.unfree
        inputs.self.nixosModules.ssh-authorized-keys


        inputs.self.nixosModules.ssh
        inputs.self.nixosModules.caddy
        inputs.self.nixosModules.jellyfin
        inputs.self.nixosModules.samba
        inputs.self.nixosModules.ancient-syncthing
        inputs.self.nixosModules.gitea

	inputs.self.nixosModules.radicale
        inputs.self.nixosModules.vdirsyncer-school

	inputs.self.nixosModules.prowlarr
	inputs.self.nixosModules.lidarr
        
	({ pkgs, ... }: {
          networking.hostName = "ancient"; 
          system.stateVersion = "26.05";
          environment.systemPackages = with pkgs; [
            git
	  ];
	  
	  networking.firewall = {
            enable = true;
            allowPing = true;
            allowedTCPPorts = [
              80    # Caddy HTTP
              443   # Caddy HTTPS
              445   # Samba
              2222  # Gitea SSH
              6881  # qBittorrent torrenting
              22000 # Syncthing sync port
            ];
            allowedUDPPorts = [
              6881  # qBittorrent torrenting
            ];
          };
        })
      ];
    };
}

