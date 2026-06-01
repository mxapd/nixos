{ config, pkgs, inputs, ... }:

{

  imports =
    [ 
      ./hardware-configuration.nix
      ./../../modules/postgresql.nix
      ./../../modules/torzu.nix
      ./../../modules/obs.nix
    ];
  
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 5900 ]; # wayvrc
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # disable automatic enabling of virtualization. i think i added this because virtualbox uses their own kernel modules
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = false;
    config = {
      common.default = ["gtk"];
      hyprland.default = ["gtk" "hyprland"];
    };
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
	pkgs.xdg-desktop-portal
    ];
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      #pkgs.xdg-desktop-portal-hyprland
    ];
  };

  networking = {
    hostName = "desktop";
    nameservers = [ "8.8.8.8" "100.42.0.1"];
  };

  programs.direnv.enable = true;
  
  console.keyMap = "sv-latin1";
  
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = [ "aarch64-linux" ];

  services = {
    flatpak.enable = true; 
    
    xserver.enable = true;
    xserver.xkb = {
      layout = "se";
      variant = "";
    };
    xserver.videoDrivers = ["nvidia"];

    mysql.enable = true;
    mysql.package = pkgs.mariadb;
    
    printing.enable = true;
    
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    
    displayManager.sddm.enable = true;
    
    ratbagd.enable = true; # for gaming mice, logitech superlight
    
    openssh = {
      enable = true;
    };

    syncthing = {
      enable  = true;
      user = "xam";
      group = "users";
      dataDir = "/home/xam/Documents/";
      configDir = "/home/xam/.syncthing/";
      guiAddress = "0.0.0.0:8384";
    };
  };

  programs = {
    gnupg = {
      agent.enable = true;
    };

    zsh.enable = true;
    firefox.enable = true;
    
    steam.enable = true;
    gamemode.enable = true;
    
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };

  security.rtkit.enable = true;
  
  virtualisation.docker = {
    enable = true;
  };
  
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  #virtualisation.virtualbox.guest.enable = true;
  #virtualisation.virtualbox.guest.dragAndDrop = true;
  
  users.extraGroups.vboxusers.members = [ "xam" ];

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages."${pkgs.system}".default
    
    (pkgs.callPackage ../../custom-pkgs/nixos-warnings.nix { })

    wayvnc
    docker
    pi-coding-agent
    grim
    slurp
    kitty
    wofi
    waybar
    font-awesome
    gnome-calendar
    libnotify
    hyprshot
    playerctl
    wasm-bindgen-cli
    cargo-leptos
    rustc
    pkg-config
    cargo-generate
    lsof
    rustlings
    tldr
    runelite
    nautilus
    pavucontrol
    rustup
    clang
    piper
    zip
    gotop
    rar
    qbittorrent
    python3
    prismlauncher
    slack
    gamescope
    spotify
    libreoffice
    syncthing
    ripgrep-all
    tmux
    libgcc
    zig
    nodejs_22
    gnumake
    unzip
    wl-clipboard
    discord-canary
    htop
    mariadb
    jdk21
    gradle
    vlc
    blueman
    bun
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;
      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;
      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = true;
      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;
      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    nvidia-container-toolkit.enable = true;

    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  security.polkit.enable = true;
  system.stateVersion = "25.11"; 
}
