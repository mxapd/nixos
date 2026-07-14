{ ... }:
{
  flake.nixosModules.lidarr = { inputs,... }: {
    imports = [ inputs.self.nixosModules.prowlarr ];

    # Enable the Lidarr service
    services.lidarr = {
      enable = true;
      user = "media";
      group = "media";    
      openFirewall = true;  # Opens default port 8686
    };
  };
}
