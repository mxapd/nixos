# modules/features/tailscale/default.nix
# Tailscale VPN and networking configuration

{ config, pkgs, ... }:

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
}
