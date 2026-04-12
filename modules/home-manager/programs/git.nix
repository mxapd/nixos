# modules/home-manager/programs/git.nix
# Git configuration for home-manager

{ self, inputs, ... }:

{
  flake.homeManagerModules.programs.git = { config, pkgs, ... }:
  {
    programs.git = {
      enable = true;
      userName = "xam";
      userEmail = "m.porseryd@gmail.com";
      extraConfig = {
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