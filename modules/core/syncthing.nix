{ ... }: {
  flake.nixosModules.syncthing = { ... }: { 
    services.syncthing = {
      enable  = true;
      user = "xam";
      group = "users";
      dataDir = "/home/xam/Documents/";
      configDir = "/home/xam/.syncthing/";
      guiAddress = "0.0.0.0:8384";
    };
  }; 
}
