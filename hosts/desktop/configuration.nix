{ config, pkgs, inputs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./../../modules/postgresql.nix
      ./../../modules/torzu.nix
    ];

  # Bootloader - hardware specific
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Hardware-specific kernel params
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];

  # Host-specific networking
  networking = {
    hostName = "desktop";
    nameservers = [ "8.8.8.8" "100.42.0.1"];
  };

  # User preferences
  programs.direnv.enable = true;
  
  # Host-specific services
  services = {
    flatpak.enable = true; 
    mysql.enable = true;
    mysql.package = pkgs.mariadb;
    printing.enable = true;
    
    # Syncthing with host-specific paths
    syncthing = {
      enable  = true;
      user = "xam";
      group = "users";
      dataDir = "/home/xam/Documents/";
      configDir = "/home/xam/.syncthing/";
      guiAddress = "0.0.0.0:8384";
    };
  };

  # User applications
  programs.firefox.enable = true;

  # Virtualization
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "xam" ];
  
  # Tailscale with host-specific routing
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages."${pkgs.system}".default
    (pkgs.callPackage ../../custom-pkgs/nixos-warnings.nix { })

    # Desktop applications
    kitty
    wofi
    font-awesome
    gnome-calendar
    hyprshot
    playerctl
    nautilus
    pavucontrol
    piper
    gotop
    qbittorrent
    prismlauncher
    fastfetch
    slack
    gamescope
    spotify
    libreoffice
    syncthing
    ripgrep-all
    tmux
    zoxide
    teamspeak3
    wl-clipboard
    discord-canary
    htop
    mariadb
    jdk21
    gradle
    vlc
    blueman
    fzf
    bun

    # Development tools
    grim
    slurp
    libnotify
    wasm-bindgen-cli
    cargo-leptos
    rustc
    pkg-config
    cargo-generate
    lsof
    rustlings
    tldr
    runelite
    zip
    rar
    rustup
    clang
    libgcc
    zig
    nodejs_22
    gnumake
    unzip
    git
    python3
  ];
}
