{ ... }:

{
  flake.nixosModules.caddy = { config, ... }: {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.caddy = {
      enable = true;

      virtualHosts."ancient" = {
        extraConfig = ''
          tls internal

          # Jellyfin — https://ancient/jellyfin
          handle_path /jellyfin/* {
            reverse_proxy localhost:8096
          }
          redir /jellyfin /jellyfin/

          # Gitea — https://ancient/git
          handle_path /git/* {
            reverse_proxy localhost:3000
          }
          redir /git /git/

          # Radicale CalDAV/CardDAV — https://ancient/radicale
          handle_path /radicale/* {
            reverse_proxy localhost:5232 {
              header_up X-Script-Name /radicale
            }
          }
          redir /radicale /radicale/

          # Prowlarr — https://ancient/prowlarr
          # TODO: enable app-level auth in Prowlarr settings
          handle_path /prowlarr/* {
            reverse_proxy localhost:9696
          }
          redir /prowlarr /prowlarr/

          # Lidarr — https://ancient/lidarr
          # TODO: enable app-level auth in Lidarr settings
          handle_path /lidarr/* {
            reverse_proxy localhost:8686
          }
          redir /lidarr /lidarr/

          # qBittorrent — https://ancient/torrent
          # TODO: enable app-level auth in qBittorrent Web UI settings
          handle_path /torrent/* {
            reverse_proxy localhost:8081
          }
          redir /torrent /torrent/

          # Syncthing — https://ancient/sync
          handle_path /sync/* {
            reverse_proxy localhost:8384
          }
          redir /sync /sync/

          # Default landing page
          redir / /jellyfin
        '';
      };
    };
  };
}
