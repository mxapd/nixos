{ ... }:
{
  flake.nixosModules.calendar = { pkgs, ... }: {
    sops.secrets."radicale-vdirsyncer-password" = {
      sopsFile = ../../../../secrets/radicale.yaml;
      path = "/run/secrets/radicale-vdirsyncer-password";
      owner = "xam";
      mode = "0600";
    };

    home-manager.users.xam = {
      home.packages = with pkgs; [ vdirsyncer khal ];

      xdg.configFile."vdirsyncer/config".text = ''
        [general]
        status_path = "~/.local/share/vdirsyncer/status"

        [pair lnu_timeedit]
        a = "lnu_remote"
        b = "lnu_local"
        collections = null

        [pair personal]
        a = "personal_remote"
        b = "personal_local"
        collections = null

        [storage lnu_remote]
        type = "caldav"
        url = "http://ancient:5232/xam/lnu-timeedit/"
        username = "xam"
        read_only = true
        password.fetch = ["command", "cat", "/run/secrets/radicale-vdirsyncer-password"]

        [storage lnu_local]
        type = "filesystem"
        path = "~/.calendars/lnu-timeedit/"
        fileext = ".ics"

        [storage personal_remote]
        type = "caldav"
        url = "http://ancient:5232/xam/personal/"
        username = "xam"
        password.fetch = ["command", "cat", "/run/secrets/radicale-vdirsyncer-password"]

        [storage personal_local]
        type = "filesystem"
        path = "~/.calendars/personal/"
        fileext = ".ics"
      '';

      xdg.configFile."khal/config".text = ''
        [calendars]
        [[lnu_timeedit]]
        path = ~/.calendars/lnu-timeedit/
        color = dark blue

        [[personal]]
        path = ~/.calendars/personal/
        color = dark green
        default = true

        [locale]
        timeformat = %H:%M
        dateformat = %Y-%m-%d
        longdateformat = %Y-%m-%d
        datetimeformat = %Y-%m-%d %H:%M
        longdatetimeformat = %Y-%m-%d %H:%M
      '';

      systemd.user.services.vdirsyncer-sync = {
        Unit = {
          Description = "Sync Radicale calendars to local vdir";
          After = [ "network.target" ];
        };
        Service = {
          Type = "oneshot";
          Environment = "VDIRSYNCER_CONFIG=%h/.config/vdirsyncer/config";
          ExecStart = "${pkgs.vdirsyncer}/bin/vdirsyncer sync";
        };
      };

      systemd.user.timers.vdirsyncer-sync = {
        Unit = {
          Description = "Periodic Radicale calendar sync";
        };
        Timer = {
          OnBootSec = "5m";
          OnUnitActiveSec = "1h";
          Persistent = true;
        };
        Install = {
          WantedBy = [ "timers.target" ];
        };
      };
    };
  };
}
