{ inputs, self ... }:

{
  flake.nixosConfigurations.ancient =
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = with self.nixosModules; [
        ancient-boot
        ancient-hardware
        ancient-raid
        ancient-nvidia
	user-xam
	sops
        locale
        sudo
        tailscale
        nix-maintenance
        unfree
        ssh-authorized-keys


        ssh
        caddy
        jellyfin
        samba
        ancient-syncthing
        gitea

	radicale
        vdirsyncer-school

	prowlarr
	lidarr
        
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

