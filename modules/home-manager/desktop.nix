# modules/home-manager/desktop.nix
# Desktop configuration: Hyprland, waybar, mako

{ self, inputs, lib, pkgs, ... }:

{
  flake.homeModules.desktop = { config, pkgs, lib, ... }:
    let concatStrings = lib.concatStrings; in
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
            modules-right = [ "clock" "tray" "pulseaudio" "network" ];
            "clock" = { format = "{:%H:%M} "; };
            "network" = { interval = "5"; format-wifi = " {signalStrength}% "; };
            "pulseaudio" = { format = "{volume}% "; };
          }
        ];
      };

      services.mako = {
        enable = true;
        package = pkgs.mako;
        settings = {
          default-timeout = 7000;
          border-radius = 5;
        };
      };

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        
        settings = {
          input = { kb_variant = "altgr-intl"; };
          general = { border_size = 1; gaps_out = 8; };
          decoration = { rounding = 3; };
          animations = { enabled = false; };
          "$mod" = "SUPER";
          
          bind = [
            "$mod,Return,exec, kitty"
            "$mod,d,exec, wofi --show drun"
            "$mod,w,exec,firefox"
            "$modSHIFT,M,exec, hyprctl dispatch exit"
            "$modSHIFT,Q,killactive"
            "$mod,F,fullscreen"
            "$mod,1,workspace,1"
            "$mod,2,workspace,2"
            "$mod,3,workspace,3"
            "$modSHIFT,1,movetoworkspace,1"
            "$modSHIFT,2,movetoworkspace,2"
            "$modSHIFT,3,movetoworkspace,3"
          ];
          
          bindel = [
            ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ];
          
          bindl = [
            ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ", XF86AudioPlay, exec, playerctl play-pause"
          ];
        };

        extraConfig = ''
          exec-once = waybar
          exec-once = mako
        '';
      };

      home.sessionVariables.NIXOS_OZONE_WL = "1";
    };
}
