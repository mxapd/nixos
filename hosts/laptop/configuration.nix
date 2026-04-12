# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').
#
{ config, pkgs, inputs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Agenix SSH identity for secrets
  age.identityPaths = [ 
    "/home/xam/.ssh/id_ed25519" 
    "/home/xam/.ssh/id_rsa"
  ];

  # Laptop-specific package exceptions
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Host-specific networking
  networking = {
    hostName = "laptop";
    networkmanager.enable = true;
  };

  # Time and locale handled by dendritic features/base
  # Override laptop-specific packages here
  
  # Host-specific services
  services = {
    mysql.enable = true;
    mysql.package = pkgs.mariadb;
    printing.enable = true;
    
    # Laptop has Plasma6 instead of just Hyprland
    desktopManager.plasma6.enable = true;
    
    # Disable power-profiles-daemon to avoid conflict with auto-cpufreq
    power-profiles-daemon.enable = false;
    
    # Syncthing with laptop-specific paths
    syncthing = {
      enable = true;
      user = "xam";
      group = "users";
      openDefaultPorts = true;
      dataDir = "/home/xam/Documents";
      configDir = "/home/xam/.syncthing";
      guiAddress = "0.0.0.0:8384";
    };
    
    # Laptop power management
    auto-cpufreq.enable = true;
  };

  # User applications
  programs.firefox.enable = true;

  services.flatpak.enable = true;

  # Laptop-specific packages
  environment.systemPackages = with pkgs; [
    # System tools
    blueman
    gcc
    rustup
    piper
    zip
    gotop
    rar
    qbittorrent
    egl-wayland
    git
    python3
    obsidian
    kitty
    neofetch
    slack
    spotify
    vscodium
    libreoffice
    syncthing
    ripgrep-all
    ripgrep
    zoxide
    tmux
    libgcc
    zig
    thinkfan
    nodejs_22
    gnumake
    mariadb
    unzip
    lunarvim
    teamspeak3
    wl-clipboard
    discord-canary
    htop
    jdk21
    gradle

    # Desktop environment
    auto-cpufreq
    grim
    slurp
    wofi
    waybar
    font-awesome
    gnome-calendar
    mako
    libnotify
    hyprshot
    playerctl
    lm_sensors
    brightnessctl
  ];

  # Laptop hardware settings
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };
}
