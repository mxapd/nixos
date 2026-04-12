# modules/server/samba.nix
# Samba file sharing (NixOS system level)

{ self, inputs, ... }:

{
  flake.nixosModules.samba = { config, pkgs, lib, ... }:

    with lib;

    let
      cfg = config.features.server.samba;
    in
    {
      options.features.server.samba = {
        enable = mkEnableOption "Samba file sharing";

        workgroup = mkOption {
          type = types.str;
          default = "WORKGROUP";
          description = "SMB workgroup name";
        };

        serverString = mkOption {
          type = types.str;
          default = "NixOS Samba Server";
          description = "Server description";
        };

        netbiosName = mkOption {
          type = types.str;
          default = config.networking.hostName;
          description = "NetBIOS name";
        };

        shares = mkOption {
          type = types.attrsOf (types.attrsOf types.str);
          default = {};
          description = "Samba shares configuration";
          example = {
            video = {
              path = "/mnt/video";
              browseable = "yes";
              "read only" = "yes";
              "guest ok" = "yes";
            };
          };
        };

        allowedHosts = mkOption {
          type = types.listOf types.str;
          default = [ "192.168.1.0/24" "127.0.0.1" "localhost" ];
          description = "Allowed hosts/networks";
        };

        openFirewall = mkOption {
          type = types.bool;
          default = true;
          description = "Open firewall for Samba";
        };
      };

      config = mkIf cfg.enable {
        # Samba service
        services.samba = {
          enable = true;
          settings = {
            global = {
              workgroup = cfg.workgroup;
              "server string" = cfg.serverString;
              netbiosName = cfg.netbiosName;

              # Security
              security = "user";
              "hosts allow" = concatStringsSep " " cfg.allowedHosts;
              "hosts deny" = "0.0.0.0/0";
              "guest account" = "nobody";
              "map to guest" = "bad user";
              "use sendfile" = "yes";
            };
          } // cfg.shares;  # Merge shares into settings
        };

        # Samba Web Services Discovery (for Windows network discovery)
        services.samba-wsdd = {
          enable = true;
          openFirewall = true;
        };

        # Open firewall ports
        networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ 445 139 ];
        networking.firewall.allowedUDPPorts = mkIf cfg.openFirewall [ 137 138 ];
      };
    };
}
