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
        inputs.self.nixosModules.locale
        inputs.self.nixosModules.sudo
        inputs.self.nixosModules.tailscale
        inputs.self.nixosModules.nix-maintenance
        inputs.self.nixosModules.unfree
        inputs.self.nixosModules.ssh-authorized-keys


        inputs.self.nixosModules.ssh
        inputs.self.nixosModules.jellyfin
        inputs.self.nixosModules.samba
        inputs.self.nixosModules.ancient-syncthing
        inputs.self.nixosModules.gitea
        inputs.self.nixosModules.radicale
        inputs.self.nixosModules.prowlarr
        
	({ ... }: {
          networking.hostName = "ancient"; 
          system.stateVersion = "26.05";

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
        })
      ];
    };
}

