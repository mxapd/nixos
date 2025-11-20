{ pkgs, ...}:
{
  stylix = {
    enable = true;
    image = /home/xam/Pictures/wallpapers/eclipse.png;
    polarity = "dark";
    opacity.terminal = 0.95;
    
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;

    # orange purple gray or something
    # base16Scheme = {
    #   base00 = "151515";
    #   base01 = "202020";
    #   base02 = "303030";
    #   base03 = "505050";
    #   base04 = "b0b0b0";
    #   base05 = "d0d0d0";
    #   base06 = "e0e0e0";
    #   base07 = "f5f5f5";
    #   base08 = "fb9fb1";
    #   base09 = "eda987";
    #   base0A = "ddb26f";
    #   base0B = "acc267";
    #   base0C = "12cfc0";
    #   base0D = "6fc2ef";
    #   base0E = "e1a3ee";
    #   base0F = "deaf8f";
    # };

    #gruvbox-dark-hard
    # base16Scheme = {
    #   base00 = "#1d2021"; # ----
    #   base01 = "#3c3836"; # ---
    #   base02 = "#504945"; # --
    #   base03 = "#665c54"; # -
    #   base04 = "#bdae93"; # +
    #   base05 = "#d5c4a1"; # ++
    #   base06 = "#ebdbb2"; # +++
    #   base07 = "#fbf1c7"; # ++++
    #   base08 = "#fb4934"; # red
    #   base09 = "#fe8019"; # orange
    #   base0A = "#fabd2f"; # yellow
    #   base0B = "#b8bb26"; # green
    #   base0C = "#8ec07c"; # aqua/cyan
    #   base0D = "#83a598"; # blue
    #   base0E = "#d3869b"; # purple
    #   base0F = "#d65d0e"; # brown
    # };

    #gruvbox-dark-soft
    #   base16Scheme = {  
    #     base00 = "#32302f"; # ----
    #     base01 = "#3c3836"; # ---
    #     base02 = "#504945"; # --
    #     base03 = "#665c54"; # -
    #     base04 = "#bdae93"; # +
    #     base05 = "#d5c4a1"; # ++
    #     base06 = "#ebdbb2"; # +++
    #     base07 = "#fbf1c7"; # ++++
    #     base08 = "#fb4934"; # red
    #     base09 = "#fe8019"; # orange
    #     base0A = "#fabd2f"; # yellow
    #     base0B = "#b8bb26"; # green
    #     base0C = "#8ec07c"; # aqua/cyan
    #     base0D = "#83a598"; # blue
    #     base0E = "#d3869b"; # purple
    #     base0F = "#d65d0e"; # brown
  # };  

    #gruvbox-material-hard
        base16Scheme = {
          base00 = "#202020";
          base01 = "#2a2827";
          base02 = "#504945";
          base03 = "#5a524c";
          base04 = "#bdae93";
          base05 = "#ddc7a1";
          base06 = "#ebdbb2";
          base07 = "#fbf1c7";
          base08 = "#ea6962";
          base09 = "#e78a4e";
          base0A = "#d8a657";
          base0B = "#a9b665";
          base0C = "#89b482";
          base0D = "#7daea3";
          base0E = "#d3869b";
          base0F = "#bd6f3e";
        };

    #dracula base24
    #  base16Scheme = {
    #    base00 = "#282a36";
    #    base01 =  "#363447";
    #    base02 =  "#44475a";
    #    base03 =  "#6272a4";
    #    base04 =  "#9ea8c7";
    #    base05 =  "#f8f8f2";
    #    base06 =  "#f0f1f4";
    #    base07 =  "#ffffff";
    #    base08 =  "#ff5555";
    #    base09 =  "#ffb86c";
    #    base0A =  "#f1fa8c";
    #    base0B =  "#50fa7b";
    #    base0C =  "#8be9fd";
    #    base0D =  "#80bfff";
    #    base0E =  "#ff79c6";
    #    base0F =  "#bd93f9";
    # };
  };
}
