{ ... }: {
  flake.nixosModules.fonts = { pkgs, ... }: {

    environment.systemPackages = with pkgs; [
      font-awesome
    ];

    fonts = {
      fontconfig.enable = true;

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
        serif = [ "Noto Serif" "DejaVu Serif" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
