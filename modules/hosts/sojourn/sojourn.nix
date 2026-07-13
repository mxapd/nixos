{ inputs, ... }:

{
  flake.nixosConfigurations.sojourn =
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        inputs.self.nixosModules.boot
        inputs.self.nixosModules.sojourn-hardware
        inputs.self.nixosModules.user-xam

        inputs.self.nixosModules.audio
        inputs.self.nixosModules.bluetooth
        inputs.self.nixosModules.networking
        inputs.self.nixosModules.fonts
        inputs.self.nixosModules.locale
        inputs.self.nixosModules.sops
        inputs.self.nixosModules.nix-maintenance
        inputs.self.nixosModules.ssh
        inputs.self.nixosModules.sudo
        inputs.self.nixosModules.nvidia
        inputs.self.nixosModules.stylix
        inputs.self.nixosModules.unfree

        inputs.self.nixosModules.home-manager
        inputs.self.nixosModules.hm-xam
        inputs.self.nixosModules.hyprland
        inputs.self.nixosModules.hyprmoon
        inputs.self.nixosModules.waybar

        inputs.self.nixosModules.ssh-authorized-keys
        inputs.self.nixosModules.ssh-access-sojourn # TODO generate keypair and add to secrets.yaml
        inputs.self.nixosModules.git-access

        inputs.self.nixosModules.syncthing
        inputs.self.nixosModules.tailscale

        # inputs.self.nixosModules.virtualbox
        inputs.self.nixosModules.torzu
        inputs.self.nixosModules.flatpak
        inputs.self.nixosModules.steam
        inputs.self.nixosModules.firefox

	({ pkgs, inputs, ... }:	{
	  networking.hostName = "sojourn"; # other options: nomad, voyager, pilgrim
	  
	  # Bootloader.
	  boot.loader.systemd-boot.enable = true;
	  boot.loader.efi.canTouchEfiVariables = true;

	  xdg.portal = {
	    enable = true;
	    xdgOpenUsePortal = true;
	    wlr.enable = false;
	    config = {
	      common.default = [ "gtk" ];
	      hyprland.default = [ "gtk" "hyprland" ];
	    };
	    configPackages = [
	      pkgs.xdg-desktop-portal-gtk
	      pkgs.xdg-desktop-portal
	    ];
	    extraPortals = [
	      pkgs.xdg-desktop-portal-gtk
	    ];
	  };

	  console.keyMap = "sv-latin1";
	  services = {
	    # xserver.libinput.enable = true;
	    xserver.enable = true;
	    xserver.xkb = {
	      layout = "se";
	      variant = "";
	    };
	  };

	  environment.systemPackages = with pkgs; [
	    blueman
	    gcc
	    rustup
	    piper
	    zip
	    gotop
	    rar
	    git
	    python3
	    obsidian
	    kitty
	    slack
	    fastfetch
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
	    wl-clipboard
	    discord-canary
	    htop
	    mariadb
	    jdk21
	    gradle

	    auto-cpufreq
	    grim
	    slurp
	    kitty
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

	  services.flatpak = {
	    enable = true;
	  };

	  hardware = {
	    graphics = {
	      enable = true;
	      enable32Bit = true;
	    };

	    bluetooth.enable = true;
	    bluetooth.powerOnBoot = true;

	    pulseaudio.enable = false;
	  };

	  services.syncthing = {
	    enable = true;
	    user = "xam";
	    group = "users";
	    openDefaultPorts = true;
	    dataDir = "/home/xam/Documents";
	    configDir = "/home/xam/.syncthing";
	    guiAddress = "0.0.0.0:8384";
	  };

	  security.polkit.enable = true;

	  system.stateVersion = "25.11";
	})
      ];
    };
}
