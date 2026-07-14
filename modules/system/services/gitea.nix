{ ... }:
{
  flake.nixosModules.gitea = { ... }: {
    services.gitea = {
      enable = true;
      appName = "not your average git";
      user = "gitea";

      settings.server = {
	HTTP_PORT = 3001;
	SSH_PORT = 3002;
	DOMAIN = "localhost";
        ROOT_URL = "http://localhost:3001/";
      };

      # database for metadata (users, keys and stuff)
      database = {
	type = "sqlite3";
	path = "/var/lib/gitea/data/gitea.db";
      };
    };

    systemd.services.gitea-backup = {
      description = "Mirror Gitea data to HDD backup directory";
      after = [ "gitea.service" ];
      serviceConfig = {
	User = "root";
	Type = "oneshot";
	ExecStart = [
	  "/run/current-system/sw/bin/mkdir -p /mnt/git/"
	  "/run/current-system/sw/bin/rsync -a --delete /var/lib/gitea/ /mnt/git/"
	];
      };
    };

    systemd.timers.gitea-backup = {
      description = "Daily Gitea rsync backup";
      wantedBy = [ "timers.target" ];
      timerConfig = {
	OnCalendar = "daily";
	Persistent = true;
	RandomizedDelaySec = "10m";
      };
    };
  };
}
