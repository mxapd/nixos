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
      guiAddress = "0.0.0.0:8384";
    };
  };
}
