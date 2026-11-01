{ ... }:
{
  flake.nixosModules.hyprmoon = { inputs, config, pkgs, lib, ... }: with lib; {
    imports = [
      inputs.self.nixosModules.hyprland
      inputs.self.nixosModules.waybar
    ];

    services.greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --xsessions ${config.services.displayManager.sessionData.desktops}/share/xsessions --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session --user-menu --user-menu-min-uid 1000 --asterisks --power-shutdown 'shutdown -P now' --power-reboot 'shutdown -r now'";
    };

    # `config` here is the Home Manager config (shadows the NixOS one inside this scope)
    home-manager.users.xam = { config, ... }:
    let
      c = config.lib.stylix.colors;
    in {
      home.pointerCursor.enable = true;

      # Stylix's hyprlang-style output may not be Lua-compatible; theme borders manually.
      stylix.targets.hyprland.enable = false;

      wayland.windowManager.hyprland.settings = {
        config = {
          general = {
            border_size = 1;
            gaps_out = 4;
            col = {
              active_border = "rgb(${c.base0D})";
              inactive_border = "rgb(${c.base02})";
            };
          };
          decoration = {
            rounding = 3;
            blur.enabled = false;
          };
          animations.enabled = false;
          debug.disable_logs = true;
        };

        monitor = [
          # MAG 27CQ6F — 1440p@180, primary (first entry gets workspace 1)
          {
            output = "desc:Microstep MAG 27CQ6F CD9M024401936";
            mode = "2560x1440@180";
            position = "0x0";
            scale = "1";
            vrr = 1;
          }
          # VG248 — 1080p@144, to the left
          {
            output = "desc:Ancor Communications Inc VG248 G4LMQS087053";
            mode = "1920x1080@144";
            position = "-1920x0";
            scale = "1";
            vrr = 1;
          }
        ];
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
