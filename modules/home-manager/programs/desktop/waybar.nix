# modules/home-manager/programs/desktop/waybar.nix
# Waybar status bar for home-manager

{ self, inputs, ... }:

{
  flake.homeManagerModules.programs.desktop.waybar = { config, pkgs, lib, ... }:
  {
    programs.waybar = {
      enable = true;
      package = pkgs.waybar;
      settings = [
        {
          layer = "top";
          position = "bottom";
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [
            "custom/nixos-warnings"
            "disk"
            "network"
            "pulseaudio"
            "tray"
            "clock"
          ];

          "disk" = {
            path = "/";
            interval = "30";
            format = " | {free} free |";
            unit = "GB";
          };

          "hyprland/workspaces" = {
            format = "{name}";
            format-icons = {
              default = " ";
              active = " ";
              urgent = " ";
            };
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
          };
        
          "hyprland/window" = {
            max-length = 22;
            separate-outputs = false;
            rewrite = {
              "" = " No Window? ";
            };
          };

          "clock" = {
            format = " {:%H:%M} ";
            format-alt = " {:%a %d %b} ";
          };

          "network" = {
            format-wifi = " {signalStrength}% ";
            format-ethernet = " {ipaddr} ";
            format-disconnected = " ⚠ ";
            interval = 5;
          };

          "pulseaudio" = {
            format = "{icon} {volume}%";
            format-muted = " muted ";
            format-icons = {
              default = [ "🔊" "🔈" "🔇" ];
            };
          };

          "tray" = {
            spacing = 10;
          };

          "custom/nixos-warnings" = {
            format = " {}";
            exec = "echo";
            interval = 3600;
            return-type = "json";
            signals = { "SIGURG" = 0; };
          };
        }
      ];
    };
  };
}