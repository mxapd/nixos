# modules/features/server/syncthing/default.nix
# Syncthing file synchronization (NixOS system level)

{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.features.server.syncthing;
in
{
  options.features.server.syncthing = {
    enable = mkEnableOption "Syncthing file synchronization";

    user = mkOption {
      type = types.str;
      default = "syncthing";
      description = "User to run Syncthing as";
    };

    group = mkOption {
      type = types.str;
      default = "users";
      description = "Group for Syncthing user";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/syncthing";
      description = "Directory for synchronized files";
    };

    configDir = mkOption {
      type = types.str;
      default = "/var/lib/syncthing/.config/syncthing";
      description = "Directory for Syncthing configuration";
    };

    guiAddress = mkOption {
      type = types.str;
      default = "127.0.0.1:8384";
      description = "Address for Syncthing web GUI (use 0.0.0.0:8384 for LAN access)";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Open firewall ports for Syncthing";
    };
  };

  config = mkIf cfg.enable {
    # Syncthing service
    services.syncthing = {
      enable = true;
      user = cfg.user;
      group = cfg.group;
      dataDir = cfg.dataDir;
      configDir = cfg.configDir;
      guiAddress = cfg.guiAddress;
      openDefaultPorts = cfg.openFirewall;
    };

    # Open web GUI port in firewall
    networking.firewall.allowedTCPPorts = [ 8384 ];
  };
}
