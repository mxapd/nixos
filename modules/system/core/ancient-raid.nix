{ ... }:
{
  flake.nixosModules.ancient-raid = { ... }: {
    boot.swraid = {
      enable = true;
      mdadmConf = ''
	MAILADDR root
	ARRAY /dev/md0 metadata=1.2 UUID=c2372504:3357ee60:294af604:572ab5f2
      '';
    };

    # mount syncthing lv
    fileSystems."/mnt/syncthing" = {
      device = "/dev/disk/by-uuid/f37bb345-eeff-4ff4-863a-027b25e3587a";
      fsType = "ext4";
      options = [ "defaults" "nofail" ];
    };

    # mount media lv
    fileSystems."/mnt/media" = {
      device = "/dev/raid_storage_vg/media";
      fsType = "ext4";
      options = [ "defaults" "nofail" ];
    };

    # mount git
    fileSystems."/mnt/git" = {
      device = "/dev/raid_storage_vg/git";
      fsType = "ext4";
      options = [ "defaults" "nofail" ];
    };
  };
}
