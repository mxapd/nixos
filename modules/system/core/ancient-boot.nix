{ ... }:
{
  flake.nixosModules.ancient-boot = { ... }: {
    boot = {
      loader.grub = {
	enable = true;
	device = "/dev/sda";
	useOSProber = true;
      };

      swraid = {
	enable = true;
	mdadmConf = ''
	  MAILADDR root
	  ARRAY /dev/md0 metadata=1.2 UUID=c2372504:3357ee60:294af604:572ab5f2
	'';
      };
    };
  };
}
