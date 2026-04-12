# modules/core/tailscale.nix
# Tailscale VPN and networking configuration

{ self, inputs, ... }:

{
  flake.nixosModules.tailscale = { config, pkgs, ... }:
  {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    networking = {
      hosts = {
        # Swahnlabs hosts via Tailscale
        "100.64.0.17" = [
          "nextcloud.yggdrasil.com"
          "firefly.yggdrasil.com"
          "importer.yggdrasil.com"
          "gitea.yggdrasil.com"
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      tailscale
    ];
  };
}
