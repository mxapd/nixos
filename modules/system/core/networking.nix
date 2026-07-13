{ ... }:
{
  flake.nixosModules.networking = { ... }: {
    networking = {
      hostName = "hearth";
      networkmanager.enable = true;
      firewall.enable = true;
      firewall.allowedTCPPorts = [ ];
    };
  };
}
