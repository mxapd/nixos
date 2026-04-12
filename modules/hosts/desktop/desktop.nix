# modules/hosts/desktop/desktop.nix
# Desktop host configuration
# Imports: hardware-configuration.nix + system configuration + home configuration

{ self, inputs, pkgs, lib, ... }:

{
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs self lib; };
    modules = [
      # Hardware configuration
      ./hardware-configuration.nix

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
      self.nixosModules.hyprland
      self.nixosModules.gaming
      self.nixosModules.nvidia
      self.nixosModules.shell
      self.nixosModules.dev
      self.nixosModules.editor
    ];
  };

  # Home Manager configuration
  flake.homeConfigurations.desktop = inputs.home-manager.lib.homeManagerConfiguration {
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
      
      # Hyprland desktop
      self.homeModules.desktops.hyprland
    ];
  };
}
