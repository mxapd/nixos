{ ... }:
{
  flake.nixosModules.networking = { ... }: {
    networking = {
      networkmanager.enable = true;
      firewall.enable = true;
      firewall.allowedTCPPorts = [ ];
    };
  };
}
