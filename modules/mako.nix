{ ... }: {
  flake.nixosModules.mako = { pkgs, ... }: { 
    home-manager.users.xam.services.mako = {
      enable = true;
      package = pkgs.mako;
      settings = {
        defaultTimeout = 7000;
        borderRadius   = 3;
      };
    };
  };
}
