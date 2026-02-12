{  pkgs, ...}:

{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };
  
  networking = {
    hosts = {
      # Swahnlabs
      "100.64.0.17" = ["nextcloud.yggdrasil.com" "firefly.yggdrasil.com" "importer.yggdrasil.com" "gitea.yggdrasil.com"];
    };
  };

  environment.systemPackages = with pkgs; [
    tailscale
  ];
}
