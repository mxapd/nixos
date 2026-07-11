{ ... }:
{
  flake.nixosModules.hm-xam-zsh = { pkgs, ... }: {
    home-manager.users.xam = {
      home.packages = with pkgs; [
	oh-my-zsh
      ];

    programs.zsh = {
      enable = true;
      
      syntaxHighlighting = {
        enable = true;
	highlighters = [ "main" "brackets" ];
      };

      shellAliases =  {
	cd="z";
	mount-ancient="sudo mount -t cifs //ancient/video /mnt/ancient_share/video -o username=xam,uid=1000,gid=100,rw && \
      	    	   sudo mount -t cifs //ancient/books /mnt/ancient_share/books -o username=xam,uid=1000,gid=100,rw";
      	nd="nix develop";
      	ns="nix shell";
      	check="nix flake check";
      	pai="bun ~/.opencode/PAI/Tools/pai.ts";
	v="nvim";
      };

      initContent = ''
        # setting up and binding tmux sessionizer
        
        tmux_sessionizer_widget() {
          zle -I                     
          tmux-sessionizer          
        }

        zle -N tmux_sessionizer_widget
        bindkey '^f' tmux_sessionizer_widget

        # automatically start a tmux session when opening an shell if apropriate
        if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
          exec tmux
        fi

        eval "$(goose term init zsh)"

	# Eastwood-like git status config
	ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[magenta]%}["
	ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_CLEAN=""
	
	git_custom_status() {
	  local cb=$(git_current_branch)
	  if [ -n "$cb" ]; then
	    echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(git_current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX$(parse_git_dirty)"
	  fi
	}
	
	PROMPT='%{$fg[cyan]%}[%~% ]%{$reset_color%}$(git_custom_status)%B$%b '
        '';

        oh-my-zsh = {
          enable = true;
          plugins = ["git"];
          #theme = "wedisagree";
	  #theme = "eastwood";
	};
      };
    };
  };
}
