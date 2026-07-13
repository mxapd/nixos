{ ... }: {
  flake.nixosModules.mako = { pkgs, ... }: {
    home-manager.users.xam = {

      home.packages = with pkgs; [
        libnotify
      ];

      services.mako = {
        enable = true;
        package = pkgs.mako;
        settings = {
          border-radius = 8;
          default-timeout = 7000;
          border-size = 1;
        };
      };
    };
  };
}
