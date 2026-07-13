{ ... }:
{
  flake.nixosModules.samba = { ... }: {
    services.samba = {
      enable = true;
      settings = {
        global = {
          # - General -
          "workgroup" = "WORKGROUP";
          "server string" = "ancient_samba";
          "netbios name" = "ancient";

          # - Security -	
          "security" = "user";
          "hosts allow" = "100.64.0.0/10 192.168.1.0/24 127.0.0.1 localhost"; # add tailscale ip
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
          "use sendfile" = "yes";
        };

        # - Shares -	
        "video" = {
          "path" = "/mnt/media/video";
          "browseable" = "yes";
          "read only" = "yes";
          "write list" = "xam";
          "guest ok" = "yes";
          "create mask" = "0644"; # rw-r--r--
          "directory mask" = "0755"; # rwxr-xr-x
          "force user" = "xam";
        };

        "books" = {
          "path" = "/mnt/media/books";
          "browseable" = "yes";
          "read only" = "yes";
          "write list" = "xam";
          "guest ok" = "yes";
          "create mask" = "0644"; # rw-r--r--
          "directory mask" = "0755"; # rwxr-xr-x
          "force user" = "xam";
        };

        "games" = {
          "path" = "/mnt/media/games";
          "browseable" = "yes";
          "read only" = "yes";
          "write list" = "xam";
          "guest ok" = "yes";
          "create mask" = "0644"; # rw-r--r--
          "directory mask" = "0755"; # rwxr-xr-x
          "force user" = "xam";
        };
      };
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };
}
