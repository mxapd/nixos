# modules/features/desktop/default.nix
# Desktop Environment - Hyprland Wayland compositor (NixOS system level)

{ config, pkgs, inputs, lib, ... }:

{
  # Enable Hyprland at system level
  programs.hyprland = {
    enable = true;
    # Use flake package for latest version
    package = lib.mkDefault inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # Portal package must match Hyprland package
    portalPackage = lib.mkDefault inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # XDG Desktop Portal for Wayland
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = false;
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [ "gtk" "hyprland" ];
    };
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Display Manager (SDDM)
  services.displayManager.sddm.enable = true;

  # Required environment for Wayland apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Desktop utilities - keep minimal to avoid missing packages
  environment.systemPackages = with pkgs; [
    # Wayland utilities
    wl-clipboard
    libnotify
  ];

  # Security policy for desktop
  security.polkit.enable = true;

  # Console keyboard layout
  console.keyMap = "sv-latin1";

  # X11 compatibility (for some apps)
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "se";
    variant = "";
  };
}
