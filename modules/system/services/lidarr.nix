{ ... }:
{
  flake.nixosModules.lidarr = { inputs,... }: {
    imports = [ inputs.self.nixosModules.prowlarr ];

    users.users.lidarr = {
      isSystemUser = true;
      group = "media";
      home = "/var/lib/lidarr";     # App data directory
      createHome = true;            # Auto-create the home folder
      description = "Lidarr Service User";
    };

    users.groups.media = {};

    # Enable the Lidarr service
    services.lidarr = {
      enable = true;
      user = "lidarr";
      group = "media";    
      openFirewall = true;  # Opens default port 8686
    };
  };
}
