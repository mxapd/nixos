{ inputs, ... }:

{
  flake.nixosModules.hm-xam = { pkgs, ... }: {
    imports = with inputs.self.nixosModules;[ # TODO: change home manager modules to something else than nixosModules 
      hm-xam-zsh
      hm-ssh
      hm-git
      nixvim
      tmux-notes
      tmux-goose
      tmux-sessionizer
      rebuild
      goose
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
      #calendar
    ];

    home-manager.users.xam = {
      stylix.targets.gtk.flatpakSupport.enable = false; # TODO: find a home for this line, it does not belong here
      programs.nh.enable = true;

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
