# modules/home-manager/desktops/hyprland/mako.nix
# Mako notification daemon configuration

{ self, inputs, lib, pkgs, ... }:

{
  flake.homeModules.desktops.hyprland.mako = { config, pkgs, lib, ... }: {
    services.mako = {
      enable = true;
      settings = {
        default-timeout = 7000;
        border-radius = 5;
      };
    };
  };
}
