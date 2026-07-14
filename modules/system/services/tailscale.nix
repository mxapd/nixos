{ ... }:

{
  flake.nixosModules.tailscale = { pkgs, ... }: {

    networking.hosts = {
      "100.64.0.14" = [ "ancient" "gitea.ancient.com"];
      #"100.64.0.Y" = [ "hermes" ];
      "100.64.0.6" = [ "hearth" ];
      "100.64.0.7" = [ "sojourn" ];


      "100.64.0.17" = [ "nextcloud.yggdrasil.com" "firefly.yggdrasil.com" "importer.yggdrasil.com" "gitea.yggdrasil.com" ];
    };

    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    environment.systemPackages = with pkgs; [
      tailscale
    ];
  };
}
