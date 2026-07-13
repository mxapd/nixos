{ ... }:
{
  flake.nixosModules.boot = { ... }: {
    boot = {
      binfmt.emulatedSystems = [ "aarch64-linux" ];
      loader = {
	systemd-boot.enable = true;
	efi.canTouchEfiVariables = true;
      };
    };
  };
}
