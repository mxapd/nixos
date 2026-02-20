# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "ancient"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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


  networking.firewall.allowedTCPPorts = [
    445
    3000 # for gitea
    2222 # also for gitea but not sure if needed
    8384 # Syncthing Web UI
    8096 # jellyfin    
    80
    # 22000 # Syncthing sync port (TCP, usually opened by #yncthing.openFirewall = true)
  ];
  networking.firewall.allowedUDPPorts = [
      80
    # 21027 # Syncthing discovery port (UDP, usually opened by syncthing.openFirewall = true)
    #8096 # jellyfin    
  ];
  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xam = {
    isNormalUser = true;
    description = "Xam";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    vim


    nvtopPackages.v3d
    ffmpeg-full
    jellyfin-web
    jellyfin-ffmpeg
  ];

  services.samba = {
    enable = true; 
    settings = {
      global = {
        # - General -
        "workgroup" = "WORKGROUP";
	"server string" = "ancient_samba";
        "netbios name" = "ancient";
 	
	# - Security -	
	"security" = "user";
	"hosts allow" = "100.64.0.0/10 192.168.1.0/24 127.0.0.1 localhost"; # add tailscale ip
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
	"use sendfile" = "yes";

	# note: localhost is the ipv6 localhost ::1
	# note: "use sendfile" - uses the kernels sendfile() to transfer files directly from disk to network
      };

      # - Shares -	
      "video" = {
        "path" = "/mnt/video";
        "browseable" = "yes";
        "read only" = "yes";
	"write list" = "xam";
        "guest ok" = "yes"; 
        "create mask" = "0644"; # rw-r--r--
        "directory mask" = "0755"; # rwxr-xr-x
        "force user" = "xam";
      };

      "books" = {
        "path" = "/mnt/books";
        "browseable" = "yes";
        "read only" = "yes";
	"write list" = "xam";
        "guest ok" = "yes"; 
        "create mask" = "0644"; # rw-r--r--
        "directory mask" = "0755"; # rwxr-xr-x
        "force user" = "xam";
      };
    };
  };
  
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };


  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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

  # mount video lv
  fileSystems."/mnt/video" = {
    device = "/dev/raid_storage_vg/video";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };
  
  # mount books lv
   fileSystems."/mnt/books" = {
    device = "/dev/raid_storage_vg/books";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  }; 

  # mount git
   fileSystems."/mnt/git" = {
    device = "/dev/raid_storage_vg/git";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "jellyfin";
  };
  
  services.syncthing = {
    enable  = true;
    user = "xam";
    group = "users";
    openDefaultPorts = true;
    dataDir = "/mnt/syncthing/xam";
    configDir = "/mnt/syncthing/config";
    guiAddress = "0.0.0.0:8384";
  };

  services.gitea = {
    enable = true;
    appName = "not your average git (it's way worse)";
    user = "gitea";

    httpPort = 3000;
    domain = "localhost";
    rootUrl = "http://localhost:3000/";
 
    # database for metadata (users, keys and stuff)
    database = {
      type = "sqlite3";
      path = "/var/lib/gitea/data/gitea.db";
    };
  };

 
  systemd.services.gitea-backup = {
    description = "Mirror Gitea data to HDD backup directory";
    after = [ "gitea.service" ];
    serviceConfig = {
      User = "root";
      Type = "oneshot";
      ExecStart = [ 
	"/run/current-system/sw/bin/mkdir -p /mnt/git/"
	"/run/current-system/sw/bin/rsync -a --delete /var/lib/gitea/ /mnt/git/''"
      ];    
    };
  };

  systemd.timers.gitea-backup = {
    description = "Daily Gitea rsync backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "10m";
    };
  };

  nixpkgs.config.nvidia.acceptLicense = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  };
}
