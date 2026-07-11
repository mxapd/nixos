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
	  defaultTimeout = 7000;
	  borderRadius   = 3;
	};
      };
    };
  };
}
