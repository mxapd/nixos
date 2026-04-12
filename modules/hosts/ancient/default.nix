# modules/hosts/ancient/default.nix
# Ancient host configuration - dendritic feature enablement

{ config, pkgs, inputs, ... }:

{
  imports = [
    # Enable features for ancient (minimal server)
    inputs.self.nixosModules.features-base
    inputs.self.nixosModules.features-users
    inputs.self.nixosModules.features-tailscale
    inputs.self.nixosModules.features-ssh

    # Server doesn't need desktop, but needs editor and dev tools
    inputs.self.nixosModules.features-dev
    inputs.self.nixosModules.features-editor

    # Phase 5: Server features
    inputs.self.nixosModules.features-server-gitea
    inputs.self.nixosModules.features-server-syncthing
    inputs.self.nixosModules.features-server-samba
    inputs.self.nixosModules.features-server-media
  ];

  # Ancient-specific server configuration
  features.server = {
    # Gitea Git server
    gitea = {
      enable = true;
      httpPort = 3000;
      appName = "not your average git";
      domain = "localhost";
      rootUrl = "http://localhost:3000/";
      backupDir = "/mnt/git";
    };

    # Syncthing file sync
    syncthing = {
      enable = true;
      user = "xam";
      group = "users";
      dataDir = "/mnt/syncthing/xam";
      configDir = "/mnt/syncthing/config";
      guiAddress = "0.0.0.0:8384";
    };

    # Samba file sharing
    samba = {
      enable = true;
      workgroup = "WORKGROUP";
      serverString = "ancient_samba";
      netbiosName = "ancient";
      allowedHosts = [ "100.64.0.0/10" "192.168.1.0/24" "127.0.0.1" "localhost" ];
      shares = {
        video = {
          path = "/mnt/video";
          browseable = "yes";
          "read only" = "yes";
          "write list" = "xam";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "xam";
        };
        books = {
          path = "/mnt/books";
          browseable = "yes";
          "read only" = "yes";
          "write list" = "xam";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "xam";
        };
      };
    };

    # Media server (Jellyfin + Radicale)
    media = {
      enable = true;
      jellyfin = {
        enable = true;
        user = "jellyfin";
        openFirewall = true;
      };
      radicale = {
        enable = true;
        port = 5232;
        authType = "none";
      };
    };
  };

  # Ancient-specific configuration
}
