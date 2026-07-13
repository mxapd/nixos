# hosts/ancient/nas.nix
#
# NAS configuration for `ancient`.
#
# Two general-purpose Samba shares:
#   - public  : everyone can browse + read (guest), only `xam` can write
#   - private : `xam` only, read/write, no guest access at all
#
# Plus the existing media shares (video, books) kept read-only.
#
# The SMB account password for `xam` is provisioned declaratively from an
# agenix secret (see secrets/smb-xam-password.age) by a oneshot systemd
# service that runs `smbpasswd` on every activation.

{ config, pkgs, lib, ... }:

let
  smbUser = "xam";
in
{
  ##########################################################################
  # Secret: the SMB password for `xam`.
  # The .age file must contain ONLY the plaintext password (single line).
  ##########################################################################
  age.secrets.smb-xam-password = {
    file = ../../secrets/smb-xam-password.age;
    owner = "root";
    group = "root";
    mode = "400";
  };

  ##########################################################################
  # Samba
  ##########################################################################
  services.samba = {
    enable = true;
    openFirewall = true; # opens 139/445 TCP + 137/138 UDP automatically

    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "ancient_nas";
        "netbios name" = "ancient";

        # - Security -
        "security" = "user";
        # Allow LAN + tailscale CGNAT range + loopback; deny everything else.
        "hosts allow" = "100.64.0.0/10 192.168.1.0/24 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
        "use sendfile" = "yes";
      };

      # ---- PUBLIC: everyone reads, only xam writes ------------------------
      "public" = {
        "path" = "/mnt/public";
        "browseable" = "yes";
        "guest ok" = "yes"; # unauthenticated users may read
        "read only" = "yes"; # default read-only ...
        "write list" = smbUser; # ... except xam, who can write
        "force user" = smbUser; # files land owned by xam
        "create mask" = "0644";
        "directory mask" = "0755";
      };

      # ---- PRIVATE: xam only, full read/write, no guests ------------------
      "private" = {
        "path" = "/mnt/private";
        "browseable" = "yes";
        "guest ok" = "no"; # must authenticate
        "read only" = "no"; # read/write
        "valid users" = smbUser; # only xam may even connect
        "force user" = smbUser;
        "create mask" = "0600"; # private by default
        "directory mask" = "0700";
      };

      # ---- GAMES: everyone reads/launches, only xam writes ----------------
      "games" = {
        "path" = "/mnt/games";
        "browseable" = "yes";
        "guest ok" = "yes"; # unauthenticated users may read
        "read only" = "yes"; # default read-only ...
        "write list" = smbUser; # ... except xam, who can write
        "force user" = smbUser;
        "create mask" = "0644";
        "directory mask" = "0755";
      };

      # ---- Existing media shares (kept read-only) -------------------------
      "video" = {
        "path" = "/mnt/video";
        "browseable" = "yes";
        "guest ok" = "yes";
        "read only" = "yes";
        "write list" = smbUser;
        "force user" = smbUser;
        "create mask" = "0644";
        "directory mask" = "0755";
      };

      "books" = {
        "path" = "/mnt/books";
        "browseable" = "yes";
        "guest ok" = "yes";
        "read only" = "yes";
        "write list" = smbUser;
        "force user" = smbUser;
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };

  # Windows / "Network" discovery (WS-Discovery).
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  ##########################################################################
  # Make sure the share directories exist with sane ownership.
  ##########################################################################
  systemd.tmpfiles.rules = [
    "d /mnt/public  0755 ${smbUser} users - -"
    "d /mnt/private 0700 ${smbUser} users - -"
    "d /mnt/games   0755 ${smbUser} users - -"
  ];

  ##########################################################################
  # Provision the SMB password for `xam` declaratively from the agenix secret.
  # Runs once on activation; re-runs are idempotent.
  ##########################################################################
  systemd.services.smb-user-setup = {
    description = "Provision Samba password for ${smbUser} from agenix secret";
    wantedBy = [ "multi-user.target" ];
    after = [ "samba-smbd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      set -euo pipefail
      pw="$(cat ${config.age.secrets.smb-xam-password.path})"
      # -a adds (or updates) the user; -s reads password from stdin twice.
      printf '%s\n%s\n' "$pw" "$pw" | ${pkgs.samba}/bin/smbpasswd -s -a ${smbUser}
    '';
  };
}
