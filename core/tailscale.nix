{  pkgs, ...}:

{

  networking.hosts = {
    "100.64.0.14" = [ "ancient" ];
    #"100.64.0.Y" = [ "hermes" ];
    "100.64.0.6" = [ "desktop" ];
    "100.64.0.7" = [ "laptop" ];
  };


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
