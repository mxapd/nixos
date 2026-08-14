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
      openFirewall = false;
    };

    services.qbittorrent = {
      enable = true;

      user = "qbittorrent";
      group = "media";
      profileDir = "/var/lib/qbittorrent";

      webuiPort = 8081;
      torrentingPort = 6881;

      # Served behind Caddy at https://ancient/lidarr and https://ancient/torrent.
      # qBittorrent Web UI firewall is closed; torrenting port remains open.
      openFirewall = false;
    };

    # TODO: Set URL bases in the apps after first run:
    # - Lidarr: Settings -> General -> URL Base -> /lidarr
    # - qBittorrent: Options -> Web UI -> Use HTTPS instead of HTTP -> off,
    #                then set "Web UI" path to /torrent under "Web UI" settings

    systemd.tmpfiles.rules = [
      "d /mnt/media/downloads       		2775 qbittorrent media -"
      "d /mnt/media/downloads/lidarr 		2775 qbittorrent media -"
      "d /mnt/media/downloads/incomplete 	2775 qbittorrent media -"
      
      "d /mnt/media/music/lidarr     		2775 lidarr      media -"
    ];
  };
}
