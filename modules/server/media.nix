# modules/server/media.nix
# Media server - Jellyfin and Radicale (NixOS system level)

{ self, inputs, ... }:

{
  flake.nixosModules.media = { config, pkgs, lib, ... }:

    with lib;

    let
      cfg = config.features.server.media;
    in
    {
      options.features.server.media = {
        enable = mkEnableOption "Media server (Jellyfin and Radicale)";

        # Jellyfin options
        jellyfin = {
          enable = mkEnableOption "Jellyfin media server" // { default = true; };

          user = mkOption {
            type = types.str;
            default = "jellyfin";
            description = "User to run Jellyfin as";
          };

          openFirewall = mkOption {
            type = types.bool;
            default = true;
            description = "Open firewall for Jellyfin";
          };
        };

        # Radicale options
        radicale = {
          enable = mkEnableOption "Radicale CalDAV/CardDAV server" // { default = true; };

          port = mkOption {
            type = types.port;
            default = 5232;
            description = "Port for Radicale server";
          };

          authType = mkOption {
            type = types.enum [ "none" "htpasswd" "remote_user" "http_x_remote_user" ];
            default = "none";
            description = "Authentication type for Radicale";
          };
        };
      };

      config = mkIf cfg.enable {
        # Jellyfin media server
        services.jellyfin = mkIf cfg.jellyfin.enable {
          enable = true;
          user = cfg.jellyfin.user;
          openFirewall = cfg.jellyfin.openFirewall;
        };

        # Radicale calendar/contacts
        services.radicale = mkIf cfg.radicale.enable {
          enable = true;
          settings = {
            server.hosts = [ "0.0.0.0:${toString cfg.radicale.port}" ];
            auth.type = cfg.radicale.authType;
          };
        };

        # Open firewall ports (combine into single definition)
        networking.firewall.allowedTCPPorts = 
          (if (cfg.jellyfin.enable && cfg.jellyfin.openFirewall) then [ 8096 ] else []) ++
          (if cfg.radicale.enable then [ cfg.radicale.port ] else []);

        # Media packages
        environment.systemPackages = with pkgs; [
          jellyfin-web
          jellyfin-ffmpeg
        ];
      };
    };
}
