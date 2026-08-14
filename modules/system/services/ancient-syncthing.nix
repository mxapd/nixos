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
    };

    # TODO: Set GUI URL base to /sync in Syncthing settings after first run
    # (Settings -> GUI -> URL Base) if redirects/assets misbehave.
  };
}
