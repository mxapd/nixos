# modules/hardware/nvidia.nix
# NVIDIA GPU configuration (NixOS system level)

{ self, inputs, ... }:

{
  flake.nixosModules.nvidia = { config, pkgs, ... }:
    {
      # NVIDIA driver
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

        # Driver package - use beta for latest features
        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };

      # NVIDIA container toolkit (for Docker/Podman GPU support)
      hardware.nvidia-container-toolkit.enable = true;

      # Enable graphics
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
}
