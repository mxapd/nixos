# modules/server/gitea.nix
# Gitea Git server (NixOS system level)

{ self, inputs, ... }:

{
  flake.nixosModules.gitea = { config, pkgs, lib, ... }:

    with lib;

    let
      cfg = config.features.server.gitea;
    in
    {
      options.features.server.gitea = {
        enable = mkEnableOption "Gitea Git server";

        httpPort = mkOption {
          type = types.port;
          default = 3000;
          description = "HTTP port for Gitea web interface";
        };

        domain = mkOption {
          type = types.str;
          default = "localhost";
          description = "Domain name for Gitea";
        };

        rootUrl = mkOption {
          type = types.str;
          default = "http://localhost:3000/";
          description = "Root URL for Gitea";
        };

        appName = mkOption {
          type = types.str;
          default = "Gitea";
          description = "Application name displayed in UI";
        };

        databasePath = mkOption {
          type = types.str;
          default = "/var/lib/gitea/data/gitea.db";
          description = "Path to SQLite database";
        };

        backupDir = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Directory to backup Gitea data (null to disable backups)";
        };
      };

      config = mkIf cfg.enable {
        # Gitea service
        services.gitea = {
          enable = true;
          appName = cfg.appName;
          user = "gitea";

          # Database for metadata (users, keys, etc.)
          database = {
            type = "sqlite3";
            path = cfg.databasePath;
          };

          # Server settings (new format for NixOS 24.11+)
          settings.server = {
            HTTP_PORT = cfg.httpPort;
            DOMAIN = cfg.domain;
            ROOT_URL = cfg.rootUrl;
          };
        };

        # Open firewall port
        networking.firewall.allowedTCPPorts = [ cfg.httpPort ];

        # Backup service (if backupDir is set)
        systemd.services.gitea-backup = mkIf (cfg.backupDir != null) {
          description = "Mirror Gitea data to backup directory";
          after = [ "gitea.service" ];
          serviceConfig = {
            User = "root";
            Type = "oneshot";
            ExecStart = [
              "/run/current-system/sw/bin/mkdir -p ${cfg.backupDir}"
              "/run/current-system/sw/bin/rsync -a --delete /var/lib/gitea/ ${cfg.backupDir}/"
            ];
          };
        };

        # Backup timer (daily)
        systemd.timers.gitea-backup = mkIf (cfg.backupDir != null) {
          description = "Daily Gitea rsync backup";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "daily";
            Persistent = true;
            RandomizedDelaySec = "10m";
          };
        };

        # Required packages
        environment.systemPackages = with pkgs; [
          rsync  # For backup
        ];
      };
    };
}
