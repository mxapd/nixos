{ ... }:
{
  flake.nixosModules.hyprland = { pkgs, lib, ... }:
  let
    mod = "SUPER";
    lua = lib.generators.mkLuaInline;

    # hl.bind(keys, dispatcher[, opts])
    bind = keys: dsp: { _args = [ keys (lua dsp) ]; };
    bindWith = opts: keys: dsp: { _args = [ keys (lua dsp) opts ]; };
    exec = keys: cmd: bind keys ''hl.dsp.exec_cmd("${cmd}")'';

    dirs = [
      { key = "left";  vim = "H"; d = "l"; }
      { key = "right"; vim = "L"; d = "r"; }
      { key = "up";    vim = "K"; d = "u"; }
      { key = "down";  vim = "J"; d = "d"; }
    ];

    directionBinds = lib.concatMap (x: [
      (bind "${mod} + ${x.key}" ''hl.dsp.focus({ direction = "${x.d}" })'')
      (bind "${mod} + ${x.vim}" ''hl.dsp.focus({ direction = "${x.d}" })'')
      (bind "${mod} + SHIFT + ${x.key}" ''hl.dsp.window.move({ direction = "${x.d}" })'')
    ]) dirs;

    workspaceBinds = lib.concatMap (i:
      let n = toString i; in [
        (bind "${mod} + ${n}" "hl.dsp.focus({ workspace = ${n} })")
        (bind "${mod} + SHIFT + ${n}" "hl.dsp.window.move({ workspace = ${n}, follow = false })")
      ]) (lib.range 1 9);
  in {

    programs.hyprland.enable = true;

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      wlr.enable = false;
      config = {
        common.default = [ "gtk" ];
        hyprland.default = [ "gtk" "hyprland" ];
      };
      configPackages = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal
      ];
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        #pkgs.xdg-desktop-portal-hyprland
      ];
    };

    home-manager.users.xam = {
      stylix.targets.kde.enable = false;

      programs = {
        wofi.enable = true;

        kitty = {
          enable = true;
          extraConfig = ''
            confirm_os_window_close 0
          '';
        };

        hyprshot.enable = true;
        hyprshot.saveLocation = "$HOME/Pictures/Screenshots/";
      };

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;

        configType = "lua";

        settings = {
          config.input.kb_variant = "altgr-intl";

          env = { _args = [ "HYPRSHOT_DIR" "/home/xam/Pictures/Screenshots" ]; };

          window_rule = {
            name = "opaque-floating";
            match.float = true;
            opacity = "1 1";
          };

          # exec-once = waybar
          on = {
            _args = [
              "hyprland.start"
              (lua ''
                function()
                  hl.dispatch(hl.dsp.exec_cmd("waybar"))
                end
              '')
            ];
          };

          bind = [
            (exec "${mod} + Return" "kitty -e tmux")
            (exec "${mod} + D" "wofi --show drun")
            (exec "${mod} + W" "firefox")
            (exec "${mod} + U" "open-clipboard-link")
            (exec "${mod} + S" "search-clipboard")
            (exec "${mod} + E" "dolphin")
            (exec "${mod} + O" "kitty --class tmux-notes -e /etc/profiles/per-user/xam/bin/tmux-notes")
            (exec "${mod} + G" "kitty --class tmux-goose -e /etc/profiles/per-user/xam/bin/tmux-goose")

            # Screenshots
            (exec "${mod} + PRINT" "hyprshot -m window")
            (exec "PRINT" "hyprshot -m output")
            (exec "${mod} + SHIFT + PRINT" "hyprshot -m region")

            (bind "${mod} + SHIFT + M" "hl.dsp.exit()")
            (bind "${mod} + SHIFT + Q" "hl.dsp.window.close()")
            (bind "${mod} + F" ''hl.dsp.window.fullscreen({ mode = "fullscreen" })'')
            (bind "${mod} + SHIFT + F" ''hl.dsp.window.float({ action = "toggle" })'')

            # Mouse
            (bindWith { mouse = true; } "${mod} + mouse:272" "hl.dsp.window.drag()")
            (bindWith { mouse = true; } "${mod} + mouse:273" "hl.dsp.window.resize()")
            (bindWith { mouse = true; } "${mod} + ALT + mouse:272" "hl.dsp.window.resize()")

            # Volume (was bindel: locked + repeating)
            (bindWith { locked = true; repeating = true; } "XF86AudioRaiseVolume"
              ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")'')
            (bindWith { locked = true; repeating = true; } "XF86AudioLowerVolume"
              ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")'')

            # Media (was bindl: locked)
            (bindWith { locked = true; } "XF86AudioMute"
              ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")'')
            (bindWith { locked = true; } "XF86AudioPlay" ''hl.dsp.exec_cmd("playerctl play-pause")'')
            (bindWith { locked = true; } "XF86AudioPrev" ''hl.dsp.exec_cmd("playerctl previous")'')
            (bindWith { locked = true; } "XF86AudioNext" ''hl.dsp.exec_cmd("playerctl next")'')
          ] ++ directionBinds ++ workspaceBinds;
        };
      };

      home.sessionVariables.NIXOS_OZONE_WL = "1";
    };
  };
}

