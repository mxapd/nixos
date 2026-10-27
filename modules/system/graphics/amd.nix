{ ... }:
{
  flake.nixosModules.amd = { pkgs, ... }:

    {
      services.xserver.videoDrivers = [ "amdgpu" ];
      nixpkgs.config.rocmSupport = true;

      environment.variables.AMD_VULKAN_ICD = "RADV";

      hardware = {
	graphics = {
	  enable = true;
	  enable32Bit = true;
	};

	amdgpu = {
	  initrd.enable = true;

	  # Only if you want OpenCL (e.g. darktable, some compute stuff).
	  # ROCm support for RDNA4 (gfx1201) is still maturing, so leave off
	  # unless you actually need it.
	  # opencl.enable = true;
	};
      };

      boot.kernelModules = [ "amdgpu" ];
    };
}
