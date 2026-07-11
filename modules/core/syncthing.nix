{ ... }: {
  flake.nixosModules.syncthing = { ... }: { 
    services.syncthing = {
      enable  = true;
      user = "xam";
      group = "users";
      dataDir = "/home/xam/Documents/";
      configDir = "/home/xam/.syncthing/";
      guiAddress = "127.0.0.1:8384";
    };
  }; 
}
