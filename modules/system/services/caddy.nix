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
            reverse_proxy localhost:5232
          }
          redir /radicale /radicale/

          # Prowlarr — https://ancient/prowlarr
          # CHANGE THIS PASSWORD: run `caddy hash-password` and replace the hash below.
          handle_path /prowlarr/* {
            basicauth {
              xam $2a$14$ng4oteLs0gbk1aMgWEYdC.zzSI9trQcldbn0/9GCNFWV0axr7hWae
            }
            reverse_proxy localhost:9696
          }
          redir /prowlarr /prowlarr/

          # Lidarr — https://ancient/lidarr
          handle_path /lidarr/* {
            basicauth {
              xam $2a$14$ng4oteLs0gbk1aMgWEYdC.zzSI9trQcldbn0/9GCNFWV0axr7hWae
            }
            reverse_proxy localhost:8686
          }
          redir /lidarr /lidarr/

          # qBittorrent — https://ancient/torrent
          handle_path /torrent/* {
            basicauth {
              xam $2a$14$ng4oteLs0gbk1aMgWEYdC.zzSI9trQcldbn0/9GCNFWV0axr7hWae
            }
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
