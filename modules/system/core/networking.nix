{ ... }:
{
  flake.nixosModules.networking = { ... }: {
    networking = {
      networkmanager.enable = true;
      nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" ];
      firewall.enable = true;
      firewall.allowedTCPPorts = [ ];
    };
  };
}
