{config, pkgs, ... }: 
{

  imports = [
    ./waybar.nix
  ];
  
  programs.waybar.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;  
    
    settings = {
      
      input = {
      	kb_variant = "altgr-intl";
      };

      general = {

	#"col.active_border" = "rgba(ff0000ff)";
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

	# Screenshot a window
	"$mod, PRINT, exec, hyprshot -m window"
	# Screenshot a monitor
	", PRINT, exec, hyprshot -m output"
	# Screenshot a region
	"$modSHIFT, PRINT, exec, hyprshot -m region"

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

	"$mod,1,workspace,1"
	"$mod,2,workspace,2"
	"$mod,3,workspace,3"
	"$mod,4,workspace,4"
	"$mod,5,workspace,5"
	"$mod,6,workspace,6"
	"$mod,7,workspace,7"
	"$mod,8,workspace,8"
	"$mod,9,workspace,9"

	"$modSHIFT,1,movetoworkspacesilent,1"
	"$modSHIFT,2,movetoworkspacesilent,2"
	"$modSHIFT,3,movetoworkspacesilent,3"
	"$modSHIFT,4,movetoworkspacesilent,4"
	"$modSHIFT,5,movetoworkspacesilent,5"
	"$modSHIFT,6,movetoworkspacesilent,6"
	"$modSHIFT,7,movetoworkspacesilent,7"
	"$modSHIFT,8,movetoworkspacesilent,8"
	"$modSHIFT,9,movetoworkspacesilent,9"

	"$modSHIFT,right,movewindow,r"
	"$modSHIFT,left,movewindow,l"
	"$modSHIFT,up,movewindow,u"
	"$modSHIFT,down,movewindow,d"


	"$modSHIFT,F,togglefloating,active"
	

	"$mod,O, exec, kitty --class tmux-notes -e tmux_toggle_notes"
	];

      bindm = [
	# mouse movements
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

      monitor = [
	#"DP-1, 1920x1080@119.88Hz, 0x0,1"
	"DP-1, 2560x1440@180.00Hz, 0x0,1"
	"DP-3,1920x1080@144.00Hz,-1920x0,1"
      ];
    };
    

    extraConfig = ''
      exec-once = waybar
      exec-once = mako

      input {
  #	kb_options = caps:swapescape
      }
      '';
  };

#xdg.portal.enable = true;
#xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  home.sessionVariables.NIXOS_OZONE_WL= "1";
}
