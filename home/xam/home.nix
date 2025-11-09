{ config, pkgs, ... }:

{
  home.username = "xam";

  home.homeDirectory = "/home/xam";

  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    oh-my-zsh
    git-credential-manager
    
    (python3.withPackages (ppkgs: [
      ppkgs.matplotlib
      ppkgs.pytest
    ]))

    zoxide
    
    (writeShellScriptBin "hello" ''
      echo "hello world"
    '')
    
    (writeShellScriptBin "tmux-sessionizer" (builtins.readFile /home/xam/nixos/scripts/tmux-sessionizer))
    
  ];

  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;

  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.cpu
      {
	plugin = tmuxPlugins.resurrect;
	extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
	plugin = tmuxPlugins.continuum;
	extraConfig = ''
	  set -g @continuum-restore 'on'
	  set -g @continuum-save-interval '1' # minutes
	'';
      }
    ];
  };

  programs.git = {
    enable = true;
      userName = "xam";
      userEmail = "m.porseryd@gmail.com";
      extraConfig = {
	credential.helper = "manager";
	credential."https://gitlab.lnu.se".username = "Max Porseryd";
	credential."https://gitlab.lnu.se".email = "mp224hv@student.lnu.se";
	credential."https://github.com".username = "mxapd";
	credential.credentialStore = "cache";
      };
    };
    stylix.targets.hyprland.enable = true; 
    stylix.targets.kde.enable = false;
    imports = [
      #./modules/neovim/neovim.nix
      ./modules/nixvim/nixvim.nix
      ./modules/hyprland/hyprland.nix
    ];


    home.sessionVariables = {
      OBSIDIAN_VAULT = "/home/xam/Documents/digitalbrain";
    };

    programs.kitty = {
      enable = true;
      extraConfig = ''
       confirm_os_window_close 0
      '';
    };

    services.mako = {
      enable = true;
      package = pkgs.mako;
      default-timeout = 7000;
      settings = {
      border-radius = 5;
      };
    };

    home.sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      PATH = "$HOME/.local/bin:$PATH";
    };

    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      shellAliases =  {
	rebuild = "sudo nixos-rebuild switch --flake ~/nixos/ --impure";
	oo = "source /home/xam/nixos/modules/shellscripts/open_vault.sh";
      };

      initContent = ''
      tmux_sessionizer_widget() {
	zle -I                     
	tmux-sessionizer          
      }
      zle -N tmux_sessionizer_widget
      bindkey '^f' tmux_sessionizer_widget

      if [ -z "$SSH_AUTH_SOCK" ]; then
	eval "$(ssh-agent -s)" > /dev/null
	ssh-add ~/.ssh/lnu_ed25519 2>/dev/null
	#ssh-add /home/xam/.ssh/github_mxapd_ed25519 2>/dev/null
      fi

      if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
      exec tmux
      fi
      '';

      oh-my-zsh = {
	enable = true;
	plugins = ["git"];
	theme = "wedisagree";
      };
    };
  }

