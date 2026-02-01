{ config, pkgs, ... }:

{
  home = {
      username = "xam";
      homeDirectory = "/home/xam";      
      stateVersion = "23.05";         
    
      sessionVariables = {
	OBSIDIAN_VAULT = "/home/xam/Documents/obsidian/";
	EDITOR = "nvim";
	BROWSER = "firefox";
	PATH = "$HOME/.local/bin:$PATH";
      };
      
      packages = with pkgs; [
	oh-my-zsh
	git-credential-manager
	zoxide
	(python3.withPackages (ppkgs: [
	  ppkgs.matplotlib
	  ppkgs.pytest
	]))

    
	(writeShellScriptBin "tmux-sessionizer" (builtins.readFile /home/xam/nixos/scripts/tmux-sessionizer))
	(writeShellScriptBin "tmux_toggle_notes" (builtins.readFile /home/xam/nixos/scripts/tmux_notes_toggle))
    
      ];
    };

  stylix.targets.hyprland.enable = true;
  #stylix.targets.gnome.enable = false;
    imports = [
      #./modules/neovim/neovim.nix
      ./../../modules/nixvim/nixvim.nix
      ./../../modules/hyprland/hyprland.nix
    ];

    programs = {
      zoxide.enable = true;
      zoxide.enableZshIntegration = true;                            	
                                                                   
      tmux = {                                                            
        enable = true;
        plugins = with pkgs; [                                            
	#          tmuxPlugins.cpu                                                   
	#   {                                                                 
       	#     plugin = tmuxPlugins.resurrect;                                 
       	#     extraConfig = "set -g @resurrect-strategy-nvim 'session'";      
       	#   }                                                                 
       	#   {                                                                 
       	#     plugin = tmuxPlugins.continuum;                                 
       	#     extraConfig = ''                                                
       	# set -g @continuum-restore 'on'                                
       	# set -g @continuum-save-interval '1' # minutes                 
       	#     '';                                                             
       	#   }                                                                 
       	 ];
      #	extraConfig = '
      #	  bind-key o split-window -h -c $OBSIDIAN_VAULT "nvim"
      #	  bind-key o run-shell "tmux has-session -t notes || tmux new-session -s notes -d -c $OBSIDIAN_VAULT 'nvim'; tmux switch-client -t notes"
      #	'';
      };

      git = {
        enable = true;
        userName = "xam";
        userEmail = "m.porseryd@gmail.com";
        extraConfig = {
	  credential = {
            helper = "manager";
            "https://gitlab.lnu.se".username = "Max Porseryd";
            "https://gitlab.lnu.se".email = "mp224hv@student.lnu.se";
            "https://github.com".username = "mxapd";
            credentialStore = "cache";
          };
        };
      };  
      
      kitty = {
        enable = true;
        extraConfig = ''
         confirm_os_window_close 0
        '';
      };

      zsh = {
	enable = true;
      	syntaxHighlighting.enable = true;
      	

	shellAliases =  {
	#rebuild = "rebuild_with_commit";
	  nd="nix develop";
	  ns="nix shell";
      	};

      initContent = ''
	# setting up and binding tmux sessionizer
      	tmux_sessionizer_widget() {
      	  zle -I                     
      	  tmux-sessionizer          
      	}
      	zle -N tmux_sessionizer_widget
      	bindkey '^f' tmux_sessionizer_widget

	# loading ssh keys
      	if [ -z "$SSH_AUTH_SOCK" ]; then
      	  eval "$(ssh-agent -s)" > /dev/null
      	  ssh-add ~/.ssh/lnu_ed25519 2>/dev/null
      	fi

	# automatically start a tmux session when opening an shell if apropriate
      	if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
	  exec tmux
      	fi

      rebuild_with_commit() {
	echo "Rebuilding NixOS configuration..."
      
	ret=$(pwd)
	cd ~/nixos/

	if sudo -E nixos-rebuild switch --flake .# --impure ; then
	  echo "Rebuild successfull"

	  # Prompt for commit
	  read -r "Commit: " msg

	  if [ -z "$msg" ]; then
	    msg="Update $(date '+%Y-%m-%d %H:%M:%S')"
	  fi

	  git add .
	  git commit -am "$msg"
	  git push
	  echo "✅ Committed and pushed: '$msg'"
	else
	  echo "❌ Rebuild failed — no changes committed."
	fi
	cd $ret

      }

	alias rebuild="rebuild_with_commit"

	PROMPT='[%1~] •%f '
	RPROMPT='$(git_prompt_info) %T'	
      	
	'';

      	oh-my-zsh = {
      	  enable = true;
      	  plugins = ["git"];
      	  theme = "wedisagree";
      	};
      };
    };

    
    services.mako = {
      enable = true;
      package = pkgs.mako;
      settings = {
	default-timeout = 7000;
	border-radius = 5;
      };
    };
}
