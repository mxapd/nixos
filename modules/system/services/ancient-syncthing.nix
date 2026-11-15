{ ... }:
{
  flake.nixosModules.ancient-syncthing = { ... }: {

    services.syncthing = {
      enable = true;
      user = "xam";
      group = "users";
      openDefaultPorts = true;
      dataDir = "/mnt/syncthing/xam";
      configDir = "/mnt/syncthing/config";

      # GUI served behind Caddy at https://ancient/sync
      guiAddress = "127.0.0.1:8384";

      # NOTE: because `settings` is non-empty, NixOS runs syncthing-init, which
      # (with overrideDevices/overrideFolders = true, the default) DELETES any
      # device or folder not declared here. So declare them all.
      settings = {
        gui.insecureSkipHostcheck = true;

        devices = {
          desktop.id = "XHNPNZX-CTIWY6N-5LR7BNF-YZGNBOK-PXKMVC6-27L226S-4FPYKEX-VWEXHAD";
          laptop.id = "6G2RA7K-HECJKNQ-SNF3EAY-7QDBTVK-WZ4RRPR-3TK6KEE-AYA6A4X-O67ZXQR";
        };

        folders = {
          "Xam-Docs" = {
            label = "Documents";
            path = "/mnt/syncthing/data/xam-docs";
            devices = [ "desktop" "laptop" ];
          };
          "xam-projects" = {
            label = "Projects";
            path = "/mnt/syncthing/data/xam-projects";
            devices = [ "desktop" "laptop" ];
          };
        };
      };
    };

    # TODO: Set GUI URL base to /sync in Syncthing settings after first run
    # (Settings -> GUI -> URL Base) if redirects/assets misbehave.
  };
}
