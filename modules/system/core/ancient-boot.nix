{ ... }:
{
  flake.nixosModules.ancient-boot = { ... }: {
    boot = {
      loader.grub = {
        enable = true;
        device = "/dev/disk/by-id/ata-CT240BX500SSD1_2217E62C4F38";
        useOSProber = false;
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
