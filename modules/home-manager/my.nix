# modules/home-manager/my.nix
# Home-manager configuration aggregator
# Dendritic-style: import all modules that get exported

{ self, inputs, ... }:

{
  flake.homeManagerModules.default = { config, pkgs, lib, ... }:
  {
    imports = [
      # Core programs
      ./programs/git.nix
      ./programs/shell.nix
      ./programs/editor.nix
      
      # Desktop (Wayland)
      ./programs/desktop/hyprland.nix
      ./programs/desktop/waybar.nix
      ./programs/desktop/mako.nix
      
      # NixOS-level theming (stylix is configured at system level)
    ];

    # Home directory and user
    home = {
      username = "xam";
      homeDirectory = "/home/xam";
      stateVersion = "25.11";
      
      sessionVariables = {
        OBSIDIAN_VAULT = "/home/xam/Documents/obsidian/";
        EDITOR = "nvim";
        BROWSER = "firefox";
      };
    };
  };
}