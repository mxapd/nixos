{ inputs, ... }:
{
  flake.nixosModules.hyprmoon = { config, pkgs, inputs,... }: { 
    home-manager.users.xam = {  
      wayland.windowManager.hyprland = {
	settings = {
	  general.border_size = 1;
	  general.gaps_out = 6;
	  decoration.rounding = 3;
	  animations.enabled = false; 
	};
      };
    };

    stylix = {
      enable = true;
      image = ../artemis_moon_dark.png;
      polarity = "dark";
      opacity.terminal = 0.95;
     
      cursor.package = pkgs.bibata-cursors;
      cursor.name = "Bibata-Modern-Ice";
      cursor.size = 20;
    
      base16Scheme = {
        base00 = "#0a0d0c";
        base01 = "#121614";
        base02 = "#1c211f";
        base03 = "#3a423f";
        base04 = "#6b7573";
        base05 = "#9aa39f";
        base06 = "#c5cdc9";
        base07 = "#e8ece9";
        base08 = "#b85c50";
        base09 = "#c98a4b";
        base0A = "#d4b96a";
        base0B = "#7a9b7e";
        base0C = "#6f9a95";
        base0D = "#8fa8c2";
        base0E = "#8a7a9b";
        base0F = "#5a4a3f";
      };
    };

  };
}
