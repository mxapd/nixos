# modules/hosts/ancient.nix
# Ancient server host configuration - complete system definition
# Combines: hardware-configuration.nix + configuration.nix + feature orchestration

{ self, inputs, ... }:

{
  flake.nixosConfigurations.ancient = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs self; };
    modules = [
      # Hardware configuration (from hosts/ancient/hardware-configuration.nix)
      ({ config, lib, pkgs, modulesPath, ... }: {
        imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

        boot.initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ata_piix" "ahci" "pata_jmicron" "firewire_ohci" "usb_storage" "usbhid" "sd_mod" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-intel" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/88effb11-d848-4813-b241-d644a8c088f0";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/4E10-0279";
          fsType = "vfat";
          options = [ "fmask=0022" "dmask=0022" ];
        };

        swapDevices = [ { device = "/dev/disk/by-uuid/80f6d7d7-6933-46cb-b091-921cd6b509cc"; } ];
        networking.useDHCP = lib.mkDefault true;
        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      })

      # Bootloader and system config
      ({ config, pkgs, ... }: {
        boot.loader.grub.enable = true;
        boot.loader.grub.device = "/dev/sda";
        boot.loader.grub.useOSProber = true;

        boot.swraid.enable = true;
        boot.swraid.mdadmConf = ''
          MAILADDR root
          ARRAY /dev/md0 metadata=1.2 UUID=c2372504:3357ee60:294af604:572ab5f2
        '';

        networking.hostName = "ancient";

        networking.firewall.allowedTCPPorts = [ 445 3000 8384 8096 5232 80 ];
        networking.firewall.allowedUDPPorts = [ 80 ];
        networking.firewall.enable = true;
        networking.firewall.allowPing = true;

        services.xserver.xkb = { layout = "us"; variant = ""; };

        # RAID mounts
        fileSystems."/mnt/syncthing" = {
          device = "/dev/disk/by-uuid/f37bb345-eeff-4ff4-863a-027b25e3587a";
          fsType = "ext4";
          options = [ "defaults" "nofail" ];
        };
        fileSystems."/mnt/video" = {
          device = "/dev/raid_storage_vg/video";
          fsType = "ext4";
          options = [ "defaults" "nofail" ];
        };
        fileSystems."/mnt/books" = {
          device = "/dev/raid_storage_vg/books";
          fsType = "ext4";
          options = [ "defaults" "nofail" ];
        };
        fileSystems."/mnt/git" = {
          device = "/dev/raid_storage_vg/git";
          fsType = "ext4";
          options = [ "defaults" "nofail" ];
        };

        # NVIDIA for Jellyfin transcoding
        nixpkgs.config.nvidia.acceptLicense = true;
        services.xserver.videoDrivers = [ "nvidia" ];
        hardware.nvidia = {
          modesetting.enable = true;
          nvidiaSettings = true;
          package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
        };

        environment.systemPackages = with pkgs; [
          neovim vim nvtopPackages.v3d ffmpeg-full jellyfin-web jellyfin-ffmpeg
        ];

        # Server feature configurations
        features.server = {
          gitea = {
            enable = true;
            httpPort = 3000;
            appName = "not your average git";
            domain = "localhost";
            rootUrl = "http://localhost:3000/";
            backupDir = "/mnt/git";
          };
          syncthing = {
            enable = true;
            user = "xam";
            group = "users";
            dataDir = "/mnt/syncthing/xam";
            configDir = "/mnt/syncthing/config";
            # SECURITY: 0.0.0.0 exposes web UI to network
            # Ancient is a server, so this may be intentional for LAN access
            # Consider adding firewall rules or authentication
            guiAddress = "0.0.0.0:8384";
          };
          samba = {
            enable = true;
            workgroup = "WORKGROUP";
            serverString = "ancient_samba";
            netbiosName = "ancient";
            allowedHosts = [ "100.64.0.0/10" "192.168.1.0/24" "127.0.0.1" "localhost" ];
            shares = {
              video = {
                path = "/mnt/video";
                browseable = "yes";
                "read only" = "yes";
                "write list" = "xam";
                "guest ok" = "yes";
                "create mask" = "0644";
                "directory mask" = "0755";
                "force user" = "xam";
              };
              books = {
                path = "/mnt/books";
                browseable = "yes";
                "read only" = "yes";
                "write list" = "xam";
                "guest ok" = "yes";
                "create mask" = "0644";
                "directory mask" = "0755";
                "force user" = "xam";
              };
            };
          };
          media = {
            enable = true;
            jellyfin = { enable = true; user = "jellyfin"; openFirewall = true; };
            radicale = { enable = true; port = 5232; authType = "none"; };
          };
        };
      })

      # Dendritic feature modules
      self.nixosModules.base
      self.nixosModules.users
      self.nixosModules.tailscale
      self.nixosModules.ssh
      self.nixosModules.dev
      self.nixosModules.editor
      self.nixosModules.gitea
      self.nixosModules.syncthing
      self.nixosModules.samba
      self.nixosModules.media
    ];
  };
}
