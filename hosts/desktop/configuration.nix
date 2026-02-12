# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# 
{ config, pkgs, inputs, ... }:

{

  imports =
    [ 
      ./hardware-configuration.nix
      ./../../home/home.nix
      ./../../modules/postgresql.nix
      ./../../modules/torzu.nix
    ];

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

  services = {
    flatpak.enable = true; 
    # xserver.libinput.enable = true;
    xserver.enable = true;
    xserver.xkb = {
      layout = "se";
      variant = "";
    };
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
    ratbagd.enable = true;
    openssh = {
      enable = true;
    };
    xserver.videoDrivers = ["nvidia"];

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
    zsh.enable = true;
    firefox.enable = true;
    steam.enable = true;
    gamemode.enable = true;

    hyprland = {
      enable = true;
      # set the flake package
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # make sure to also set the portal package, so that they are in sync
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };

  security.rtkit.enable = true;
  
  nixpkgs.config.allowUnfree = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  #virtualisation.virtualbox.guest.enable = true;
  #virtualisation.virtualbox.guest.dragAndDrop = true;
  
  users.extraGroups.vboxusers.members = [ "xam" ];
 
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  environment.systemPackages = with pkgs; [
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
    pgadmin4-desktopmode
    tldr
    runelite
    nautilus
    pavucontrol
    calibre
    rustup
    clang
    ollama-cuda
    piper
    zip
    gotop
    rar
    qbittorrent
    git
    python3
    prismlauncher
    obsidian
    kitty
    fastfetch
    slack
    gamescope
    spotify
    libreoffice
    syncthing
    ripgrep-all
    zoxide
    tmux
    libgcc
    zig
    nodejs_22
    gnumake
    unzip
    lunarvim
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
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
