# modules/desktop/gaming.nix
# Gaming configuration (NixOS system level)

{ self, inputs, ... }:

{
  flake.nixosModules.gaming = { config, pkgs, ... }:
  {
    # Steam
    programs.steam = {
      enable = true;
      # Open ports in firewall for Steam
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    # GameMode for performance optimization
    programs.gamemode = {
      enable = true;
      # Settings can be customized here
      settings = {
        general = {
          # Performance governor
          desiredgov = "performance";
          # Reduce niceness of game processes
          renice = 10;
        };
      };
    };

    # Gamescope (Steam's micro-compositor)
    programs.gamescope = {
      enable = true;
      # Use latest gamescope
      args = [ "--rt" "--prefer-vk-device" "--adaptive-sync" ];
    };

    # Additional gaming packages
    environment.systemPackages = with pkgs; [
      # Minecraft
      prismlauncher

      # Game utilities
      lutris
      wine
      winetricks

      # Performance overlay
      mangohud

      # Controller support
      sc-controller
    ];

    # udev rules for controllers
    services.udev.packages = with pkgs; [
      game-devices-udev-rules
      sc-controller
    ];

    # Virtualization for some games
    virtualisation.waydroid.enable = false;  # Set to true if you want Android games
  };
}
