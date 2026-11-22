{ inputs, ... }:

{
  flake.nixosModules.hm-xam = { pkgs, ... }: {
    imports = with inputs.self.nixosModules;[ # TODO: change home manager modules to something else than nixosModules 
      hm-xam-zsh
      hm-ssh
      hm-git
      nixvim
      tmux-notes
      # tmux-goose  # disabled: goose-cli 1.55.0 fails to build in nixpkgs
      tmux-sessionizer
      rebuild
      claude
      # goose  # disabled: goose-cli 1.55.0 fails to build in nixpkgs
      hm-yazi
      open-clipboard-link
      search-clipboard
      tmux
      zoxide
      rust-dev
      kitty
      opencode
      mako
      thunderbird
      #spellbook
      compression-utils
      calendar
    ];

    home-manager.users.xam = {
      imports = [ inputs.cal-tui.homeManagerModules.default ];

      stylix.targets.gtk.flatpakSupport.enable = false; # TODO: find a home for this line, it does not belong here
      stylix.targets.wayprompt.enable = false; # home-manager removed programs.wayprompt; drop once stylix removes its target
      programs.nh.enable = true;

      # Terminal calendar (~/Projects/cal-tui). Writes ~/.config/cal-tui/config.toml,
      # checked at build time.
      programs.cal-tui = {
        enable = true;
        settings = {
          calendars_dir = "~/.calendars"; # where vdirsyncer (calendar.nix) syncs to
          timezone = "Europe/Stockholm";
          default_calendar = "personal";
          sync_command = "vdirsyncer sync"; # `S` in the TUI
          calendars.lnu-timeedit = {
            name = "LNU";
            color = "orange"; # soft colours: orange teal lavender sage sky rose sand
            read_only = true;
          };
          weather.location = "Växjö";
        };
      };

      home = {
        username = "xam";
        homeDirectory = "/home/xam";
        stateVersion = "26.05";

        sessionVariables = {
          OBSIDIAN_VAULT = "/home/xam/Documents/obsidian/";
          EDITOR = "nvim";
          BROWSER = "firefox";
          PATH = "$HOME/.local/bin:$PATH";
	  SOPS_AGE_KEY_FILE = "/home/xam/.age/sops_admin"; 
	};

        packages = with pkgs; [
          kdePackages.dolphin 
          kdePackages.dolphin-plugins

          prismlauncher
	  spotify
          
          vlc
          qbittorrent

          btop
          gotop

          (inputs.bookokrat.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (_old: {
            # Temporary workaround for failing SVG snapshot tests.
            doCheck = false;
          }))
        ];
      };
    };
  };
}
