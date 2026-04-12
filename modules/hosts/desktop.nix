# modules/hosts/desktop.nix
# Desktop host configuration - complete system definition

{ self, inputs, ... }:

{
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs self; };
    modules = [
      # Hardware configuration
      ({ config, lib, pkgs, modulesPath, ... }: {
        imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

        boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/64bfd218-e0b4-4558-bf90-5cb9ddb617be";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/92B2-E445";
          fsType = "vfat";
          options = [ "fmask=0077" "dmask=0077" ];
        };

        swapDevices = [ ];
        networking.useDHCP = lib.mkDefault true;
        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      })

      # Bootloader and system config
      ({ config, pkgs, ... }: {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];

        networking.hostName = "desktop";
        networking.nameservers = [ "8.8.8.8" "100.42.0.1" ];

        programs.direnv.enable = true;
        programs.firefox.enable = true;

        services.flatpak.enable = true;
        services.mysql.enable = true;
        services.mysql.package = pkgs.mariadb;
        services.printing.enable = true;
        
        services.syncthing = {
          enable = true;
          user = "xam";
          group = "users";
          dataDir = "/home/xam/Documents/";
          configDir = "/home/xam/.syncthing/";
          guiAddress = "0.0.0.0:8384";
        };

        services.tailscale = {
          enable = true;
          useRoutingFeatures = "client";
        };

        virtualisation.virtualbox.host.enable = true;
        virtualisation.virtualbox.host.enableExtensionPack = true;
        users.extraGroups.vboxusers.members = [ "xam" ];

        environment.systemPackages = with pkgs; [
          inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
          (pkgs.callPackage ../../custom-pkgs/nixos-warnings.nix { })
          kitty wofi font-awesome gnome-calendar hyprshot playerctl nautilus pavucontrol piper gotop
          qbittorrent prismlauncher fastfetch slack gamescope spotify libreoffice syncthing ripgrep-all
          tmux zoxide teamspeak3 wl-clipboard discord-canary htop mariadb jdk21 gradle vlc blueman fzf bun
          grim slurp libnotify wasm-bindgen-cli cargo-leptos rustc pkg-config cargo-generate lsof rustlings
          tldr runelite zip rar rustup clang libgcc zig nodejs_22 gnumake unzip git python3
        ];
      })

      # Import legacy modules
      ../../modules/_legacy/postgresql.nix
      ../../modules/_legacy/torzu.nix

      # External flake modules
      inputs.stylix.nixosModules.stylix

      # Dendritic feature modules
      self.nixosModules.base
      self.nixosModules.users
      self.nixosModules.stylix
      self.nixosModules.fonts
      self.nixosModules.tailscale
      self.nixosModules.ssh
      self.nixosModules.audio
      self.nixosModules.desktop
      self.nixosModules.gaming
      self.nixosModules.hardware
      self.nixosModules.shell
      self.nixosModules.dev
      self.nixosModules.editor
    ];
  };

  # Home Manager configuration for desktop
  # Each .nix file is imported and contributes to the home-manager config
  flake.homeConfigurations.desktop = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      # User config
      {
        home = {
          username = "xam";
          homeDirectory = "/home/xam";
          stateVersion = "25.11";
          sessionVariables = {
            OBSIDIAN_VAULT = "/home/xam/Documents/obsidian/";
            EDITOR = "nvim";
            BROWSER = "firefox";
          };
        };
      }

      # Shell: zsh, tmux, kitty, zoxide
      {
        programs.zsh = {
          enable = true;
          syntaxHighlighting.enable = true;
          shellAliases = {
            mount-ancient = "sudo mount -t cifs //192.168.1.204/video /mnt/ancient_share/video -o username=xam,uid=1000,gid=100,rw";
            nd = "nix develop";
            ns = "nix shell";
            check = "nix flake check --impure";
          };
          oh-my-zsh = {
            enable = true;
            plugins = [ "git" ];
            theme = "wedisagree";
          };
        };
        programs.zoxide.enable = true;
        programs.zoxide.enableZshIntegration = true;
        programs.tmux.enable = true;
        programs.kitty.enable = true;
      }

      # Git
      {
        programs.git = {
          enable = true;
          userName = "xam";
          userEmail = "m.porseryd@gmail.com";
        };
      }

      # Editor (nixvim)
      {
        programs.nixvim = {
          enable = true;
          globals = {
            mapleader = " ";
            maplocalleader = " ";
          };
          opts = {
            number = true;
            relativenumber = true;
            shiftwidth = 2;
            clipboard = "unnamedplus";
          };
        };
      }

      # Desktop (hyprland, waybar, mako)
      {
        programs.waybar.enable = true;
        services.mako.enable = true;
        wayland.windowManager.hyprland = {
          enable = true;
          xwayland.enable = true;
        };
        home.sessionVariables.NIXOS_OZONE_WL = "1";
      }
    ];
  };
}
