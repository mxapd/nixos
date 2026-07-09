{ pkgs, ... }:

{
  flake.nixosModules.hm-git = { pkgs, ... }: {
    home-manager.users.xam.programs.git = {
      enable = true;
      settings = {
        user = {
          name = "xam";
          email = "m.porseryd@gmail.com";
        };
        credential = {
          helper = "manager";
          "https://gitlab.lnu.se".username = "Max Porseryd";
          "https://gitlab.lnu.se".email = "mp224hv@student.lnu.se";
          "https://github.com".username = "mxapd";
          credentialStore = "cache";
        };
      };
    };
  };
}
