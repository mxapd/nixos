{ inputs, lib, ... }:
{
  flake.nixosModules.hyprmoon-laptop = { ... }: {
    imports = [ inputs.self.nixosModules.hyprmoon ];

    home-manager.users.xam.programs.waybar.settings = lib.mkForce [
      {
        layer = "top";
        position = "bottom";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "disk"
          "backlight"
          "battery"
          "network"
          "pulseaudio"
          "tray"
          "clock"
        ];

        "disk" = {
          path = "/";
          interval = "30";
          format = "󰋊 {free} free";
          unit = "GB";
        };

        "backlight" = {
          format = "󰃠 {percent}%";
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
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
          format = "󰅐 {:%H:%M %A%e %b}";
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
          format-ethernet = "󰤨 {bandwidthDownBytes} dwn {bandwidthUpBytes} up";
          format-wifi = "󰤨 {signalStrength}%";
          format-disconnected = "󰤮";
        };

        "pulseaudio" = {
          format = "󰕾 {volume}%";
          on-click = "wiremix";
        };
      }
    ];

    # Laptop-specific Hyprland settings
    home-manager.users.xam.wayland.windowManager.hyprland.settings = {
      input.touchpad = {
        natural_scroll = true;
        tap-to-click = true;
        disable_while_typing = true;
      };

      bindel = [
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];
    };
  };
}
