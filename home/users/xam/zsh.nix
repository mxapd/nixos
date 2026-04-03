{ pkgs, ... }:

{
  programs.zsh = {
  enable = true;
  syntaxHighlighting.enable = true;


  shellAliases =  {
    mount-ancient= "sudo mount -t cifs //192.168.1.204/video /mnt/ancient_share/video -o username=xam,uid=1000,gid=100,rw && \
		    sudo mount -t cifs //192.168.1.204/books /mnt/ancient_share/books -o username=xam,uid=1000,gid=100,rw";
    nd="nix develop";
    ns="nix shell";
    check="nix flake check --impure";
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
    
    PROMPT='[%1~] •%f '
    RPROMPT='$(git_prompt_info) %T'	
    


    '';

    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
      theme = "wedisagree";
    };
  };
}
