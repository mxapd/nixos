{ ... }:
{
  flake.nixosModules.prowlarr = { ... }: {
    services.prowlarr = {
      enable = true;
      openFirewall = false;
    };

    # TODO: Set URL base to /prowlarr in the app (Settings -> General -> URL Base)
    # after first run, then it will be reachable at https://ancient/prowlarr
  };
}
