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

      # This opens 8081 and 6881. See firewall note below.
      openFirewall = true;
    };
  };
}
