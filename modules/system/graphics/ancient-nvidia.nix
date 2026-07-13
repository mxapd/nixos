{ ... }:
{
  flake.nixosModules.ancient-nvidia = { pkgs, config, ... }: {
    
    environment.systemPackages = with pkgs; [
      nvtopPackages.v3d
    ];

    nixpkgs.config.nvidia.acceptLicense = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    
    hardware.nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    };
  };
}
