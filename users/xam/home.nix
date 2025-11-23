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
    
      ];
    };

    stylix.targets.hyprland.enable = true;
  
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
    };

    
    services.mako = {
      enable = true;
      package = pkgs.mako;
      #default-timeout = 7000;
      settings = {
	border-radius = 5;
      };
    };
}
