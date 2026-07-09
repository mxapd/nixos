{ ... }: {
  flake.nixosModules.fonts = { ... }: { 
    # --FONTS-- 
    fonts = {
      fontconfig.enable = true;
    
      # JetBrainsMono Nerd Font: primary monospace (terminal, editor, prompt)
      # symbols-only: glyph fallback for waybar / prompt / nixvim
      # font-awesome + DejaVu: referenced by the waybar CSS
      # Noto + emoji: general text + emoji coverage
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.symbols-only
        font-awesome
        dejavu_fonts
        noto-fonts
        noto-fonts-color-emoji
      ];
    
      fontconfig.defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" "DejaVu Sans Mono" ];
        sansSerif = [ "Noto Sans" "DejaVu Sans" ];
        serif     = [ "Noto Serif" "DejaVu Serif" ];
        emoji     = [ "Noto Color Emoji" ];
      };
    };
  }; 
}
