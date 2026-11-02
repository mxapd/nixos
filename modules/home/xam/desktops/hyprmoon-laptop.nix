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
    home-manager.users.xam.wayland.windowManager.hyprland.settings =
    let
      lua = lib.generators.mkLuaInline;
      # locked + repeating (was bindel)
      brightness = keys: arg: {
        _args = [
          keys
          (lua ''hl.dsp.exec_cmd("brightnessctl set ${arg}")'')
          { locked = true; repeating = true; }
        ];
      };
    in {
      # Merges with hyprmoon's config.* and hyprland.nix's config.input.kb_variant
      config.input.touchpad = {
        natural_scroll = true;
        tap_to_click = true;
        disable_while_typing = true;
      };

      # Replace (not append to) the desktop monitors from hyprmoon.nix
      monitor = lib.mkForce [
        {
          output = "eDP-1";
          mode = "1920x1080@60";
          position = "0x0";
          scale = "1";
        }
        # Fallback for any plugged-in external screen
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = "1";
        }
      ];

      # Appends to hyprland.nix's bind list
      bind = [
        (brightness "XF86MonBrightnessUp" "+5%")
        (brightness "XF86MonBrightnessDown" "5%-")
      ];
    };
  };
}
