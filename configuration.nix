# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# 
{ config, pkgs, inputs, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
  ];


  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/stylix.nix
      ./modules/postgresql.nix
    ];

# Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];

  nix.settings.experimental-features = [ "nix-command" "flakes"];
  
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
    
    hosts = {
      "10.42.0.89" = ["nextcloud.yggdrasil.com" "firefly.yggdrasil.com" "importer.yggdrasil.com" "gitea.yggdrasil.com"];
    };

    hostName = "nixos";
    networkmanager.enable = true;
    nameservers = [ "8.8.8.8" "10.42.0.1"];
#wireless.enable = true;
#proxy.default = "http://user:password@proxy:port/";
#proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  time.timeZone = "Europe/Stockholm";
  
# Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

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
# If you want to use JACK applications, uncomment this
#jack.enable = true;

# use the example session manager (no others are packaged yet so this is enabled by default,
# no need to redefine it in your config for now)
#media-session.enable = true;
    };
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
    ratbagd.enable = true;
    openssh = {
      enable = true;
    };
    xserver.videoDrivers = ["nvidia"];
  };

  programs = {
    zsh.enable = true;
#noisetorch.enable = true;
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

  users.users.xam = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "xam";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      #zulu25
      tailscale
      cargo
      openssl
      wasm-bindgen-cli
      cargo-leptos
      rustc
      pkg-config
      cargo-generate
      openssl
      lsof
      rustlings
      pgadmin4-desktopmode
      tldr
      tree
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
      #egl-wayland
      git
      python3
      prismlauncher
      obsidian
      kitty
      fastfetch
      slack
      gamescope
      spotify
      vscodium
      libreoffice
      #syncthing
      ripgrep-all
      zoxide
      tmux
      libgcc
      zig
      nodejs_22
      gnumake
      unzip
      lunarvim
      teamspeak_client
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
  };

  nixpkgs.config.allowUnfree = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  
  users.extraGroups.vboxusers.members = [ "xam" ];
  
  #virtualisation.virtualbox.guest.enable = true;
  #virtualisation.virtualbox.guest.dragAndDrop = true;
  
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

    pulseaudio.enable = false;
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
  system.stateVersion = "24.05"; # Did you read the comment?
}
