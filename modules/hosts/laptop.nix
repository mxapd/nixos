# modules/hosts/laptop.nix
# Laptop host configuration - uses KDE Plasma6

{ self, inputs, lib, ... }:

{
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs self; };
    modules = [
      # Hardware configuration
      ({ config, lib, pkgs, modulesPath, ... }: {
        imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

        boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-intel" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/8ed6994e-bbdf-49fb-a776-6bf848a44a74";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/7E37-AC12";
          fsType = "vfat";
          options = [ "fmask=0077" "dmask=0077" ];
        };

        swapDevices = [ { device = "/dev/disk/by-uuid/f57fcbce-3ed2-453e-be9e-857cb00c6b2b"; } ];
        networking.useDHCP = lib.mkDefault true;
        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      })

      # Bootloader and system config
      ({ config, pkgs, ... }: {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        networking.hostName = "laptop";
        networking.networkmanager.enable = true;

        nixpkgs.config.permittedInsecurePackages = [ "qtwebengine-5.15.19" ];

        programs.firefox.enable = true;
        services.flatpak.enable = true;
        services.mysql.enable = true;
        services.mysql.package = pkgs.mariadb;
        services.printing.enable = true;
        services.desktopManager.plasma6.enable = true;
        services.power-profiles-daemon.enable = false;
        services.auto-cpufreq.enable = true;

        services.syncthing = {
          enable = true;
          user = "xam";
          group = "users";
          openDefaultPorts = true;
          dataDir = "/home/xam/Documents";
          configDir = "/home/xam/.syncthing";
          guiAddress = "0.0.0.0:8384";
        };

        age.identityPaths = [ "/home/xam/.ssh/id_ed25519" "/home/xam/.ssh/id_rsa" ];

        environment.systemPackages = with pkgs; [
          blueman gcc rustup piper zip gotop rar qbittorrent egl-wayland git python3 obsidian kitty neofetch
          slack spotify vscodium libreoffice syncthing ripgrep-all ripgrep zoxide tmux libgcc zig thinkfan
          nodejs_22 gnumake mariadb unzip lunarvim teamspeak3 wl-clipboard discord-canary htop jdk21 gradle
          auto-cpufreq grim slurp wofi waybar font-awesome gnome-calendar mako libnotify hyprshot playerctl
          lm_sensors brightnessctl
        ];

        hardware.graphics = { enable = true; enable32Bit = true; };
      })

      # External flake modules
      inputs.agenix.nixosModules.default
      inputs.stylix.nixosModules.stylix

      # Dendritic feature modules
      self.nixosModules.base
      self.nixosModules.users
      self.nixosModules.stylix
      self.nixosModules.fonts
      self.nixosModules.tailscale
      self.nixosModules.ssh
      self.nixosModules.audio
      self.nixosModules.hyprland
      self.nixosModules.bluetooth
      self.nixosModules.shell
      self.nixosModules.dev
      self.nixosModules.editor
    ];
  };

  # Home Manager configuration for laptop (KDE - no hyprland)
  flake.homeConfigurations.laptop = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      # Shell base config (username, home directory, packages, programs)
      self.homeModules.shell
      
      # Zsh configuration
      self.homeModules.zsh
      
      # Git configuration
      self.homeModules.git
      
      # Nixvim editor
      self.homeModules.editors.nixvim
    ];
  };
}
