{ pkgs, ... }:
{
  flake.nixosModules.vdirsyncer-school = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.vdirsyncer ];

    users.users.vdirsyncer = {
      isSystemUser = true;
      group = "vdirsyncer";
      home = "/var/lib/vdirsyncer";
      createHome = true;
      description = "vdirsyncer school calendar sync";
    };

    users.groups.vdirsyncer = {};

    sops.secrets."radicale-vdirsyncer-password" = {
      sopsFile = ../../../secrets/radicale.yaml;
      path = "/run/secrets/radicale-vdirsyncer-password";
      owner = "vdirsyncer";
      group = "vdirsyncer";
      mode = "0600";
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/vdirsyncer/status 0750 vdirsyncer vdirsyncer -"
    ];

    environment.etc."vdirsyncer/config".text = ''
      [general]
      status_path = "/var/lib/vdirsyncer/status"

      [pair school_radicale]
      a = "school_ics"
      b = "radicale_school"
      collections = null
      conflict_resolution = "a wins"
      partial_sync = "ignore"

      [storage school_ics]
      type = "http"
      url = "https://cloud.timeedit.net/lnu/web/schema2/ri66582YX51Z0XQ6Z86g5540y8006Y96506gQY6Q53756762X99652883n6WX2Y676505X7Z056X5385QY0715651X54584.ics"

      [storage radicale_school]
      type = "caldav"
      url = "http://ancient:5232/xam/lnu-timeedit/"
      username = "xam"
      password.fetch = ["command", "cat", "/run/secrets/radicale-vdirsyncer-password"]
    '';

    systemd.services.vdirsyncer-school-sync = {
      description = "Sync school ICS calendar into Radicale";
      after = [ "network.target" "radicale.service" ];
      wants = [ "radicale.service" ];
      serviceConfig = {
        User = "vdirsyncer";
        Group = "vdirsyncer";
        Type = "oneshot";
        Environment = [
          "VDIRSYNCER_CONFIG=/etc/vdirsyncer/config"
          "HOME=/var/lib/vdirsyncer"
        ];
        ExecStart = "${pkgs.vdirsyncer}/bin/vdirsyncer sync";
      };
    };

    systemd.timers.vdirsyncer-school-sync = {
      description = "Periodic school calendar sync";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = "1h";
        Persistent = true;
      };
    };
  };
}
