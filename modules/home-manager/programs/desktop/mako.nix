# modules/home-manager/programs/desktop/mako.nix
# Mako notification daemon for home-manager

{ self, inputs, ... }:

{
  flake.homeManagerModules.programs.desktop.mako = { config, pkgs, ... }:
  {
    services.mako = {
      enable = true;
      package = pkgs.mako;
      settings = {
        default-timeout = 7000;
        border-radius = 5;
      };
    };
  };
}