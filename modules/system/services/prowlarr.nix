{ ... }:
{
  flake.nixosModules.prowlarr = { ... }: {
    services.prowlar = {
      enable = true;
      openFirewall = true;
    };
  };
}
