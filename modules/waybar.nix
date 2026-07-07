{ inputs, pkgs, ... }:

{
  flake.nixosModules.waybar = { ... }:
  {
    programs.waybar = {
      enable = true;
      package = pkgs.waybar;
      settings = [
	{
	  layer = "top";
	  position = "bottom";
	  modules-left = [
	    "hyprland/workspaces" 
	  ];
	  modules-center = [ 
	    "hyprland/window"
	  ];
          modules-right = [
	    "custom/nixos-warnings"
	    "disk"
	    #"custom/room_temp"
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
	}
      ];
    };
  };
}
