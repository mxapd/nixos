# modules/home-manager/desktops/hyprland/hyprland.nix
# Hyprland desktop environment - Aggregates all submodules
# Import this to get the complete Hyprland setup

{ self, inputs, lib, pkgs, ... }:

{
  # Aggregator module that combines all Hyprland components
  flake.homeModules.desktops.hyprland = { config, pkgs, lib, ... }: {
    imports = [
      self.homeModules.desktops.hyprland.waybar
      self.homeModules.desktops.hyprland.mako
      self.homeModules.desktops.hyprland.config
    ];
  };
}
