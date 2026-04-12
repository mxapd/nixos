# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader - hardware specific
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # RAID configuration
  boot.swraid.enable = true; 
  boot.swraid.mdadmConf = ''
    MAILADDR root
    ARRAY /dev/md0 metadata=1.2 UUID=c2372504:3357ee60:294af604:572ab5f2
  '';

  # Host-specific networking
  networking.hostName = "ancient";

  # Firewall - server-specific ports
  networking.firewall.allowedTCPPorts = [
    445     # Samba
    3000    # Gitea
    8384    # Syncthing Web UI
    8096    # Jellyfin
    5232    # Radicale
    80
  ];
  networking.firewall.allowedUDPPorts = [
    80
  ];
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  # Console keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # File system mounts - hardware specific
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

  # Server-specific packages
  environment.systemPackages = with pkgs; [
    neovim
    vim
    nvtopPackages.v3d
    ffmpeg-full
    jellyfin-web
    jellyfin-ffmpeg
  ];

  # NVIDIA for Jellyfin transcoding
  nixpkgs.config.nvidia.acceptLicense = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  };
}
