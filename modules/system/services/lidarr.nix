{ ... }:
{
  flake.nixosModules.lidarr = { inputs, pkgs, ... }: {
    imports = [ inputs.self.nixosModules.prowlarr ];

    users.groups.media = { };

    users.users.lidarr = {
      isSystemUser = true;
      group = "media";
      home = "/var/lib/lidarr";
      createHome = true;
      description = "Lidarr Service User";
    };

    services.lidarr = {
      enable = true;
      user = "lidarr";
      group = "media";
      dataDir = "/var/lib/lidarr";
      openFirewall = true;
    };

    services.qbittorrent = {
      enable = true;

      user = "qbittorrent";
      group = "media";
      profileDir = "/var/lib/qbittorrent";

      webuiPort = 8081;
      torrentingPort = 6881;

      # This opens 8081 and 6881.
      openFirewall = true;
    };

    systemd.tmpfiles.rules = [
      "d /mnt/media/downloads       		2775 qbittorrent media -"
      "d /mnt/media/downloads/lidarr 		2775 qbittorrent media -"
      "d /mnt/media/downloads/incomplete 	2775 qbittorrent media -"
      
      "d /mnt/media/music/lidarr     		2775 lidarr      media -"
    ];
  };
}
