# modules/home-manager/programs/desktop/hyprland.nix
# Hyprland Wayland compositor for home-manager
# NOTE: Most hyprland settings are at system level (modules/desktop/desktop.nix)
# This file enables waybar integration

{ self, inputs, ... }:

{
  flake.homeManagerModules.programs.desktop.hyprland = { config, pkgs, lib, ... }:
  {
    # Enable waybar through hyprland module
    programs.waybar.enable = true;

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

        animations = {
          enabled = false;
        };
        
        "$mod" = "SUPER";

        # Keybindings
        bind = [
          "$mod,Return,exec, kitty"
          "$mod,d,exec, wofi --show drun"
          "$mod,w,exec,firefox"
          "$modSHIFT,M,exec, hyprctl dispatch exit"
          "$mod,E,exec, dolphin"

          # Screenshot
          "$mod, PRINT, exec, hyprshot -m window"
          ", PRINT, exec, hyprshot -m output"
          "$modSHIFT, PRINT, exec, hyprshot -m region"

          # Window management
          "$modSHIFT,Q,killactive"
          "$mod,F,fullscreen"
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
          "$mod,0,workspace,10"
          
          # Move to workspaces
          "$modSHIFT,1, movetoworkspace, 1"
          "$modSHIFT,2, movetoworkspace, 2"
          "$modSHIFT,3, movetoworkspace, 3"
          "$modSHIFT,4, movetoworkspace, 4"
          "$modSHIFT,5, movetoworkspace, 5"
          "$modSHIFT,6, movetoworkspace, 6"
          "$modSHIFT,7, movetoworkspace, 7"
          "$modSHIFT,8, movetoworkspace, 8"
          "$modSHIFT,9, movetoworkspace, 9"
          "$modSHIFT,0, movetoworkspace, 10"
          
          # Mouse bindings
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
          
          # Scroll workspaces
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"
        ];

        # Window rules
        windowrulev2 = [
          "float,class:^(pavucontrol)$"
          "float,class:^(nm-connection-editor)$"
          "float,class:^(blueman-manager)$"
        ];
      };
    };
  };
}
