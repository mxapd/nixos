# modules/features/desktop/home.nix
# Desktop Environment - Hyprland, Waybar, Mako (home-manager)

{ config, pkgs, lib, ... }:

{
  # Hyprland window manager configuration
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      input = {
        kb_variant = "altgr-intl";
      };

      general = {
        border_size = 1;
        gaps_out = 8;
      };

      decoration = {
        rounding = 3;
      };

      animations.enabled = false;

      "$mod" = "SUPER";

      bind = [
        "$mod,Return,exec, kitty"
        "$mod,d,exec, wofi --show drun"
        "$mod,w,exec,firefox"
        "$modSHIFT,M,exec, hyprctl dispatch exit"
        "$mod,E,exec, dolphin"

        # Screenshots
        "$mod, PRINT, exec, hyprshot -m window"
        ", PRINT, exec, hyprshot -m output"
        "$modSHIFT, PRINT, exec, hyprshot -m region"

        # Window management
        "$modSHIFT,Q,killactive"
        "$mod,F,fullscreen"

        # Focus movement
        "$mod,left,movefocus,l"
        "$mod,right,movefocus,r"
        "$mod,up,movefocus,u"
        "$mod,down,movefocus,d"
        "$mod,K,movefocus,u"
        "$mod,J,movefocus,d"
        "$mod,H,movefocus,l"
        "$mod,L,movefocus,r"

        # Workspaces
        "$mod,1,workspace,1"
        "$mod,2,workspace,2"
        "$mod,3,workspace,3"
        "$mod,4,workspace,4"
        "$mod,5,workspace,5"
        "$mod,6,workspace,6"
        "$mod,7,workspace,7"
        "$mod,8,workspace,8"
        "$mod,9,workspace,9"

        # Move to workspace
        "$modSHIFT,1,movetoworkspacesilent,1"
        "$modSHIFT,2,movetoworkspacesilent,2"
        "$modSHIFT,3,movetoworkspacesilent,3"
        "$modSHIFT,4,movetoworkspacesilent,4"
        "$modSHIFT,5,movetoworkspacesilent,5"
        "$modSHIFT,6,movetoworkspacesilent,6"
        "$modSHIFT,7,movetoworkspacesilent,7"
        "$modSHIFT,8,movetoworkspacesilent,8"
        "$modSHIFT,9,movetoworkspacesilent,9"

        # Window movement
        "$modSHIFT,right,movewindow,r"
        "$modSHIFT,left,movewindow,l"
        "$modSHIFT,up,movewindow,u"
        "$modSHIFT,down,movewindow,d"

        "$modSHIFT,F,togglefloating,active"

        # Custom scripts
        "$mod,O, exec, kitty --class tmux-notes -e tmux_toggle_notes"
      ];

      bindm = [
        # Mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
      ];

      # Monitor configuration (desktop specific - should be host-configurable)
      monitor = [
        "DP-1, 2560x1440@180.00Hz, 0x0,1"
        "DP-3,1920x1080@144.00Hz,-1920x0,1"
      ];
    };

    extraConfig = ''
      exec-once = waybar
      exec-once = mako
    '';
  };

  # Waybar status bar
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [{
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
        format-icons = [
          "󰤯"
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
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
        tooltip-format = "Click to view warnings (not yet inpmlemented)";
      };
    }];

    style = ''
      @define-color bg-color rgb(68, 71, 90);
      @define-color bg-color-tray rgb (40, 42, 54);
      @define-color bg-color-ws rgb (40, 42, 54);
      @define-color bg-color-0 rgb (40, 42, 54);
      @define-color bg-color-1 rgb(40, 42, 54);
      @define-color bg-color-2 rgb(40, 42, 54);
      @define-color bg-color-3 rgb(40, 42, 54);
      @define-color bg-color-4 rgb(40, 42, 54);
      @define-color bg-color-5 rgb(40, 42, 54);
      @define-color bg-color-6 rgb(40, 42, 54);
      @define-color bg-color-7 rgb(40, 42, 54);
      @define-color bg-color-8 rgb(40, 42, 54);
      @define-color bg-color-9 rgb(40, 42, 54);
      @define-color bg-color-10 rgb(40, 42, 54);
      @define-color bg-color-11 rgb(40, 42, 54);
      @define-color bg-color-12 rgb(40, 42, 54);
      @define-color bg-color-13 rgb(40, 42, 54);
      @define-color bg-color-14 rgb(40, 42, 54);
      @define-color bg-color-15 rgb(40, 42, 54);
      @define-color bg-color-16 rgb(40, 42, 54);

      @define-color fg-color rgb (248, 248, 242);
      @define-color alert-bg-color rgb (255, 85, 85);
      @define-color alert-fg-color rgb (248, 248, 242);
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

      #custom-room_temp {
        margin-right: 25px;
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

      #mode {
          padding: 0 10px;
          margin: 0 4px;
          background-color: @bg-color;
          border-bottom: 3px solid @fg-color;
      }

      #clock {
          padding: 0 10px;
          margin: 0 0px;
          background-color: rgba(0,0,0,0);
          color: @fg-color;
      }

      @keyframes blink {
          to {
              background-color: @fg-color;
              color: @bg-color;
          }
      }

      label:focus {
          background-color: @bg-color;
      }

      #network.disconnected {
          background-color: @alert-bg-color;
      }

      #custom-vpn.disconnected {
          background-color: @alert-bg-color;
      }

      #pulseaudio.muted {
          background-color: @inactive-bg-color;
          color: @inactive-fg-color;
      }

      #custom-media.custom-vlc {
          background-color: @bg-color;
      }

      #temperature.critical {
          background-color: @alert-bg-color;
      }

      #idle_inhibitor.activated {
          background-color: @fg-color;
          color: @bg-color;
      }

      #mpd.disconnected {
          background-color: transparent;
          color: transparent;
      }

      #mpd.stopped {
          background-color: transparent;
          color: transparent;
      }

      #mpd.paused {
          background-color: @inactive-bg-color;
          color: @inactive-fg-color;
      }
    '';
  };

  # Mako notifications
  services.mako = {
    enable = true;
    package = pkgs.mako;
    settings = {
      default-timeout = 7000;
      border-radius = 5;
    };
  };

  # Home session variables for Wayland
  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
