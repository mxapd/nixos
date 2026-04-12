# modules/desktop/hardware.nix
# Hardware-specific configuration (NixOS system level)

{ self, inputs, ... }:

{
  flake.nixosModules.hardware = { config, pkgs, ... }:
  {
    # NVIDIA configuration (for desktop with NVIDIA GPU)
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # Modesetting is required
      modesetting.enable = true;

      # Power management (experimental)
      powerManagement.enable = false;
      powerManagement.finegrained = false;

      # Open kernel module (not nouveau)
      open = true;

      # Nvidia settings menu (nvidia-settings)
      nvidiaSettings = true;

      # Driver package
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    # NVIDIA container toolkit (for Docker/Podman GPU support)
    hardware.nvidia-container-toolkit.enable = true;

    # Enable graphics
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };

    # Bluetooth manager
    services.blueman.enable = true;

    # Additional hardware utilities
    environment.systemPackages = with pkgs; [
      # Bluetooth tools (blueman is the GUI manager, enabled above as service)
      bluez

      # Input device configuration
      piper  # GTK application to configure gaming mice
      # Note: libratbag provides ratbagd daemon (enabled as service below)
    ];

    # ratbagd for gaming mouse configuration
    services.ratbagd.enable = true;

    # CPU emulation support (if needed)
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    nix.settings.extra-platforms = [ "aarch64-linux" ];
  };
}
