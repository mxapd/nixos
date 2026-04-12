# modules/home-manager/desktops/hyprland/waybar.nix
# Waybar status bar configuration

{ self, inputs, lib, pkgs, ... }:

{
  flake.homeModules.desktops.hyprland.waybar = { config, pkgs, lib, ... }:
    let
      concatStrings = lib.concatStrings;
    in
    {
      programs.waybar = {
        enable = true;
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
              format = "{:%H:%M %A%e %b}";
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><big>{calendar}</big></tt>";
              today-format = "<b>{}</b>";
              on-click = "calcure";
            };

            "tray" = {
              spacing = 12;
            };

            "network" = {
              interval = "5";
              format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
              format-ethernet = "{bandwidthDownBytes} dwn {bandwidthUpBytes} up |";
              format-wifi = "{icon} {signalStrength}%";
              format-disconnected = "󰤮";
            };

            "pulseaudio" = {
              format = "{volume}% |";
              on-click = "wiremix";
            };

            "custom/nixos-warnings" = {
              exec = "echo '⚠ '$(nixos-warnings count)' warnings'";
              interval = 5;
              tooltip = true;
              tooltip-format = "Click to view warnings";
            };
          }
        ];

        style = concatStrings ''
          @define-color bg-color rgb(68, 71, 90);
          @define-color bg-color-tray rgb(40, 42, 54);
          @define-color bg-color-ws rgb(40, 42, 54);
          @define-color bg-color-0 rgb(40, 42, 54);
          @define-color bg-color-1 rgb(40, 42, 54);
          @define-color fg-color rgb(248, 248, 242);
          @define-color alert-bg-color rgb(255, 85, 85);
          @define-color alert-fg-color rgb(248, 248, 242);
          @define-color inactive-fg-color rgb(144, 153, 162);
          @define-color inactive-bg-color rgb(68, 71, 90);

          * {
              border: none;
              border-radius: 0;
              font-family: Dejavu Sans Mono, FontAwesome, Material Icons, sans-serif;
              font-size: 16px;
              min-height: 0;
              opacity: 1.0;
          }

          window#waybar {
              background-color: rgba(40, 42, 54, 0);
              border-bottom: none;
              color: @fg-color;
              transition-property: background-color;
              transition-duration: .5s;
          }

          window#waybar.hidden {
              opacity: 0.4;
          }

          #workspaces button {
              padding: 0 5px;
              background-color: transparent;
              color: @fg-color;
              border-bottom: 3px solid transparent;
          }

          #workspaces button:hover {
              background: rgba(0, 0, 0, 0.2);
              box-shadow: inherit;
              border-bottom: 3px solid @fg-color;
          }

          #workspaces button.focused {
              background-color: @bg-color;
              border-bottom: 3px solid @fg-color;
          }

          #workspaces button.urgent {
              background-color: @alert-bg-color;
          }

          #clock {
              padding: 0 10px;
              background-color: rgba(0,0,0,0);
              color: @fg-color;
          }

          #network.disconnected {
              background-color: @alert-bg-color;
          }

          #pulseaudio.muted {
              background-color: @inactive-bg-color;
              color: @inactive-fg-color;
          }
        '';
      };
    };
}
