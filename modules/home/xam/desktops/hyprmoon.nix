{ ... }:
{
  flake.nixosModules.hyprmoon = { config, pkgs, lib, ... }: with lib;{
    services.greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --xsessions ${config.services.displayManager.sessionData.desktops}/share/xsessions --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session --user-menu --user-menu-min-uid 1000 --asterisks --power-shutdown 'shutdown -P now' --power-reboot 'shutdown -r now'";
    };

    home-manager.users.xam = {
      home.pointerCursor.enable = true;
      wayland.windowManager.hyprland = {
        settings = {
          general.border_size = 1;
          general.gaps_out = 4;
          decoration.rounding = 3;
          decoration.blur.enabled = false;
          animations.enabled = false;
          debug.disable_logs = true;
        };
      };
    };

    stylix = {
      enable = true;
      autoEnable = true;
      image = ../../../../assets/artemis_moon_dark.png;
      polarity = "dark";
      opacity.terminal = 0.65;

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 20;
      };

      base16Scheme = {
        # background → a bit lighter
        base00 = "#121820";
        base01 = "#1b222c";
        base02 = "#242d38";
        base03 = "#2f3a47";

        # foreground stack → brighter for readability
        base04 = "#9aa5b4";
        base05 = "#c5d0de";
        base06 = "#e0e6f0";
        base07 = "#f2f5fa";

        # accents → slightly more saturated & higher contrast
        base08 = "#e26d6d"; # red-ish
        base09 = "#f2a76b"; # orange
        base0A = "#f6d37a"; # yellow
        base0B = "#7fcf7d"; # green
        base0C = "#6fc6c9"; # cyan
        base0D = "#7aa7ff"; # blue
        base0E = "#c792ea"; # purple
        base0F = "#f28ba8"; # pink-ish
      };
    };
  };
}
